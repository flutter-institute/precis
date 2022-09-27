// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:characters/characters.dart';
import 'package:meta/meta.dart';
import 'package:unorm_dart/unorm_dart.dart' as unorm;

import 'character.dart';
import 'exceptions.dart';
import 'width_mapper.dart';

part 'profiles/nickname.dart';
part 'profiles/opaque_string.dart';
part 'profiles/username.dart';

String _us(int charCode) => String.fromCharCode(charCode);

/// Interface to define the Precis Profile as defined by RFC8265
abstract class PrecisProfile {
  final bool _identifierClass;

  /// Initialize the identifierClass
  /// [_identifierClass] should be `true` if this is an "IdentifierClass"
  /// [_identifierClass] should be `false` if this is a "FreeFormClass"
  PrecisProfile._(this._identifierClass);

  /// Prepare [value] by ensuring only that the characters in an
  /// individual string are allowed by the underlying PRECIS rules.
  /// Returns the same string [value] for convenience
  /// Throws InvalidCodePointException if the [input] contains invalid code points
  String prepare(String input) {
    final runes = input.runes.iterator;
    while (runes.moveNext()) {
      var codePoint = runes.current;

      var valid = false;
      if (_isExceptionallyValid(codePoint)) {
        valid = true;
      } else if (_isExceptionallyDisallowed(codePoint)) {
        valid = false;
      } else if (_isBackwardsCompatible(codePoint)) {
        valid = true;
      } else if (isUnassigned(codePoint)) {
        valid = false;
      } else if (_isAscii7(codePoint)) {
        valid = true;
      } else if (_isJoinControl(codePoint)) {
        valid = false;
      } else if (_isOldHanguJamo(codePoint)) {
        valid = false;
      } else if (_isIgnoreable(codePoint)) {
        valid = false;
      } else if (_isControl(codePoint)) {
        valid = false;
      } else if (hasCompatibilityEquivalent(codePoint)) {
        valid = !_identifierClass;
      } else if (_isLetterDigit(codePoint)) {
        valid = true;
      } else if (_isOtherLetterDigit(codePoint)) {
        valid = !_identifierClass;
      } else if (_isSpace(codePoint)) {
        valid = !_identifierClass;
      } else if (_isSymbol(codePoint)) {
        valid = !_identifierClass;
      } else if (_isPunctuation(codePoint)) {
        valid = !_identifierClass;
      }

      if (!valid) {
        throw InvalidCodePointException(
            'Invalid code point at glyph ${runes.rawIndex}: 0x${codePoint.toRadixString(16)}');
      }
    }

    return input;
  }

  /// Apply all the PRECIS rules to [input].
  /// This first applies the profile rules, then the behavioral rules as per RFC 7564 §7
  /// Throws InvalidCodePointException if the [input] contains invalid code points
  /// Throws InvalidDirectionalityException if there are invalid LTR and RTL character mixes
  /// Throws EnforcementException for other errors (like empty strings)
  /// Returns the formatted string
  String enforce(String input) {
    return prepare(
      _applyDirectionalityRule(
        _applyNormalizationRule(
          _applyCaseMappingRule(
            _applyAdditionalMappingRule(
              _applyWidthMappingRule(input),
            ),
          ),
        ),
      ),
    );
  }

  /// A [Comparator] that compares one comparable to another.
  ///
  /// It returns the result of `a.compareTo(b)` after rule enforcement.
  /// The call may fail at run-time if [a] is not comparable to the type of [b].
  ///
  /// This utility function is used as the default comparator
  /// for ordering collections, for example in the [List] sort function.
  int compare(String a, String b) =>
      toComparableString(a).compareTo(toComparableString(b));

  /// Converts the given [input] to a comparable string after
  /// applying the PRECIS rules for comparison to the underlying
  /// string.
  /// Returns the comparable String
  String toComparableString(String input) => enforce(input);

  /// The width mapping rule of a profile specifies whether width mapping is performed
  /// on the characters of a string and how the mapping is done
  String _applyWidthMappingRule(String input);

  /// The additional mapping rule of a profile specifies whether additional mappings
  /// are performed on the characters of a string
  String _applyAdditionalMappingRule(String input);

