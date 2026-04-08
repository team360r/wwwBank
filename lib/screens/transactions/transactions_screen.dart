import 'package:flutter/material.dart';

import '../../data/mock_transactions.dart';
import '../../data/models/transaction.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key, required this.accessible});

  final bool accessible;

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String _searchQuery = '';
  String _categoryFilter = 'All';
  int _sortColumnIndex = 0;
  bool _sortAscending = false;

  List<String> get _categories {
    final cats = MockTransactions.all.map((t) => t.category).toSet().toList();
    cats.sort();
    return ['All', ...cats];
  }

  List<Transaction> get _filteredTransactions {
    var txns = MockTransactions.all.toList();

    if (_categoryFilter != 'All') {
      txns = txns.where((t) => t.category == _categoryFilter).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      txns = txns.where((t) =>
          t.merchant.toLowerCase().contains(query) ||
          t.category.toLowerCase().contains(query)).toList();
    }

    switch (_sortColumnIndex) {
      case 0:
        txns.sort((a, b) => _sortAscending
            ? a.date.compareTo(b.date)
            : b.date.compareTo(a.date));
      case 1:
        txns.sort((a, b) => _sortAscending
            ? a.merchant.compareTo(b.merchant)
            : b.merchant.compareTo(a.merchant));
      case 2:
        txns.sort((a, b) => _sortAscending
            ? a.amount.compareTo(b.amount)
            : b.amount.compareTo(a.amount));
    }

    return txns;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Transactions', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 16),
          // Search and filter row
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: 300,
                child: TextField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search transactions...',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
              ),
              DropdownButton<String>(
                value: _categoryFilter,
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _categoryFilter = value);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Data table
          Card(
            child: SizedBox(
              width: double.infinity,
              child: DataTable(
                sortColumnIndex: _sortColumnIndex,
                sortAscending: _sortAscending,
                columns: [
                  DataColumn(
                    label: const Text('Date'),
                    onSort: (i, asc) => setState(() {
                      _sortColumnIndex = i;
                      _sortAscending = asc;
                    }),
                  ),
                  DataColumn(
                    label: const Text('Merchant'),
                    onSort: (i, asc) => setState(() {
                      _sortColumnIndex = i;
                      _sortAscending = asc;
                    }),
                  ),
                  DataColumn(
                    label: const Text('Amount'),
                    numeric: true,
                    onSort: (i, asc) => setState(() {
                      _sortColumnIndex = i;
                      _sortAscending = asc;
                    }),
                  ),
                  const DataColumn(label: Text('Category')),
                ],
                rows: _filteredTransactions.map((txn) {
                  final isCredit = txn.amount > 0;
                  return DataRow(cells: [
                    DataCell(Text(
                      '${txn.date.day}/${txn.date.month}/${txn.date.year}',
                    )),
                    DataCell(Text(txn.merchant)),
                    DataCell(Text(
                      '${isCredit ? "+" : ""}£${txn.amount.abs().toStringAsFixed(2)}',
                      style: TextStyle(
                        color: isCredit
                            ? const Color(0xFF2E7D32)
                            : theme.colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                    DataCell(Text(txn.category)),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
