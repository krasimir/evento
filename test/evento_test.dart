import 'package:test/test.dart';

import '../lib/evento.dart';

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
}
