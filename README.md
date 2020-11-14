# Evento

A super simple implementation of the pub-sub pattern in the format of a mixin. It allows you to subscribe and dispatch events from everywhere.

## API

For the `StatelessWidget` the `EventoStatelessWidget` mixin only adds the `dispatch` method while for the `StatefulWidget`'s state `Evento` adds `on` and `dispatch`. It doesn't make sense to subscribe for something when you are working on a `StatelessWidget`. That's because it can't be re-rendered based on data. Only on a relation with its parent. Also there is no good mechanism for unsubscribing. Evento does a cleanup itself when the `State` class is disposed.

* `dispatch(String type, [data])` - `type` is the name of the event and `data` is an optional payload.
* `on(String type, Function listener)` - `type` is the name of the event and `listener` is a function that accepts object of type `EEvent`. It has `type` (again a string) and `data` which is the payload (if any) used in `dispatched`.

Additionally the library offers a simple pub-sub implementation as a standalone class. No Flutter involved. Check out the example below.

## Example 

Using with Flutter.

```dart
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
```

Using standalone:

```dart
EventoChannel ch = new EventoChannel();
Function listener = (message) {
  print(message); // "Hello world"
};
Function remove = ch.addListener(listener);
ch.notify("Hello world");

// There are two ways to remove a listener.
// - calling the `removeListener` method of the channel
// - calling the function returned by the `addListener` method of the channel
remove(); // or ch.removeListener(listener)

// Stopping the channel to call listeners and accept new listeners.
ch.close();

// Removing all the added listeners so far.
ch.reset();
```