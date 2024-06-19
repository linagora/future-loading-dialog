// Copyright (c) 2020 Famedly
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:future_loading_dialog/future_loading_dialog.dart';

void main() {
  testWidgets('Future Loading Dialog', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(
      MaterialApp(
        title: 'Test',
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showFutureLoadingDialog(
                loadingTitle: 'Loading...',
                errorTitle: 'Oops, something went wrong',
                errorDescription: 'Please try again later.',
                loadingIcon: const CircularProgressIndicator(),
                context: context,
                errorNextLabel: 'Retry',
                errorBackLabel: 'Cancel',
                future: () => Future.delayed(const Duration(seconds: 1)),
              ),
              child: const Text('Test'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Loading...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Loading...'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
  testWidgets('Future Loading Dialog with Exception',
      (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(
      MaterialApp(
        title: 'Test',
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showFutureLoadingDialog(
                  loadingTitle: 'Loading...',
                  errorTitle: 'Oops, something went wrong',
                  errorDescription: 'Please try again later.',
                  loadingIcon: const CircularProgressIndicator(),
                  context: context,
                  errorNextLabel: 'Retry',
                  errorBackLabel: 'Cancel',
                  future: () async {
                    await Future.delayed(const Duration(seconds: 1));
                    throw 'Oops';
                  }),
              child: const Text('Test'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Loading...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Oops, something went wrong'), findsOneWidget);
    expect(find.text('Please try again later.'), findsOneWidget);
    expect(find.byType(TextButton), findsNWidgets(3));
  });
}
