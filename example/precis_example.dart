// Copyright (c) 2022, Brian Armstrong. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:precis/precis.dart' as precis;

/// Validates that [username] does not contain invalid characters.
/// Returns a String with some of the basic rules applied
/// Throws [InvalidCodePointException] on failure
String validateUsername(String username) {
  return precis.usernameCaseMapped.prepare(username);
}

/// Format username for comparison and alidate that [username] does not contain invalid characters
/// Returns the formatted string will all rules applied
/// Throws [InvalidCodePointeException] if there are invalid characters
/// Throws [InvalidDirectionalityException] if there are invalid LTR and RTL character mixes
/// Throws [EnforcementException] for other errors (like empty strings)
String formatUsernameForDuplicateCheck(String username) {
  return precis.usernameCaseMapped.prepare(username);
}

/// Verify that the given passwords are the same. This is useful when changing the password.
/// This method enforces all rules on both strings, so it can possibly throw the three
/// exceptions mentioned above.
bool passwordsMatch(String password1, String password2) {
  return precis.opaqueString.compare(password1, password2) == 0;
}
