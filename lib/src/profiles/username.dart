part of '../profile.dart';

/// Implement the UsernameCasePreserved profile
///
/// See: https://www.rfc-editor.org/rfc/rfc8265#section-3.4
class UsernameProfile extends PrecisProfile {
  final bool _caseMapped;

  UsernameProfile(this._caseMapped) : super._(true);

  @override
  String enforce(String input) {
    // 1. Case Mapping Rule
    // 2. Normalization Rule
    // 3. Directionality Rule
    final enforced = super.enforce(input);

    // A username MUST NOT be zero bytes in length. This rule is to be enforced
    // after any normalization and mapping of code points
    if (enforced.isEmpty) {
      throw EnforcementException('A username must not be empty');
    }

    return enforced;
  }

  @override
  String prepare(String input) {
    // 1. Apply the width mapping rule in Section 3.4.1. It is necessary
    // to apply the rule at this point because otherwise the PRECIS "HasCompat"
    // category specified in Section 9.17 of RFC 8264 would forbid fullwidth
    // and halfwidth code points.
    final mapped = _applyWidthMappingRule(input);

    // 2. Ensure that the string consists only of Unicode code points that conform
    // to the PRECIS IdentificerClass
    return super.prepare(mapped);
  }

  @override
  // 1. Width Mapping Rule: Map fullwidth and halfwidth code points to their decomposition mappings
  String _applyWidthMappingRule(String input) => PrecisProfile._widthMap(input);

  @override
  // 2. Additional Mapping Rule: None
  String _applyAdditionalMappingRule(String input) => input;

  @override
  // 3. Optional Case Mapping Rule: Map uppercase and titlecase code points to their lowercase equivalents
  String _applyCaseMappingRule(String input) =>
      _caseMapped ? PrecisProfile._caseMap(input) : input;

  @override
  // 4. Normalization Rule: Apply Normalization From C (NFC) to all strings
  String _applyNormalizationRule(String input) => unorm.nfc(input);

  @override
  String _applyDirectionalityRule(String input) {
    // 5. Directionality Rule: Apply the "Bidi Rule" defined in RFC 5893 to strings
    // that contain RTL code points. For all other strings, there is no special
    // processing for directionality

    if (PrecisProfile._requiresBidi(input)) {
      PrecisProfile.checkBidiRule(input);
    }
    return input;
  }
}
