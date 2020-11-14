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

void main() {
  setUp(() {
    E.reset();
  });
  test('subscribing to an event', () {
    int counter = 2;
    E.on('foo', (event) {
      counter += event.data;
    });
    E.dispatch('foo', 8);
    expect(counter, 10);
  });
  test('unsubscribing to an event', () {
    int counter = 2;
    Function handler = (event) {
      counter += event.data;
    };
    E.on('foo', handler);
    E.off('foo', handler);
    E.dispatch('foo', 8);
    expect(counter, 2);
  });
  test('support of multiple event types', () {
    List<String> values = [];
    Function handlerA = (event) {
      values.add('a');
    };
    Function handlerB = (event) {
      values.add('b');
    };
    E.on('foo', handlerA);
    E.on('bar', handlerA);
    E.on('zar', handlerB);
    E.dispatch('foo');
    E.dispatch('bar');
    E.dispatch('zar');
    E.dispatch('zar');
    expect(values, ['a', 'a', 'b', 'b']);
  });
  testWidgets('communication between two widgets', (WidgetTester tester) async {
    await tester.pumpWidget(Material(
        child: Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: [A(), B()],
      ),
    )));
    await tester.tap(find.byType(MaterialButton));
    await tester.pump(); // rebuild the widgets
    await tester.pump(); // rebuild the widgets

    expect(find.text('Hello world'), findsOneWidget);
  });
  testWidgets('clean up', (WidgetTester tester) async {
    await tester.pumpWidget(Material(
        child: Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: [A(), B()],
      ),
    )));
    expect(E.listeners['foo'].length, 1);
    await tester.pumpWidget(Material(
        child: Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: [Text('foo')],
      ),
    )));
    expect(E.listeners['foo'].length, 0);
  });
  test('Creating channel, add listener and notify', () {
    int value = 0;
    EventoChannel c = new EventoChannel();
    c.addListener((n) {
      value += n;
    });
    c.notify(4);
    c.notify(6);
    expect(value, 10);
  });
  test('Removing a listener', () {
    int value = 0;
    EventoChannel c = new EventoChannel();
    Function l1 = () {
      value += 10;
    };
    Function l2 = () {
      value += 12;
    };
    c.addListener(l1);
    Function remove = c.addListener(l2);
    c.notify();
    c.removeListener(l1);
    remove();
    c.notify();
    expect(value, 22);
  });
  test('Reset a channel', () {
    int value = 0;
    EventoChannel c = new EventoChannel();
    Function listener = () {
      value += 10;
    };
    c.addListener(listener);
    c.notify();
    c.notify();
    c.reset();
    c.notify();
    expect(value, 20);
  });
  test('Close a channel', () {
    int value = 0;
    EventoChannel c = new EventoChannel();
    Function listener = () {
      value += 10;
    };
    c.addListener(listener);
    c.notify();
    c.close();
    c.notify();
    c.notify();
    expect(value, 10);
  });
}
