import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../gen/app_localizations.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return Scaffold(
      body: navigationShell,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/transactions/new'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add_rounded),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => _onTap(context, index),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.chart_pie),
            label: text.dashboard,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.creditcard),
            label: text.transactions,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.chart_bar),
            label: text.analytics,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.settings),
            label: text.settings,
          ),
        ],
      ),
    );
  }
}
