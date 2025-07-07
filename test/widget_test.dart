// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:my_waifu_app/main.dart';
import 'package:my_waifu_app/services/user_preferences.dart';

void main() {
  setUpAll(() async {
    // Mock SharedPreferences for testing
    SharedPreferences.setMockInitialValues({});
    await UserPreferences.init();
  });

  testWidgets('App loads with bottom navigation', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyWaifuApp());
    await tester.pumpAndSettle();

    // Verify that the app loads with the correct title.
    expect(find.text('My Waifu App'), findsOneWidget);

    // Verify that bottom navigation is present.
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Messages'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('Home screen displays character information', (WidgetTester tester) async {
    await tester.pumpWidget(const MyWaifuApp());
    await tester.pumpAndSettle();

    // Verify that Rem\'s information is displayed.
    expect(find.text('Rem'), findsOneWidget);
    expect(find.text('From Re:Zero - Starting Life in Another World'), findsOneWidget);
    
    // Verify that action buttons are present.
    expect(find.text('Show Love'), findsOneWidget);
    expect(find.text('Talk'), findsOneWidget);
    
    // Verify relationship status card is present.
    expect(find.text('Relationship Status'), findsOneWidget);
    expect(find.text('Affection Level'), findsOneWidget);
  });

  testWidgets('Navigation between screens works', (WidgetTester tester) async {
    await tester.pumpWidget(const MyWaifuApp());
    await tester.pumpAndSettle();

    // Navigate to Messages screen
    await tester.tap(find.byIcon(Icons.chat));
    await tester.pumpAndSettle();
    expect(find.text('Daily Messages'), findsOneWidget);

    // Navigate to Profile screen
    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();
    expect(find.text('Rem's Profile'), findsOneWidget);

    // Navigate to Settings screen
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    expect(find.text('User Settings'), findsOneWidget);

    // Navigate back to Home
    await tester.tap(find.byIcon(Icons.home));
    await tester.pumpAndSettle();
    expect(find.text('My Waifu App'), findsOneWidget);
  });

  testWidgets('Show Love button increases affection', (WidgetTester tester) async {
    await tester.pumpWidget(const MyWaifuApp());
    await tester.pumpAndSettle();

    // Find and tap the Show Love button
    await tester.tap(find.text('Show Love'));
    await tester.pumpAndSettle();

    // Verify that a snackbar appears
    expect(find.textContaining('Rem loves your attention'), findsOneWidget);
  });

  testWidgets('Talk button shows message', (WidgetTester tester) async {
    await tester.pumpWidget(const MyWaifuApp());
    await tester.pumpAndSettle();

    // Find and tap the Talk button
    await tester.tap(find.text('Talk'));
    await tester.pumpAndSettle();

    // Verify that a quote appears in the quote card
    expect(find.textContaining('Rem says:'), findsOneWidget);
  });

  testWidgets('Daily Messages screen functionality', (WidgetTester tester) async {
    await tester.pumpWidget(const MyWaifuApp());
    await tester.pumpAndSettle();

    // Navigate to Messages screen
    await tester.tap(find.text('Messages'));
    await tester.pumpAndSettle();

    // Verify messages screen elements
    expect(find.text('Daily Messages'), findsOneWidget);
    expect(find.text('New Quote'), findsOneWidget);
    expect(find.textContaining('Love'), findsOneWidget);
    
    // Test getting a new quote
    await tester.tap(find.text('New Quote'));
    await tester.pumpAndSettle();
  });

  testWidgets('Settings screen displays user stats', (WidgetTester tester) async {
    await tester.pumpWidget(const MyWaifuApp());
    await tester.pumpAndSettle();

    // Navigate to Settings screen
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    // Verify settings screen elements
    expect(find.text('Your Stats'), findsOneWidget);
    expect(find.text('User Settings'), findsOneWidget);
    expect(find.text('App Settings'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
  });
}

