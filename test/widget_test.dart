import 'package:duocdev/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DuocDev muestra el dashboard inicial', (tester) async {
    await tester.pumpWidget(const DuocDevApp());

    expect(find.text('DuocDev'), findsOneWidget);
    expect(
      find.text('Aprende programación con práctica inteligente'),
      findsOneWidget,
    );
    expect(find.text('Comenzar'), findsOneWidget);
  });
}