  /// The case mapping rule of a profile specifies whether case mapping (instead of
  /// case preservation) is performed on a string and how the mapping is applied.
  String _applyCaseMappingRule(String input);

  /// The normalization rule of a profile specifies which Unicode normalization form
  /// (D, KD, C, or KC) is to be applied.
  /// In accordance with RFC 5198, normalization form C (NFC) is RECOMMENDED
  String _applyNormalizationRule(String input);

  /// The direction rule of a profile specifies how to treat string containing what
  /// are often called "right-to-left" (RTL) characters.
  String _applyDirectionalityRule(String input);

  /// Applying the rules for any given PRECIS profile is not necessarily an idempotent
  /// procedure. Therefore an implementation SHOULD apply the rules repeatedly until the
  /// output string is stable. If the output string does not stabilize after reapplying
  /// the rules three additional times, the implementation SHOULD terminate the
  /// application of the rules and reject the input string as invalid.
  ///
  /// Example: Under certain circumstances (like using Normalization Form KC), perfomring
  /// Unicode normalization after case mapping can still yield uppercase characters for
  /// certain code points. Applying the rules again, can properly lowercase them.
  String _stabilize(String input, String Function(String) rules) {
    var s1 = rules(input);
    for (int i = 0; i < 3; i++) {
      final s2 = rules(s1);
      if (s1 == s2) {
        // Output string is stable
        return s2;
      }
      s1 = s2;
    }

    // Input string did not stabilize, reject as invalid
    throw InvalidCodePointException(
        'Input string did not stabilize after applying the rules three additional times.');
  }

  /// Regex to match unicode whitspace
  static final WHITESPACE = RegExp(r'\p{Zs}', unicode: true);

  /// Used for the Bidi Rule.
  /// EN, ES, CS, ET, ON, BN or NSM
  static const _EN_ES_CS_ET_ON_BN_NSM =
      1 << Character.DirectionalityEuropeanNumber |
          1 << Character.DirectionalityEuropeanNumberSeparator |
          1 << Character.DirectionalityCommonNumberSeparator |
          1 << Character.DirectionalityEuropeanNumberTerminator |
          1 << Character.DirectionalityOtherNeutrals |
          1 << Character.DirectionalityBoundaryNeutral |
          1 << Character.DirectionalityNonspacingMark;

  /// Used for the Bidi Rule.
  /// L, EN, ES, CS, ET, ON, BN, or NSM
  /// "DirectionalityLeftToRight" is 0, so we're ignoring it
  static const _L_EN_ES_CS_ET_ON_BN_NSM = 1 | _EN_ES_CS_ET_ON_BN_NSM;

  /// Used for the Bidi Rule.
  /// R, AL, AN, EN, ES, CS, ET, ON, BN, OR NSM
  static const _R_AL_AN_EN_ES_CS_ET_ON_BN_NSM =
      1 << Character.DirectionalityRightToLeft |
          1 << Character.DirectionalityRightToLeftArabic |
          1 << Character.DirectionalityArabicNumber |
          _EN_ES_CS_ET_ON_BN_NSM;

  /// Used for the Bidi Rule.
  /// EN or AN
  static const _EN_AN = 1 << Character.DirectionalityEuropeanNumber |
      1 << Character.DirectionalityArabicNumber;

  /// Returns true if the [codeUnit] is a letter or digit character
  static bool _isLetterDigit(int codeUnit) {
    // Ll, Lu, Lo, Nd, Lm, Mn, Mc
    final type = Character.getType(codeUnit);
    // Woooow dart... your auto formatting is quite broken here
    return ((((1 << Character.LowercaseLetter) |
                    (1 << Character.UpppercaseLetter) |
                    (1 << Character.OtherLetter) |
                    (1 << Character.DecimalDigitNumber) |
                    (1 << Character.ModifierLetter) |
                    (1 << Character.NonSpacingMark) |
                    (1 << Character.CombiningSpacingMark)) >>
                type) &
            1) !=
        0;
  }

