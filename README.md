[![Codemagic build status](https://api.codemagic.io/apps/63332eac6e6d533914b542d6/63332eac6e6d533914b542d5/status_badge.svg)](https://codemagic.io/apps/63332eac6e6d533914b542d6/63332eac6e6d533914b542d5/latest_build)
[![Pub Version](https://img.shields.io/pub/v/precis)](https://pub.dev/packages/precis)

A dart implementation of the *"PRECIS Framework: Preparation, Enforcement, and Comparison of Internationalized Strings in Application Protocols"* and profiles thereof.

This is a ported implementation based on the [rocks.xmpp.precis Project by Christian Schudt](https://bitbucket.org/sco0ter/precis/src/master/). Large portions of the character handling were ported from the Java SDK, since the functionality (while supported in the compiler/core) is not exposed to the dart language.

## About

*PRECIS* validates and prepares Unicode strings so that they can safely be used in application protocols.

For example, when dealing with usernames and passwords. If strings are used for these authentication and authorization decisions the security of an application can be compromised if an entity providing a given string is connected to the wrong account or online resource based on different interpretations of that string. A classic example is when people include zero-width unicode spaces in a username, which makes it easily confusable with the username with no spacing in it.

*PRECIS* takes care of such issues.

This library supports the following specifications:
- [RFC 8264](https://www.rfc-editor.org/rfc/rfc8264): PRECIS Framework: Preparation, Enforcement, and Comparison of Internationalized Strings in Application Protocols
- [RFC 8265](https://www.rfc-editor.org/rfc/rfc8265): Preparation, Enforcement, and Comparison of Internationalized Strings Representing Usernames and Passwords
- [RFC 8266](https://www.rfc-editor.org/rfc/rfc8266): Preparation, Enforcement, and Comparison of Internationalized Strings Representing Nicknames

*PRECIS* obsoletes Stringprep ([RFC 3454](https://tools.ietf.org/html/rfc3454)).

## Usage

For most use cases, all you need to do is choose an existing profile from the Package then prepare or enforce a string.

```dart
import 'package:precis/precis.dart' as precis;

final profile1 = precis.usernameCaseMapped;
final profile2 = precis.usernameCasePreserved;
final profile3 = precis.opaqueString;
final profile4 = precis.nickname;
```

If you are feeling adventurous, you can extend the abstract `PrecisProfile` and define your own custom profile. However, this is [discouraged](https://www.rfc-editor.org/rfc/rfc8264#section-5.1) by RFC 8264.

### Preparation

Preparation ensures that characters are allowed, but (usually) does not apply any mapping rules. The following throws an exception because the string contains a character from Unicode category Lt which is disallowed.
```dart
precis.usernameCaseMapped.prepare('\u01C5'); // Capital Letter D with Small Letter Z with Caron
```

The exception thrown will usually be an `InvalidCodePointException` that will give the developer information about which character in the string was invalid. Any other exceptions thrown (as well as this one) with extend `PrecisException` for ease of handling.

### Enforcement

Enforcement applies a set of rules to a string in order to transform it to a canonical form so it can be used in string comparisons.
```dart
final enforced = precis.usernameCaseMapped.enforce("UpperCaseUsernmae"); // => uppercaseusername
```

Enforcement does much more than the above lower case mapping, though. It will also map ambiguous characters to their unambiguous forms. The following example maps all of the characters to `Latin Small Letter A with Ring Above` (U+00E5).
```dart
final ang = precis.usernameCaseMapped.enfoce('\u212B'); // Angstrom Sign
final a = precis.usernameCaseMapped.enfoce('\u0041\u030A'); // Latin Capital A + Combining Ring Above
final aRing = precis.usernameCaseMapped.enfoce('\u00C5'); // Latin Capital A with Ring Above
// ang == a => true
// a == aRing => true
```

The following example throws an `InvalidDirectionalityException` because it violates the Bidi Rule (RFC 5893). This exception extends `PrecisException`.
```dart
precis.usernameCaseMapped.enforce('\u0786test');
```

If a string contains prohibited code points an `InvalidCodePointException` is thrown, just like during preparation.

### Comparison

You can use `PrecisProfile.toComparableString(String)` to check if two strings compare to each other:
```dart
final profile = precis.usernameCaseMapped;
if (profile.toComparableString('foobar') == profile.toComparableString('FooBar')) {
    // Username already exists
}
```
Or you can use `PrecisProfile.compare` as a [Comparator](https://api.dart.dev/stable/2.18.0/dart-core/Comparator.html):
```dart
if (profile.compare("foobar", "FooBar") == 0) {
    // Username already exists
}
```

NOTE: A profile may use different rules during comparison than during enforcement (such as the Nickname profile, RFC 8266).
