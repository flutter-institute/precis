part of '../character_data.dart';

/// A minimal port of java.lang.CharacterDataPrivateUse
class CharacterDataPrviateUse extends CharacterData {
  CharacterDataPrviateUse._() : super.internal();

  static CharacterDataPrviateUse? _instance;
  factory CharacterDataPrviateUse.instance() {
    _instance ??= CharacterDataPrviateUse._();
    return _instance!;
  }

  @override
  int getProperties(int ch) => 0;

  @override
  int getType(int ch) =>
      (ch & 0xFFFE) == 0xFFFe ? Character.Unassigned : Character.PrivateUse;

  @override
  int getDirectionality(int ch) => (ch & 0xFFFE) == 0xFFFe
      ? Character.DirectionalityUndefined
      : Character.DirectionalityLeftToRight;
}
