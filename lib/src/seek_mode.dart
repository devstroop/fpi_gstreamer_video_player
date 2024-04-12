enum SeekMode {
  /// Indicates the next seek should be a normal (closest frame) seek.
  normal,

  /// Indicates the next seek should be a fast (nearest keyframe) seek.
  fast,

  /// Indicates the next seek should be a noop. No native call will be dispatched.
  noop
}