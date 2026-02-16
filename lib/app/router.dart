import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/analytics/presentation/analytics_page.dart';
import '../features/ai_chat/presentation/ai_chat_page.dart';
import '../features/dashboard/presentation/dashboard_page.dart';
import '../features/exchange_rates/presentation/exchange_rates_page.dart';
import '../features/settings/presentation/settings_page.dart';
import '../features/transactions/presentation/add_transaction_page.dart';
import '../features/transactions/presentation/transactions_page.dart';
import 'app_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/dashboard',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardPage(),
              ),
              GoRoute(
                path: '/exchange-rates',
                builder: (context, state) => const ExchangeRatesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/transactions',
                builder: (context, state) => const TransactionsPage(),
              ),
              GoRoute(
                path: '/transactions/new',
                builder: (context, state) => const AddTransactionPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/analytics',
                builder: (context, state) => const AnalyticsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsPage(),
              ),
              GoRoute(
                path: '/ai-chat',
                builder: (context, state) => const AiChatPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
