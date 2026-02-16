import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../gen/app_localizations.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);
    final authState = ref.watch(authStateProvider);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            text.settings,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          _Section(
            title: text.theme,
            child: CupertinoSlidingSegmentedControl<ThemeMode>(
              groupValue: settings.themeMode,
              children: {
                ThemeMode.system: Text(text.system),
                ThemeMode.light: Text(text.light),
                ThemeMode.dark: Text(text.dark),
              },
              onValueChanged: (value) {
                if (value != null) {
                  controller.setThemeMode(value);
                }
              },
            ),
          ),
          _Section(
            title: text.language,
            child: CupertinoSlidingSegmentedControl<String>(
              groupValue: settings.locale?.languageCode ?? 'system',
              children: {
                'system': Text(text.system),
                'es': Text('ES'),
                'en': Text('EN'),
              },
              onValueChanged: (value) {
                if (value == null || value == 'system') {
                  controller.setLocale(null);
                } else {
                  controller.setLocale(Locale(value));
                }
              },
            ),
          ),
          _Section(
            title: text.auth,
            child: authState.when(
              data: (user) {
                if (user == null) {
                  return _AuthButton(
                    label: text.signInGoogle,
                    onTap: () async {
                      await ref.read(authServiceProvider).signInWithGoogle();
                    },
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${text.signedInAs} ${user.email ?? user.displayName ?? ''}',
                    ),
                    const SizedBox(height: 12),
                    _AuthButton(
                      label: text.signOut,
                      onTap: () async {
                        await ref.read(authServiceProvider).signOut();
                      },
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CupertinoActivityIndicator()),
              error: (error, _) => Text('Error: $error'),
            ),
          ),
          _ToggleTile(
            title: text.offlineMode,
            value: settings.offlineMode,
            onChanged: controller.setOfflineMode,
          ),
          _ToggleTile(
            title: text.sync,
            value: settings.syncEnabled,
            onChanged: controller.setSyncEnabled,
          ),
          _ToggleTile(
            title: text.biometricLock,
            value: settings.biometricLock,
            onChanged: controller.setBiometricLock,
          ),
          _ActionTile(
            title: text.aiAssistant,
            onTap: () => context.go('/ai-chat'),
          ),
          _ActionTile(title: text.voiceInput, onTap: () {}),
          _ActionTile(title: text.export, onTap: () {}),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          CupertinoSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ListTile(
        title: Text(title),
        trailing: const Icon(CupertinoIcons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  const _AuthButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(onPressed: onTap, child: Text(label)),
    );
  }
}
