//import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:src/main.dart' as app;

void main() {

  group('end-to-end test', () {

    testWidgets('Prueba añadir moneda', (WidgetTester tester) async {

      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final Finder buttonAdd = find.byIcon(Icons.add);
      final Finder buttonEUR = find.text("EUR");
      final Finder buttonUSD = find.text("USD");
      final Finder buttonJPY = find.text("JPY");
      final Finder VentanaSC = find.text('Select currency');

      expect(buttonAdd, findsOneWidget);
      expect(buttonEUR, findsOneWidget);
      expect(buttonUSD, findsOneWidget);
      expect(buttonJPY, findsNothing);


      await tester.tap(buttonAdd);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(VentanaSC, findsOneWidget);

      await tester.tap(buttonJPY);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(buttonAdd, findsOneWidget);
      expect(buttonEUR, findsOneWidget);
      expect(buttonUSD, findsOneWidget);
      expect(buttonJPY, findsOneWidget);
    });

    testWidgets('Prueba añadir valores no validos', (WidgetTester tester) async {

      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final Finder currencyInput = find.byType(TextField);

      expect(currencyInput, findsOneWidget);
      expect(find.text(''), findsOneWidget);


      await tester.enterText(currencyInput, '123');
      expect(find.text('123'), findsOneWidget);

      await tester.enterText(currencyInput, '123abc123');
      expect(find.text('123'), findsOneWidget);

      await tester.enterText(currencyInput, '123---123');
      expect(find.text('123'), findsOneWidget);

      await tester.enterText(currencyInput, '123.01');
      expect(find.text('123.01'), findsOneWidget);

      await tester.enterText(currencyInput, '123.0123');
      expect(find.text('123.01'), findsOneWidget);

      await tester.enterText(currencyInput, '-123');
      expect(find.text(''), findsOneWidget);
    });

    testWidgets('Prueba conversion funciona correctamente ', (WidgetTester tester) async {

      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final Finder currencyInput = find.byType(TextField);
      final Finder buttonAdd = find.byIcon(Icons.add);
      final Finder buttonCached = find.byIcon(Icons.cached);
      final Finder buttonEUR = find.text("EUR");
      final Finder buttonUSD = find.text("USD");
      final Finder buttonJPY = find.text("JPY");
      final Finder VentanaSC = find.text('Select currency');

      expect(buttonAdd, findsOneWidget);
      expect(buttonEUR, findsOneWidget);
      expect(buttonUSD, findsOneWidget);
      expect(buttonJPY, findsNothing);
      expect(currencyInput, findsOneWidget);
      expect(find.text(''), findsOneWidget);

      await tester.tap(buttonAdd);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(VentanaSC, findsOneWidget);

      await tester.tap(buttonJPY);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(buttonAdd, findsOneWidget);
      expect(buttonEUR, findsOneWidget);
      expect(buttonUSD, findsOneWidget);
      expect(buttonJPY, findsOneWidget);
      expect(currencyInput, findsOneWidget);
      expect(find.text(''), findsOneWidget);


      await tester.enterText(currencyInput, '123');
      await tester.pumpAndSettle(const Duration(seconds: 10));
      await tester.tap(buttonCached);
      await tester.pumpAndSettle(const Duration(seconds: 10));

      expect(find.text('123'), findsOneWidget);
      expect(find.text('130.12'), findsOneWidget);
      expect(find.text('19506.69'), findsOneWidget);
      expect(find.text('1'), findsNothing);
      expect(find.text('2'), findsNothing);
      expect(find.text('3'), findsNothing);
    });

    testWidgets('Prueba borrar moneda', (WidgetTester tester) async {

      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final Finder buttonAdd = find.byIcon(Icons.add);
      final Finder buttonEUR = find.text("EUR");
      final Finder buttonUSD = find.text("USD");
      final Finder buttonJPY = find.text("JPY");
      final Finder VentanaSC = find.text('Select currency');
      final Finder papelera = find.byIcon(Icons.delete);

      expect(buttonAdd, findsOneWidget);
      expect(buttonEUR, findsOneWidget);
      expect(buttonUSD, findsOneWidget);
      expect(buttonJPY, findsNothing);


      await tester.tap(buttonAdd);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(VentanaSC, findsOneWidget);

      await tester.tap(buttonJPY);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(buttonAdd, findsOneWidget);
      expect(buttonEUR, findsOneWidget);
      expect(buttonUSD, findsOneWidget);
      expect(buttonJPY, findsOneWidget);

      await tester.tap(papelera.at(1));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(buttonAdd, findsOneWidget);
      expect(buttonEUR, findsOneWidget);
      expect(buttonUSD, findsOneWidget);
      expect(buttonJPY, findsNothing);


      await tester.tap(buttonAdd);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.tap(buttonJPY);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.tap(papelera.at(0));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(buttonAdd, findsOneWidget);
      expect(buttonEUR, findsOneWidget);
      expect(buttonJPY, findsOneWidget);
      expect(buttonUSD, findsNothing);
    });

    testWidgets('Prueba añadir misma moneda', (WidgetTester tester) async {

      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final Finder buttonAdd = find.byIcon(Icons.add);
      final Finder buttonEUR = find.text("EUR");
      final Finder buttonUSD = find.text("USD");
      final Finder buttonJPY = find.text("JPY");

      await tester.tap(buttonAdd);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.tap(buttonJPY);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.tap(buttonAdd);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.tap(buttonJPY);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(buttonAdd, findsOneWidget);
      expect(buttonEUR, findsOneWidget);
      expect(buttonUSD, findsOneWidget);
      expect(buttonJPY, findsNWidgets(1));
    });
  });
}