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

  setUp(() {
    // Set a larger test size for all tests to accommodate the UI
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('App loads with bottom navigation', (WidgetTester tester) async {
    // Set a larger test size to accommodate the UI
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    
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
    
    // Reset the test size
    addTearDown(tester.view.reset);
  });

  testWidgets('Home screen displays character information', (WidgetTester tester) async {
    // Set a larger test size to accommodate the UI
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    
    await tester.pumpWidget(const MyWaifuApp());
    await tester.pumpAndSettle();

    // Verify that Rem's information is displayed.
    expect(find.text('Rem'), findsOneWidget);
    expect(find.text('From Re:Zero - Starting Life in Another World'), findsOneWidget);
    
    // Verify that action buttons are present.
    expect(find.text('Show Love'), findsOneWidget);
    expect(find.text('Talk'), findsOneWidget);
    
    // Verify relationship status card is present.
    expect(find.text('Relationship Status'), findsOneWidget);
    expect(find.text('Affection Level'), findsOneWidget);
    
    // Reset the test size
    addTearDown(tester.view.reset);
  });

  testWidgets('Navigation between screens works', (WidgetTester tester) async {
    // Set a larger test size to accommodate the UI
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    
    await tester.pumpWidget(const MyWaifuApp());
    await tester.pumpAndSettle();

    // Navigate to Messages screen using bottom navigation text
    await tester.tap(find.text('Messages'));
    await tester.pumpAndSettle();
    expect(find.text('Daily Messages'), findsOneWidget);

    // Navigate to Profile screen using bottom navigation text
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Rem\'s Profile'), findsOneWidget);

    // Navigate to Settings screen using bottom navigation text
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    // Use a more specific finder for the Settings screen title in AppBar
    expect(find.widgetWithText(AppBar, 'Settings'), findsOneWidget);

    // Navigate back to Home using bottom navigation text
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('My Waifu App'), findsOneWidget);
    
    // Reset the test size
    addTearDown(tester.view.reset);
  });

  testWidgets('Show Love button increases affection', (WidgetTester tester) async {
    // Set a larger test size to accommodate the UI
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    
    await tester.pumpWidget(const MyWaifuApp());
    await tester.pumpAndSettle();

    // Scroll down to ensure the Show Love button is visible and tappable
    await tester.scrollUntilVisible(
      find.text('Show Love'),
      500.0,
      scrollable: find.byType(Scrollable).first,
    );

    // Find and tap the Show Love button
    await tester.tap(find.text('Show Love'));
    await tester.pumpAndSettle();

    // Verify that a snackbar appears with the correct message
    expect(find.textContaining('Rem loves your attention'), findsOneWidget);
    
    // Reset the test size
    addTearDown(tester.view.reset);
  });

  testWidgets('Talk button shows message', (WidgetTester tester) async {
    // Set a larger test size to accommodate the UI
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    
    await tester.pumpWidget(const MyWaifuApp());
    await tester.pumpAndSettle();

    // Scroll down to ensure the Talk button is visible and tappable
    await tester.scrollUntilVisible(
      find.text('Talk'),
      500.0,
      scrollable: find.byType(Scrollable).first,
    );

    // Find and tap the Talk button
    await tester.tap(find.text('Talk'));
    await tester.pumpAndSettle();

    // Verify that a quote appears in the quote card
    expect(find.textContaining('Rem says:'), findsOneWidget);
    
    // Reset the test size
    addTearDown(tester.view.reset);
  });

  testWidgets('Daily Messages screen functionality', (WidgetTester tester) async {
    // Set a larger test size to accommodate the UI
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    
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
    
    // Reset the test size
    addTearDown(tester.view.reset);
  });

  testWidgets('Settings screen displays user stats', (WidgetTester tester) async {
    // Set a larger test size to accommodate the UI
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    
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
    
    // Reset the test size
    addTearDown(tester.view.reset);
  });
}
