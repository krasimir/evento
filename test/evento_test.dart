import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class TestWidget extends StatelessWidget {
  Widget build(context) {
    return Text('hello');
  }
}

void main() {
  testWidgets('Should run the animation', (WidgetTester tester) async {
    await tester.pumpWidget(Material(
        child: Directionality(
            textDirection: TextDirection.ltr, child: TestWidget())));
    await tester.pump();

    final text = find.text('value: 120.0');

    expect(text, findsOneWidget);
  });
}
