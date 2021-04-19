enum Persistence {
  connection,
  reboot,
  forever
}
extension PersistenceShortString on Persistence {
  String toShortString() {
    return this.toString().split('.').last;
  }
}