  /// Returns `true` if [codeUnit] is in the exception category
  static bool _isExceptionallyValid(int codeUnit) {
    switch (codeUnit) {
      case 0x00DF: // latin small letter sharp s
      case 0x03C2: // greek small leter final sigma
      case 0x06FD: // arabic sign sindhi ampersand
      case 0x06FE: // arabic sign sindhi postposition men
      case 0x0F0B: // tibetan mark intersyllabic tsheg
      case 0x3007: // ideographic number zero
        return true;
    }

    return false;
  }

  /// Returns `true` if the [codeUnit] is in the exception category
  static bool _isExceptionallyDisallowed(int codeUnit) {
    switch (codeUnit) {
      case 0x0640: // arabic tatweel
      case 0x074A: // nko lajanyalan
      case 0x302E: // hangul single dot tone mark
      case 0x302F: // hangul double dot tone mark
      case 0x3031: // vertical kana repeat mark
      case 0x3032: // vertical kana repeat with voiced sound mark
      case 0x3033: // vertical kana repeat mark upper half
      case 0x3034: // vertical kana repeat with voide sound mark upper half
      case 0x3035: // vertical kana repeat mark lower half
      case 0x303B: // vertical ideographic iteration mark
        return true;
    }

    return false;
  }

  /// Returns `true` if the code point is backwards compatible
  static bool _isBackwardsCompatible(int codeUnit) {
    // This category is an empty set, therefore return false
    return false;
  }

  /// Returns `true` if [codeUnit] is a join control character
  static bool _isJoinControl(int codeUnit) {
    switch (codeUnit) {
      case 0x200C: // zero width non-joiner
      case 0x200D: // zero width joiner
        return true;
    }

    return false;
  }

  /// Returns `true` if [codeUnit] is an Old Hangul Jamo
  static bool _isOldHanguJamo(int codeUnit) {
    return (codeUnit >= 0x1100 && codeUnit <= 0x11FF) // Hangul Jamo
        ||
        (codeUnit >= 0xA960 && codeUnit <= 0xA97F) // Hangul Jamo Extended-A
        ||
        (codeUnit >= 0xD7B0 && codeUnit <= 0xD7FF); // Hangul Jamo Extended-B
  }

  /// Returns `true` if [codeUnit] is unassigned
  static bool isUnassigned(int codeUnit) {
    // General_Category(codeUnit) is in {Cn} and
    // Noncharacter_CodePoint(codeUnit) == False
    return !Character.isDefined(codeUnit) && !_isNonCharacter(codeUnit);
  }

  /// Returns `true` if [codeUnit] is in the ASCII7 category
  static bool _isAscii7(int codeUnit) {
    return codeUnit >= 0x0021 && codeUnit <= 0x007E;
  }

  /// Returns `true` if the [codeUnit] is a control character
  static bool _isControl(int codeUnit) {
    return Character.isISOControl(codeUnit);
  }

  /// Returns `true` if the [codeUnit] is something we can ignore
  static bool _isDefaultIgnorable(int codeUnit) {
    return codeUnit == 0x00AD ||
        codeUnit == 0x034F ||
        codeUnit == 0x061C ||
        (codeUnit >= 0x115F && codeUnit <= 0x1160) ||
        (codeUnit >= 0x17B4 && codeUnit <= 0x17B5) ||
        (codeUnit >= 0x180B && codeUnit <= 0x180E) ||
        (codeUnit >= 0x200B && codeUnit <= 0x200F) ||
        (codeUnit >= 0x202A && codeUnit <= 0x202E) ||
        (codeUnit >= 0x2060 && codeUnit <= 0x206F) ||
        codeUnit == 0x3164 ||
        (codeUnit >= 0xFE00 && codeUnit <= 0xFE0F) ||
        codeUnit == 0xFEFF ||
        codeUnit == 0xFFA0 ||
        (codeUnit >= 0xFFF0 && codeUnit <= 0xFFF8);
  }

  /// Returns `true` if the [codeUnit] is for a non-character
  static bool _isNonCharacter(int codeUnit) {
    return (codeUnit >= 0xFDD0 && codeUnit <= 0xFDEF) ||
        (codeUnit >= 0xFFFE && codeUnit <= 0xFFFF);
  }

