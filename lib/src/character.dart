// ignore_for_file: constant_identifier_names

import 'character_data.dart';

class Character {
  /// Don't allow to be constructed or extended
  Character._();

  /// Bidi denotation for LTR handling
  static const BidiLeftToRight = 0;

  /// Bidi denotation for RTL handling
  static const BidiRightToLeft = 1;

  /// Undefined bidirectional character type
  static const DirectionalityUndefined = -1;

  /// Strong bidirectional character type "L" in the unicode specification
  static const DirectionalityLeftToRight = 0;

  /// Strong bidirectional character type "R" in the unicode specification
  static const DirectionalityRightToLeft = 1;

  /// Strong bidirectional character type "AL" in the Unicode specification.
  static const DirectionalityRightToLeftArabic = 2;

  /// Weak bidirectional character type "EN" in the Unicode specification.
  static const DirectionalityEuropeanNumber = 3;

  /// Weak bidirectional character type "ES" in the Unicode specification.
  static const DirectionalityEuropeanNumberSeparator = 4;

  /// Weak bidirectional character type "ET" in the Unicode specification.
  static const DirectionalityEuropeanNumberTerminator = 5;

  /// Weak bidirectional character type "AN" in the Unicode specification.
  static const DirectionalityArabicNumber = 6;

  /// Weak bidirectional character type "CS" in the Unicode specification.
  static const DirectionalityCommonNumberSeparator = 7;

  /// Weak bidirectional character type "NSM" in the Unicode specification.
  static const DirectionalityNonspacingMark = 8;

  /// Weak bidirectional character type "BN" in the Unicode specification.
  static const DirectionalityBoundaryNeutral = 9;

  /// Neutral bidirectional character type "B" in the Unicode specification.
  static const DirectionalityParagraphSeparator = 10;

  /// Neutral bidirectional character type "S" in the Unicode specification.
  static const DirectionalitySegmentSeparator = 11;

  /// Neutral bidirectional character type "WS" in the Unicode specification.
  static const DirectionalityWhitespace = 12;

  /// Neutral bidirectional character type "B" in the Unicode specification.
  static const DirectionalityOtherNeutrals = 13;

  /// Strong bidirectional character type "LRE" in the Unicode specification.
  static const DirectionalityLeftToRightEmbedding = 14;

  /// Strong bidirectional character type "LRO" in the Unicode specification.
  static const DirectionalityLeftToRightOverride = 15;

  /// Strong bidirectional character type "RLE" in the Unicode specification.
  static const DirectionalityRightToLeftEmbedding = 16;

  /// Strong bidirectional character type "RLO" in the Unicode specification.
  static const DirectionalityRightToLeftOverride = 17;

  /// Weak bidirectional character type "PDF" in the Unicode specification.
  static const DirectionalityPopDirectionalFormat = 18;

  /// General category "Cn" in the Unicode specification.
  static const Unassigned = 0;

  /// General category "Lu" in the Unicode specification.
  static const UpppercaseLetter = 1;

  /// General category "Ll" in the Unicode specification.
  static const LowercaseLetter = 2;

  /// General category "Lt" in the Unicode specification.
  static const TitlecaseLetter = 3;

  /// General category "Lm" in the Unicode specification.
  static const ModifierLetter = 4;

  /// General category "Lo" in the Unicode specification.
  static const OtherLetter = 5;

  /// General category "Mn" in the Unicode specification.
  static const NonSpacingMark = 6;

  /// General category "Me" in the Unicode specification.
  static const EnclosingMark = 7;

  /// General category "Mc" in the Unicode specification.
  static const CombiningSpacingMark = 8;

  /// General category "Nd" in the Unicode specification.
  static const DecimalDigitNumber = 9;

  /// General category "Nl" in the Unicode specification.
  static const LetterNumber = 10;

  /// General category "No" in the Unicode specification.
  static const OtherNumber = 11;

  /// General category "Ns" in the Unicode specification.
  static const SpaceSeparator = 12;

