import 'package:flutter_test/flutter_test.dart';
import 'package:wwwbank/data/models/account.dart';

void main() {
  test('Account stores all fields', () {
    const account = Account(
      id: 'acc_001',
      name: 'Everyday Checking',
      type: AccountType.checking,
      balance: 4285.50,
      currency: 'GBP',
    );

    expect(account.id, 'acc_001');
    expect(account.name, 'Everyday Checking');
    expect(account.type, AccountType.checking);
    expect(account.balance, 4285.50);
    expect(account.currency, 'GBP');
  });

  test('AccountType has three values', () {
    expect(AccountType.values.length, 3);
  });
}
