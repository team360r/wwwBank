import 'package:flutter/material.dart';
import '../../app_state.dart';
import '../../data/mock_accounts.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.accessible,
    required this.appState,
  });

  final bool accessible;
  final AppState appState;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = MockAccounts.currentUser;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Settings', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 24),

          // Profile section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Text(
                      user.name.split(' ').map((n) => n[0]).join(),
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name, style: theme.textTheme.titleMedium),
                      Text(user.email, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Preferences
          Text('Preferences', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Follow system theme'),
                  value: false,
                  onChanged: (_) {},
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Notifications'),
                  subtitle: const Text('Transaction alerts'),
                  value: true,
                  onChanged: (_) {},
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Currency'),
                  subtitle: const Text('GBP (£)'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Accessibility
          Text('Accessibility', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Accessible Mode'),
                  subtitle: Text(
                    accessible
                        ? 'WCAG AA compliant UI active'
                        : 'Showing inaccessible UI for learning',
                  ),
                  value: accessible,
                  onChanged: (_) => appState.toggleAccessible(),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Reduce Motion'),
                  subtitle: const Text('Minimize animations'),
                  value: false,
                  onChanged: (_) {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Account
          Text('Account', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Help & Support'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('About wwwBank'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.logout, color: theme.colorScheme.error),
                  title: Text(
                    'Sign Out',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                  onTap: appState.logout,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
