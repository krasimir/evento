# Evento

A super simple implementation of the pub-sub pattern in the format of a mixin.

## API

For the `StatelessWidget` the `EventoStatelessWidget` mixin only adds the `dispatch` method while for the `StatefulWidget`'s state `Evento` adds `on` and `dispatch.

* `dispatch(String type, [data])` - `type` is the name of the event and `data` is an optional payload.
* `on(String type, Function listener)` - `type` is the name of the event and `listener` is a function that accepts object of type `EEvent`. It has `type` (again a string) and `data` which is the payload (if any) used in `dispatched`.

## Example 

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