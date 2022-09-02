part of '../character_data.dart';

/// A minimal port of java.lang.CharacterDataUndefined
class CharacterDataUndefined extends CharacterData {
  CharacterDataUndefined._() : super.internal();

  static CharacterDataUndefined? _instance;
  factory CharacterDataUndefined.instance() {
    _instance ??= CharacterDataUndefined._();
    return _instance!;
  }

  @override
  int getProperties(int ch) => 0;

  @override
  int getType(int ch) => Character.Unassigned;

  @override
  int getDirectionality(int ch) => Character.DirectionalityUndefined;
}
