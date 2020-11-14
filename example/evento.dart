import 'package:flutter/material.dart';
import 'package:evento/evento.dart';

class A extends StatelessWidget with EventoStatelessWidget {
  Widget build(context) {
    return MaterialButton(onPressed: () {
      dispatch('foo', 'world');
    });
  }
}

class B extends StatefulWidget {
  State createState() => _B();
}

class _B extends State<B> with Evento {
  String value = 'Hey';
  void initState() {
    on('foo', (EEvent event) {
      setState(() {
        value = 'Hello ${event.data}';
      });
    });
  }

  Widget build(context) {
    return Text(value);
  }
}

EventoChannel chan = new EventoChannel();
Function listener = (message) {
  print(message); // "Hello world"
};
Function remove = chan.addListener(listener);
chan.notify("Hello world");

// There are two ways to remove a listener.
// - calling the `removeListener` method of the channel
// - calling the function returned by the `addListener` method of the channel
remove(); // or ch.removeListener(listener)

// Stopping the channel to call listeners and accept new listeners.
chan.close();

// Removing all the added listeners so far.
chan.reset();
