part of '../profile.dart';

Iterable<String> runeString(String s) =>
    s.runes.map((e) => e.toRadixString(16));

Iterable<String> codeUnitString(String s) =>
    s.codeUnits.map((e) => e.toRadixString(16));

/// The implementation of the PRECIS: Nickname Profile, RFC 8266
class NicknameProfile extends PrecisProfile {
  NicknameProfile() : super._(false);

  @override
  String enforce(String input) {
    // An entity that performs enforcement according to this profile MUST prepare
    // an input string as described in Section 2.2 and MUST also apply the
    // following rules specified in Section 1.1 in the following order:

    // 1. Additional Mapping Rule
    // 2. Normalization Rule
    String rules(String str) =>
        prepare(_applyNormalizationRule(_applyAdditionalMappingRule(str)));
    final enforced = _stabilize(input, rules);

    // The resulting nickname must be non empty
    if (enforced.isEmpty) {
      throw EnforcementException(
          'Nickname must not be empty after applying the rules.');
    }

    return enforced;
  }

  @override
  String toComparableString(String input) {
    // Comparison uses different rules. The comparable string must be
    // prepared as specified in Section 2.2 and apply the following
    // rules in the order specified in Section 2.1
    // 1. Additional Mapping Rules
    // 2. Case Mapping Rule
    // 3. Normalization Rule

    return _stabilize(input, super.enforce);
  }

  @override
  // 1. Width Mapping Rule: None
  String _applyWidthMappingRule(String input) => input;

  @override
  String _applyAdditionalMappingRule(String input) {
    // 2. Additional Mapping Rule: The additional mapping rule consists of the following:

    // A. Map any instances of non-ASCII space to SPACE (U+0020)
    // B. Remove any instances of ASCII space character from the ends
    // C. Map interior sequences of more than one ASCII space to a single space
    return input
        .replaceAll(PrecisProfile.WHITESPACE, ' ')
        .trim()
        .replaceAll(RegExp('[ ]+'), ' ');
  }

  @override
  // 3. Case Mapping Rule: standard case mapping (toLowerCase)
  String _applyCaseMappingRule(String input) => PrecisProfile._caseMap(input);

  @override
  // 4. Normalization Rule: Apply Normalization Form KC
  String _applyNormalizationRule(String input) => unorm.nfkc(input);

  @override
  // 5. Directionality Rule: None
  String _applyDirectionalityRule(String input) => input;
}
