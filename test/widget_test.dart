
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:jepibookstore/main.dart';
import 'package:jepibookstore/providers/cart_provider.dart';
import 'package:jepibookstore/providers/theme_provider.dart';

void main() {
  testWidgets('NusaBookstore berhasil ditampilkan', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => CartProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => ThemeProvider(),
          ),
        ],
        child: const NusaBookstoreApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('NusaBookstore'), findsOneWidget);
    expect(find.text('Temukan Buku Favoritmu'), findsOneWidget);
    expect(find.text('Koleksi Buku'), findsOneWidget);
    expect(find.text('Atomic Habits'), findsOneWidget);
  });
}