  /// Returns `true` if the [codeUnit] is ignorable
  static bool _isIgnoreable(int codeUnit) {
    return _isDefaultIgnorable(codeUnit) || _isNonCharacter(codeUnit);
  }

  /// Returns `true` if the [codeUnit] is a space character ("Zs")
  static bool _isSpace(int codeUnit) {
    return (((1 << Character.SpaceSeparator) >> Character.getType(codeUnit)) &
            1) !=
        0;
  }

  /// Returns `true` if the [codeUnit] is a symbol character ("Sm", "Sc", "Sk", or "So")
  static bool _isSymbol(int codeUnit) {
    return ((((1 << Character.MathSymbol) |
                    (1 << Character.CurrencySymbol) |
                    (1 << Character.ModifierSymbol) |
                    (1 << Character.OtherSymbol)) >>
                Character.getType(codeUnit)) &
            1) !=
        0;
  }

  /// Returns `true` if the [codeUnit] is a punctuation character ("Pc", "Pd", "Ps", "Pe", "Pi", "Pf" or "Po")
  static bool _isPunctuation(int codeUnit) {
    return ((((1 << Character.ConnectorPunctuation) |
                    (1 << Character.DashPunctuation) |
                    (1 << Character.StartPunctuation) |
                    (1 << Character.EndPunctutation) |
                    (1 << Character.InitialQuotePunctuation) |
                    (1 << Character.FinalQuotePunctuation) |
                    (1 << Character.OtherPunctuation)) >>
                Character.getType(codeUnit)) &
            1) !=
        0;
  }

  /// Returns `true` if the [codeUnit] has compatibility equivalents as explained in the Unicode Standard.
  static bool hasCompatibilityEquivalent(int codeUnit) {
    // toNFKC(codeUnit) != codeUnit
    final original = _us(codeUnit);
    final normalized = unorm.nfkc(original);
    return original != normalized;
  }

  /// Returns `true` if the [codeUnit] is in the category of letters/digits other than the "traditional" letters/digits
  /// Category Lt, Nl, No, Me
  static bool _isOtherLetterDigit(int codeUnit) {
    return ((((1 << Character.TitlecaseLetter) |
                    (1 << Character.LetterNumber) |
                    (1 << Character.OtherNumber) |
                    (1 << Character.EnclosingMark)) >>
                Character.getType(codeUnit)) &
            1) !=
        0;
  }

  /// Maps full-width and half-width characters from [input] to their decomposition mappings
  static String _widthMap(String input) {
    final map = WidthMapper.instance().widthMap;

    final buffer = StringBuffer();
    for (var cp in input.runes) {
      var ch = _us(cp);
      buffer.write(map[ch] ?? ch);
    }

    return buffer.toString();
  }

  /// Applies the default case folding to a string.
  static String _caseMap(String input) {
    return input.characters.toLowerCase().toString();
  }

  /// Returns `true` if the specified text requires bidi analysis. If this returns
  /// false, the text will display LTR. Text in the Arabic Presentation Forms of
  /// Unicode is presumed to already be shaped and ordered for display, and so will
  /// not cause this method to return true.
  static bool _requiresBidi(String input, [int start = 0, int? limit]) {
    limit ??= input.length;

    if (start < 0 || start > limit) {
      throw RangeError.range(start, 0, limit);
    } else if (limit > input.length) {
      throw RangeError.range(limit, start, input.length);
    }

    const RTLMask = (1 << Character.BidiRightToLeft |
        1 << Character.DirectionalityRightToLeftArabic |
        1 << Character.DirectionalityRightToLeftEmbedding |
        1 << Character.DirectionalityRightToLeftOverride |
        1 << Character.DirectionalityArabicNumber);

    final toCheck = input.substring(start, limit).runes;
    for (var codePoint in toCheck) {
      final direction = Character.getDirectionality(codePoint);
      if (direction != Character.DirectionalityUndefined &&
          (1 << direction) & RTLMask != 0) {
        return true;
      }
    }

    return false;
  }

