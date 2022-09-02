library precis;

export 'src/exceptions.dart';
import 'src/profile.dart';

/// The UsernameCaseMapped profile specified in RFC 8265
final usernameCaseMapped = UsernameProfile(true);

/// The UsernameCasePreserved profile specified in RFC 8265
final usernameCasePreserved = UsernameProfile(false);

/// The OpqueString profile specified in RFC 8265
final opaqueString = OpaqueStringProfile();

/// The Nickname profile specified in RFC 8266
final nickname = NicknameProfile();
