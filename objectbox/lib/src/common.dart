import 'dart:ffi';

import 'package:ffi/ffi.dart' show allocate, free;

import 'bindings/bindings.dart';

// TODO use pub_semver?
/// Wrapper for a semantic version information.
class Version {
  /// Major version number.
  final int major;

  /// Minor version number.
  final int minor;

  /// Patch version number.
  final int patch;

  /// Create a version identifier.
  const Version(this.major, this.minor, this.patch);

  @override
  String toString() => '$major.$minor.$patch';
}

/// Returns the underlying ObjectBox-C library version.
Version nativeLibraryVersion() {
  var majorPtr = allocate<Int32>(),
      minorPtr = allocate<Int32>(),
      patchPtr = allocate<Int32>();

  try {
    C.version(majorPtr, minorPtr, patchPtr);
    return Version(majorPtr.value, minorPtr.value, patchPtr.value);
  } finally {
    free(majorPtr);
    free(minorPtr);
    free(patchPtr);
  }
}

/// ObjectBox native exception wrapper.
class ObjectBoxException implements Exception {
  /// Dart message related to this native error.
  final String /*?*/ dartMsg;

  /// Native error code.
  final int nativeCode;

  /// Native error message.
  final String /*?*/ nativeMsg;

  /// Create a native exception.
  ObjectBoxException({this.dartMsg, this.nativeCode = 0, this.nativeMsg});

  @override
  String toString() {
    var result = 'ObjectBoxException: ';
    if (dartMsg != null) {
      result += dartMsg /*!*/;
      if (nativeCode != 0 || nativeMsg != null) result += ': ';
    }
    if (nativeCode != 0) result += '$nativeCode ';
    if (nativeMsg != null) result += nativeMsg;
    return result.trimRight();
  }
}
