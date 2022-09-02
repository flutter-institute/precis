part of '../profile.dart';

class OpaqueStringProfile extends PrecisProfile {
  OpaqueStringProfile() : super._(false);

  @override
  String enforce(String input) {
    final enforced = super.enforce(input);
    // A password must not be empty
    if (enforced.isEmpty) {
      throw EnforcementException(
          'String must not be empty after applying the rules.');
    }
    return enforced;
  }

  @override
  // 1. Width Mapping Rule: None (do not map anything)
  String _applyWidthMappingRule(String input) => input;

  @override
  // 2. Additional Mapping Rule: non-ASCII spaces MUST be mapped to ASCII spaces
  String _applyAdditionalMappingRule(String input) =>
      input.replaceAll(PrecisProfile.WHITESPACE, ' ');

  @override
  // 3. Case Mapping Rule: None (would reduce security)
  String _applyCaseMappingRule(String input) => input;

  @override
  // 4. Normalization Rule: Unicode Normalization Form C (NFC)
  String _applyNormalizationRule(String input) => unorm.nfc(input);

  @override
  // 5. Directionality Rule: None
  String _applyDirectionalityRule(String input) => input;
}
