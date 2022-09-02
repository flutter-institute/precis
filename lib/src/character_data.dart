// ignore_for_file: constant_identifier_names

import 'package:precis/src/character.dart';

part 'character_data/character_data_00.dart';
part 'character_data/character_data_0e.dart';
part 'character_data/character_data_01.dart';
part 'character_data/character_data_02.dart';
part 'character_data/character_data_latin1.dart';
part 'character_data/character_data_private_use.dart';
part 'character_data/character_data_undefined.dart';

/// A minimal port of java.lang.CharacterData
abstract class CharacterData {
  CharacterData.internal();

  int getProperties(int ch);
  int getType(int ch);
  int getDirectionality(int ch);

  factory CharacterData.of(int codeUnit) {
    if (codeUnit >>> 8 == 0) {
      // latin 1 internal
      return CharacterDataLatin1.instance();
    } else {
      switch (codeUnit >>> 16) {
        // plane 00-16
        case 0:
          return CharacterData00.instance();
        case 1:
          return CharacterData01.instance();
        case 2:
          return CharacterData02.instance();
        case 14:
          return CharacterData0E.instance();
        case 15: // private use
        case 16: // private use
          return CharacterDataPrviateUse.instance();
        default:
          return CharacterDataUndefined.instance();
      }
    }
  }
}
