import 'package:flutter_test/flutter_test.dart';
import 'package:wwwbank/app_state.dart';

void main() {
  late AppState state;

  setUp(() {
    state = AppState();
  });

  group('login/logout', () {
    test('starts logged out', () {
      expect(state.isLoggedIn, isFalse);
    });

    test('login sets isLoggedIn to true', () {
      state.login();
      expect(state.isLoggedIn, isTrue);
    });

    test('logout resets isLoggedIn and currentTab', () {
      state.login();
      state.setTab(2);
      state.logout();
      expect(state.isLoggedIn, isFalse);
      expect(state.currentTab, 0);
    });
  });

  group('tab navigation', () {
    test('starts on tab 0', () {
      expect(state.currentTab, 0);
    });

    test('setTab changes current tab', () {
      state.setTab(2);
      expect(state.currentTab, 2);
    });

    test('setTab to same index does not notify', () {
      int notifyCount = 0;
      state.addListener(() => notifyCount++);
      state.setTab(0);
      expect(notifyCount, 0);
    });
  });

  group('accessible toggle', () {
    test('starts inaccessible', () {
      expect(state.accessible, isFalse);
    });

    test('toggleAccessible flips the flag', () {
      state.toggleAccessible();
      expect(state.accessible, isTrue);
      state.toggleAccessible();
      expect(state.accessible, isFalse);
    });
  });
}
