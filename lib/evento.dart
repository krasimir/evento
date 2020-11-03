class Event {
  String type;
  var data;
  Event({this.type, this.data});
}

class Evento {
  var listeners = {};
  void on(String type, Function listener) {
    if (!listeners[type]) {
      listeners[type] = [];
    }
    listeners[type].add(listener);
  }

  void off(String type, Function listener) {
    if (!listeners[type]) {
      return;
    }
    listeners[type] = (listeners[type] as List).where((l) => l != listener);
  }
}
