import 'package:test/test.dart';

import '../lib/evento.dart';

void main() {
  test('subscribing to an event', () {
    int counter = 2;
    E.on('foo', (value) {
      counter += value;
    });
    E.dispatch('foo', 8);
    expect(counter, 10);
  });
  test('unsubscribing to an event', () {
    int counter = 2;
    Function handler = (value) {
      counter += value;
    };
    E.on('foo', handler);
    E.off('foo', handler);
    E.dispatch('foo', 8);
    expect(counter, 2);
  });
}