  /// Checks the Bidi Rule
  /// throws [InvalidDirectionalityException] if the input violates the bidi rules
  @visibleForTesting
  static checkBidiRule(String? input) {
    if (input == null || input.isEmpty) {
      return;
    }

    int position = 0;
    final labelCPs = input.runes.toList();
    // 1. The first character must be a character from Bidi property L, R, or AL.
    // If it has the R or AL property, it is an RTL input
    // If it has the L property, it is an LTR input
    final dir1stChar = Character.getDirectionality(labelCPs[position++]);
    final isLTRLabel = dir1stChar == Character.DirectionalityLeftToRight;
    final isRTLLabel = dir1stChar == Character.DirectionalityRightToLeft ||
        dir1stChar == Character.DirectionalityRightToLeftArabic;

    if (!isLTRLabel && !isRTLLabel) {
      throw InvalidDirectionalityException(
          'Bidi Rule 1: The first character must be a character with Bidi property L, R, or AL.');
    }

    // In order to check condition 3 and 6, get the Bidi property of the last character, which doesn't have the NSM property.
    late int dirLastNonNSMChar;
    int nonNSMLen;
    for (nonNSMLen = labelCPs.length - 1; nonNSMLen >= 0; nonNSMLen--) {
      dirLastNonNSMChar = Character.getDirectionality(labelCPs[nonNSMLen]);
      if (dirLastNonNSMChar != Character.DirectionalityNonspacingMark) {
        break;
      }
    }

    int dirMask = 0;
    while (position < nonNSMLen) {
      final cp = labelCPs[position++];
      dirMask |= 1 << Character.getDirectionality(cp);
    }

    if (isRTLLabel) {
      // 2. In an RTL label, only characters with the Bidi properties below are allowed:
      // R, AL, AN, EN, ES, CS, ET, ON, BN, or NSM
      if ((dirMask & ~_R_AL_AN_EN_ES_CS_ET_ON_BN_NSM) != 0) {
        throw InvalidDirectionalityException(
            'Bidi Rule 2: In an RTL label, only characters with Bidi properties R, AL, AN, EN, ES, CS, ET, ON, BN, or NSM are allowed.');
      }

      // 3. In an RTL label, the end of the label must be a character with the following Bidi property
      // R, AL, EN or AN, and it must be followed by zero or more characters with Bidi property NSM
      if (dirLastNonNSMChar != Character.DirectionalityRightToLeft &&
          dirLastNonNSMChar != Character.DirectionalityRightToLeftArabic &&
          dirLastNonNSMChar != Character.DirectionalityEuropeanNumber &&
          dirLastNonNSMChar != Character.DirectionalityArabicNumber) {
        throw InvalidDirectionalityException(
            'Bidi Rule 3: In an RTL label, the end of the label must be a character with Bidi property R, AL, EN, or AN.');
      }

      // Create a mask including the last non NSM character
      int fullMask = dirMask | 1 << dirLastNonNSMChar;

      // 4. In an RTL label, if an EN is present, no AN may be present, and vice versa
      if ((fullMask & _EN_AN) == _EN_AN) {
        throw InvalidDirectionalityException(
            'Bidi Rule 4: In an RTL label, if an EN is present, no AN may be present, and vice versa.');
      }
    } else {
      // 5. In an LTR label, only characters with the Bidi properties below are allowed:
      // ES, CS, ET, ON, BN, or NSM
      if ((dirMask & ~_L_EN_ES_CS_ET_ON_BN_NSM) != 0) {
        throw InvalidDirectionalityException(
            'Bidi Rule 5: In an LTR label, only characters with the Bidi properties L, EN, ES, CS, ET, ON, BN, or NSM are allowed.');
      }

      // 6. In an LTR label, the end of the label must be a character with Bidi property L or EN, and it
      // must be followed by zero or more characters with Bidi property NSM
      if (dirLastNonNSMChar != Character.DirectionalityLeftToRight &&
          dirLastNonNSMChar != Character.DirectionalityEuropeanNumber) {
        throw InvalidDirectionalityException(
            'Bidi Rule 6: In an LTR label, the end of the label must be a character with Bidi property L or EN.');
      }
    }
  }
}
