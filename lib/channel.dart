class EventoChannel {
  List<Function> _listeners = [];
  bool _closed = false;

  Function addListener(Function callback) {
    _listeners.add(callback);
    return () {
      _listeners = _listeners.where((c) => c != callback).toList();
    };
  }

  void removeListener(Function callback) {
    _listeners = _listeners.where((c) => c != callback).toList();
  }

  void notify([something]) {
    if (_closed) return;
    _listeners.forEach((c) {
      if (something != null) {
        c(something);
      } else {
        c();
      }
    });
  }

  void reset() {
    _listeners = [];
  }

  void close() {
    _closed = true;
  }
}
