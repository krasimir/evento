class Event {
  String type;
  var data;
  Event({this.type, this.data});
}

class Evento {
  var listeners = {};

  void on(String type, Function listener) {
    if (listeners[type] == null) {
      listeners[type] = [];
    }
    listeners[type].add(listener);
  }

  void off(String type, Function listener) {
    if (listeners[type] == null) {
      return;
    }
    listeners[type] = (listeners[type] as List).where((l) => l != listener);
  }

  void dispatch(String type, data) {
    if (listeners[type] != null) {
      listeners[type].forEach((l) => l(data));
    }
  }
}

Evento E = Evento();
