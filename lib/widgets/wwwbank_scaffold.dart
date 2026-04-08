import 'package:flutter/material.dart';

const List<String> _tabLabels = [
  'Dashboard',
  'Transactions',
  'Transfer',
  'Settings',
];

const List<IconData> _tabIcons = [
  Icons.dashboard_outlined,
  Icons.receipt_long_outlined,
  Icons.swap_horiz_outlined,
  Icons.settings_outlined,
];

const List<IconData> _tabSelectedIcons = [
  Icons.dashboard,
  Icons.receipt_long,
  Icons.swap_horiz,
  Icons.settings,
];

const double _breakpoint = 600;

class WwwBankScaffold extends StatelessWidget {
  const WwwBankScaffold({
    super.key,
    required this.accessible,
    required this.currentIndex,
    required this.onTabChanged,
    required this.onToggleAccessible,
    required this.body,
  });

  final bool accessible;
  final int currentIndex;
  final ValueChanged<int> onTabChanged;
  final VoidCallback onToggleAccessible;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= _breakpoint;

    return Scaffold(
      appBar: AppBar(
        title: const Text('wwwBank'),
        actions: [
          IconButton(
            icon: Icon(
              accessible
                  ? Icons.accessibility_new
                  : Icons.accessibility_new_outlined,
            ),
            tooltip: accessible ? 'Accessible mode ON' : 'Accessible mode OFF',
            onPressed: onToggleAccessible,
          ),
        ],
      ),
      body: isWide
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: currentIndex,
                  onDestinationSelected: onTabChanged,
                  labelType: NavigationRailLabelType.all,
                  destinations: List.generate(
                    _tabLabels.length,
                    (i) => NavigationRailDestination(
                      icon: Icon(_tabIcons[i]),
                      selectedIcon: Icon(_tabSelectedIcons[i]),
                      label: Text(_tabLabels[i]),
                    ),
                  ),
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: body),
              ],
            )
          : body,
      bottomNavigationBar: isWide
          ? null
          : NavigationBar(
              selectedIndex: currentIndex,
              onDestinationSelected: onTabChanged,
              destinations: List.generate(
                _tabLabels.length,
                (i) => NavigationDestination(
                  icon: Icon(_tabIcons[i]),
                  selectedIcon: Icon(_tabSelectedIcons[i]),
                  label: _tabLabels[i],
                ),
              ),
            ),
    );
  }
}
