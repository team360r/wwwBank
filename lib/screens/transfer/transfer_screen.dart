import 'package:flutter/material.dart';

import '../../data/mock_accounts.dart';
import '../../data/models/account.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key, required this.accessible});

  final bool accessible;

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  Account? _fromAccount;
  Account? _toAccount;
  bool _transferComplete = false;

  @override
  void initState() {
    super.initState();
    _fromAccount = MockAccounts.everydayChecking;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_transferComplete) {
      return Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, size: 64, color: const Color(0xFF2E7D32)),
                const SizedBox(height: 16),
                Text('Transfer Complete', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  '£${_amountController.text} sent successfully.',
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => setState(() {
                    _transferComplete = false;
                    _currentStep = 0;
                    _amountController.clear();
                    _referenceController.clear();
                    _toAccount = null;
                  }),
                  child: const Text('Make Another Transfer'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Transfer Money', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Stepper(
                currentStep: _currentStep,
                onStepContinue: () {
                  if (_currentStep == 0) {
                    setState(() => _currentStep = 1);
                  } else if (_currentStep == 1) {
                    if (_formKey.currentState!.validate()) {
                      setState(() => _currentStep = 2);
                    }
                  } else {
                    setState(() => _transferComplete = true);
                  }
                },
                onStepCancel: () {
                  if (_currentStep > 0) {
                    setState(() => _currentStep -= 1);
                  }
                },
                steps: [
                  Step(
                    title: const Text('From Account'),
                    isActive: _currentStep >= 0,
                    state: _currentStep > 0
                        ? StepState.complete
                        : StepState.indexed,
                    content: Column(
                      children: MockAccounts.all
                          .where((a) => a.type != AccountType.credit)
                          .map((account) => RadioListTile<Account>(
                                title: Text(account.name),
                                subtitle: Text(
                                  '£${account.balance.toStringAsFixed(2)}',
                                ),
                                value: account,
                                groupValue: _fromAccount,
                                onChanged: (v) =>
                                    setState(() => _fromAccount = v),
                              ))
                          .toList(),
                    ),
                  ),
                  Step(
                    title: const Text('Details'),
                    isActive: _currentStep >= 1,
                    state: _currentStep > 1
                        ? StepState.complete
                        : StepState.indexed,
                    content: Column(
                      children: [
                        DropdownButtonFormField<Account>(
                          value: _toAccount,
                          decoration: const InputDecoration(
                            labelText: 'To Account',
                            border: OutlineInputBorder(),
                          ),
                          items: MockAccounts.all
                              .where((a) => a != _fromAccount)
                              .map((a) => DropdownMenuItem(
                                    value: a,
                                    child: Text(a.name),
                                  ))
                              .toList(),
                          onChanged: (v) => setState(() => _toAccount = v),
                          validator: (v) =>
                              v == null ? 'Select a destination account' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _amountController,
                          decoration: const InputDecoration(
                            labelText: 'Amount (£)',
                            border: OutlineInputBorder(),
                            prefixText: '£ ',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Enter an amount';
                            final amount = double.tryParse(v);
                            if (amount == null || amount <= 0) {
                              return 'Enter a valid amount';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _referenceController,
                          decoration: const InputDecoration(
                            labelText: 'Reference (optional)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Step(
                    title: const Text('Confirm'),
                    isActive: _currentStep >= 2,
                    content: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _ConfirmRow(
                              label: 'From',
                              value: _fromAccount?.name ?? '',
                            ),
                            _ConfirmRow(
                              label: 'To',
                              value: _toAccount?.name ?? '',
                            ),
                            _ConfirmRow(
                              label: 'Amount',
                              value: '£${_amountController.text}',
                            ),
                            if (_referenceController.text.isNotEmpty)
                              _ConfirmRow(
                                label: 'Reference',
                                value: _referenceController.text,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  const _ConfirmRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}
