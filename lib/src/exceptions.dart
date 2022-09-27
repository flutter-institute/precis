/// An exception that was thrown during a Precis operation
abstract class PrecisException implements Exception {
  PrecisException(this.message);

  final String message;

  String _getName();

  @override
  String toString() {
    return '${_getName()}: $message';
  }
}

/// Thrown to indicate that the directionality rules have been violated
class InvalidDirectionalityException extends PrecisException {
  InvalidDirectionalityException(super.message);

  @override
  String _getName() => 'InvalidDirectionalityException';
}

/// Thrown to indicate that a string contains invalid code points after applying preparation or enforcemnet of PRECIS framework.
class InvalidCodePointException extends PrecisException {
  InvalidCodePointException(super.message);

  @override
  String _getName() => 'InvalidCodePointException';
}

/// Thrown to indicate that a string had errors while enforcing its conditions
class EnforcementException extends PrecisException {
  EnforcementException(super.message);

  @override
  String _getName() => 'EnforcementException';
}
