enum ReturnType {
  direct,
  none,
  disk
}
extension ShortString on ReturnType {
  String toShortString() {
    return this.toString().split('.').last;
  }
}