  /// General category "Zl" in the Unicode specification.
  static const LineSeparator = 13;

  /// General category "Zp" in the Unicode specification.
  static const ParagraphSeparator = 14;

  /// General category "Cc" in the Unicode specification.
  static const Control = 15;

  /// General category "Cf" in the Unicode specification.
  static const Format = 16;

  /// General category "Co" in the Unicode specification.
  static const PrivateUse = 18;

  /// General category "Cs" in the Unicode specification.
  static const Surrogate = 19;

  /// General category "Pd" in the Unicode specification.
  static const DashPunctuation = 20;

  /// General category "Ps" in the Unicode specification.
  static const StartPunctuation = 21;

  /// General category "Pe" in the Unicode specification.
  static const EndPunctutation = 22;

  /// General category "Pc" in the Unicode specification.
  static const ConnectorPunctuation = 23;

  // General category "Po" in the Unicode specification.
  static const OtherPunctuation = 24;

  /// General category "Sm" in the Unicode specification.
  static const MathSymbol = 25;

  /// General category "Sc" in the Unicode specification.
  static const CurrencySymbol = 26;

  /// General category "Sk" in the Unicode specification.
  static const ModifierSymbol = 27;

  /// General category "So" in the Unicode specification.
  static const OtherSymbol = 28;

  /// General category "Pi" in the Unicode specification.
  static const InitialQuotePunctuation = 29;

  /// General category "Pf" in the Unicode specification.
  static const FinalQuotePunctuation = 30;

  /// The minimum value of a Unicode high-surrogate code unit.
  static const MinHighSurrogate = 0xD800;

  /// The maximum value of a Unicode high-surrogate code unit.
  static const MaxHighSurrogate = 0xDBFF;

  /// The minimum value of a Unicode low-surrogate code unit.
  static const MinLowSurrogate = 0xDC00;

  /// The maximum value of a Unicode low-surrogate code unit.
  static const MaxLowSurrogate = 0xDFFF;

  /// The minimum value of a Unicode surrogate code unit.
  static const MinSurrogate = MinHighSurrogate;

  /// The maximum value of a Unicode surrogate code unit.
  static const MaxSurrogate = MaxLowSurrogate;

  /// The minimum value of a Unicode supplementary code point
  static const MinSupplementaryCodePoint = 0x010000;

  /// The minimum value of a Unicode code point
  static const MinCodePoint = 0x000000;

  /// The maximum value of a Unicode code point
  static const MaxCodePoint = 0x10FFFF;

  /// Returns a value indicating a character's general category
  static int getType(int codeUnit) =>
      CharacterData.of(codeUnit).getType(codeUnit);

  /// Returns the unicode directionality property for the given [codeUnit]
  static int getDirectionality(int codeUnit) =>
      CharacterData.of(codeUnit).getDirectionality(codeUnit);

  /// Returns `true` if the given [codeUnit] is defined in Unicode
  static bool isDefined(int codeUnit) =>
      getType(codeUnit) != Character.Unassigned;

  /// Returns `true` if the given [codeUnit] is an ISO Control character
  static bool isISOControl(int codeUnit) {
    // Optimized form of:
    //  (codeUnit >= 0x00 && codePoint <= 0x1F) ||
    //  (codeUnit >= 0x7F && codePoint <= 0x9F)
    return codeUnit <= 0x9F && (codeUnit >= 0x7F || (codeUnit >>> 5) == 0);
  }

  /// Determines if the given [codeUnit] is a Unicode high-surrogate code unit.
  static bool isHighSurrogate(int codeUnit) =>
      codeUnit >= MinHighSurrogate && codeUnit < (MaxHighSurrogate + 1);

  /// Determine if the given [codeUnit] is a Unicode low-surrogate code unit.
  static bool isLowSurrogate(int codeUnit) =>
      codeUnit >= MinLowSurrogate && codeUnit < (MaxLowSurrogate + 1);
}
