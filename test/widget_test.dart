import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rick_and_morty_app/main.dart';

void main() {
  testWidgets('Rick and Morty app launches correctly', (WidgetTester tester) async {
    // Запускаем приложение
    await tester.pumpWidget(const MyApp());

    // Проверяем что заголовок приложения отображается
    expect(find.text('Rick and Morty Characters'), findsOneWidget);
    
    // Проверяем что BottomNavigationBar отображается
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    
    // Проверяем что есть две вкладки
    expect(find.text('Персонажи'), findsOneWidget);
    expect(find.text('Избранное'), findsOneWidget);
  });

  testWidgets('Character list loads and displays characters', (WidgetTester tester) async {
    // Запускаем приложение
    await tester.pumpWidget(const MyApp());

    // Ждем загрузки данных (можно увеличить время если нужно)
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Проверяем что загрузились персонажи (должны быть карточки)
    expect(find.byType(Card), findsWidgets);
    
    // Проверяем что есть кнопки избранного
    expect(find.byIcon(Icons.star_border), findsWidgets);
  });

  testWidgets('Navigation between tabs works', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Находим и нажимаем на вкладку "Избранное"
    await tester.tap(find.text('Избранное'));
    await tester.pumpAndSettle();

    // Проверяем что перешли на экран избранного
    expect(find.text('Избранные персонажи'), findsOneWidget);

    // Возвращаемся на вкладку "Персонажи"
    await tester.tap(find.text('Персонажи'));
    await tester.pumpAndSettle();

    // Проверяем что вернулись на главный экран
    expect(find.text('Rick and Morty Characters'), findsOneWidget);
  });
}