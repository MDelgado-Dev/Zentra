import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/data/local/app_database.dart';
import '../../../gen/app_localizations.dart';
import '../../transactions/presentation/transactions_controller.dart';

final dashboardExchangeRatesProvider = StreamProvider<List<ExchangeRate>>((
  ref,
) {
  return ref.read(financeRepositoryProvider).watchExchangeRates();
});

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = AppLocalizations.of(context)!;
    final transactionsAsync = ref.watch(transactionsProvider);

    return SafeArea(
      child: transactionsAsync.when(
        data: (items) {
          double income = 0;
          double expense = 0;
          for (final item in items) {
            if (item.type == 'income') {
              income += item.amount;
            } else if (item.type == 'expense') {
              expense += item.amount;
            }
          }
          final balance = income - expense;

          return Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFF8F6F1), Color(0xFFE9F4F0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -60,
                right: -30,
                child: _GlowOrb(
                  color: const Color(0xFFB7E4D7).withValues(alpha: 0.55),
                  size: 180,
                ),
              ),
              Positioned(
                bottom: -50,
                left: -20,
                child: _GlowOrb(
                  color: const Color(0xFF0F6B5A).withValues(alpha: 0.2),
                  size: 160,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text.dashboard,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 20),
                    _BalanceCard(
                      balance: balance,
                      income: income,
                      expense: expense,
                      balanceLabel: text.balance,
                      incomeLabel: text.income,
                      expenseLabel: text.expense,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          text.exchangeRates,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        TextButton(
                          onPressed: () => context.go('/exchange-rates'),
                          child: Text(text.view),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _RatesPreview(),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.balance,
    required this.income,
    required this.expense,
    required this.balanceLabel,
    required this.incomeLabel,
    required this.expenseLabel,
  });

  final double balance;
  final double income;
  final double expense;
  final String balanceLabel;
  final String incomeLabel;
  final String expenseLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final balanceText = balance.toStringAsFixed(2);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F6B5A), Color(0xFF1C8A73)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            balanceLabel,
            style: theme.textTheme.titleMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            balanceText,
            style: theme.textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _Pill(label: incomeLabel, value: income),
              const SizedBox(width: 12),
              _Pill(label: expenseLabel, value: expense),
            ],
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 4),
            Text(
              value.toStringAsFixed(2),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class _RatesPreview extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const _RatesPreviewBody();
  }
}

class _RatesPreviewBody extends ConsumerStatefulWidget {
  const _RatesPreviewBody();

  @override
  ConsumerState<_RatesPreviewBody> createState() => _RatesPreviewBodyState();
}

class _RatesPreviewBodyState extends ConsumerState<_RatesPreviewBody> {
  ExchangeRate? _cachedRate;

  @override
  void initState() {
    super.initState();
    ref.listen<AsyncValue<List<ExchangeRate>>>(
      dashboardExchangeRatesProvider,
      (previous, next) {
        final items = next.valueOrNull;
        if (items != null && items.isNotEmpty) {
          setState(() => _cachedRate = items.first);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ratesAsync = ref.watch(dashboardExchangeRatesProvider);
    final items = ratesAsync.valueOrNull;
    final rate = (items != null && items.isNotEmpty)
        ? items.first
        : _cachedRate;
    final bcvText = rate == null ? '--' : rate.bcvUsdVes.toStringAsFixed(2);
    final binanceText =
        rate == null ? '--' : rate.binanceUsdtVes.toStringAsFixed(2);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _RateLine(label: 'BCV', value: bcvText),
          _RateLine(label: 'Binance', value: binanceText),
        ],
      ),
    );
  }
}

class _RateLine extends StatelessWidget {
  const _RateLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 6),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -math.pi / 8,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
        ),
      ),
    );
  }
}
