export './mixin.dart';

class EEvent {
  String type;
  var data;
  EEvent({this.type, this.data});
}

class Bus {
  var listeners = {};

  Function on(String type, Function listener) {
    if (listeners[type] == null) {
      listeners[type] = [];
    }
    listeners[type].add(listener);
    return () => off(type, listener);
  }

  void off(String type, Function listener) {
    if (listeners[type] == null) {
      return;
    }
    listeners[type] =
        (listeners[type] as List).where((l) => l != listener).toList();
  }

  void dispatch(String type, [data]) {
    if (listeners[type] != null) {
      listeners[type].forEach((l) => l(EEvent(type: type, data: data)));
    }
  }

  void reset() {
    listeners = {};
  }
}

Bus E = Bus();
