typedef OnCall<T, R> = R Function(List<T> arguments);

class VarargsFunction<T, R> {
  VarargsFunction(this._onCall);

  final OnCall<T, R> _onCall;

  @override
  R noSuchMethod(Invocation invocation) {
    if (!invocation.isMethod || invocation.namedArguments.isNotEmpty) {
      super.noSuchMethod(invocation);
    }
    final arguments = invocation.positionalArguments.map<T>((e) => e);
    return _onCall(arguments.toList());
  }
}
