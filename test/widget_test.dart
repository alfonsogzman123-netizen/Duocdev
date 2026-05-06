import 'package:duocdev/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DuocDev muestra el dashboard inicial', (tester) async {
    await tester.pumpWidget(const DuocDevApp());

    expect(find.text('Hola, Estudiante 👋'), findsOneWidget);
    expect(find.text('Continúa tu ruta de programación'), findsOneWidget);
  });
}
