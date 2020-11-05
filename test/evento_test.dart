import 'package:evento/mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/evento.dart';

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
    on('foo', (data) {
      setState(() {
        value = 'Hello ${data}';
      });
    });
  }

  Widget build(context) {
    return Text(value);
  }
}

void main() {
  setUp(() {
    E.reset();
  });
  // test('subscribing to an event', () {
  //   int counter = 2;
  //   E.on('foo', (event) {
  //     counter += event.data;
  //   });
  //   E.dispatch('foo', 8);
  //   expect(counter, 10);
  // });
  // test('unsubscribing to an event', () {
  //   int counter = 2;
  //   Function handler = (event) {
  //     counter += event.data;
  //   };
  //   E.on('foo', handler);
  //   E.off('foo', handler);
  //   E.dispatch('foo', 8);
  //   expect(counter, 2);
  // });
  // test('support of multiple event types', () {
  //   List<String> values = [];
  //   Function handlerA = (event) {
  //     values.add('a');
  //   };
  //   Function handlerB = (event) {
  //     values.add('b');
  //   };
  //   E.on('foo', handlerA);
  //   E.on('bar', handlerA);
  //   E.on('zar', handlerB);
  //   E.dispatch('foo');
  //   E.dispatch('bar');
  //   E.dispatch('zar');
  //   E.dispatch('zar');
  //   expect(values, ['a', 'a', 'b', 'b']);
  // });
  testWidgets('communication between two widgets', (WidgetTester tester) async {
    await tester.pumpWidget(Material(
        child: Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: [A(), B()],
      ),
    )));
    await tester.pumpWidget(Material(
        child: Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: [Text('nope')],
      ),
    )));
  });
}
