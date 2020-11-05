import 'package:flutter/material.dart';
import './evento.dart';

mixin Evento<T extends StatefulWidget> on State<T> {
  var cleanups = [];
  @override
  dispose() {
    print('dispose in mixin (EventoState)');
    super.dispose();
  }

  on(String type, Function listener) {
    cleanups.add(E.on(type, listener));
  }

  dispatch(String type, [data]) {
    E.dispatch(type, data);
  }
}

mixin EventoStatelessWidget<T extends StatelessWidget> on StatelessWidget {
  dispatch(String type, [data]) {
    E.dispatch(type, data);
  }
}