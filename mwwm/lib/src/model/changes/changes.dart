/// An abstract change of model
/// R - type of expected result
abstract class Change<R> {
  @override
  String toString() {
    return '${runtimeType}';
  }
}
