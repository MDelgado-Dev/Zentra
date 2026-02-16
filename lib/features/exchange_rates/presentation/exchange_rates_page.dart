import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/data/local/app_database.dart';
import '../../../gen/app_localizations.dart';

final exchangeRatesProvider = StreamProvider<List<ExchangeRate>>((ref) {
  return ref.read(financeRepositoryProvider).watchExchangeRates();
});

class ExchangeRatesPage extends ConsumerWidget {
  const ExchangeRatesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = AppLocalizations.of(context)!;
    final ratesAsync = ref.watch(exchangeRatesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(text.exchangeRates)),
      body: ratesAsync.when(
        data: (items) {
          final rate = items.isNotEmpty ? items.first : null;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _RateTile(label: 'BCV USD/VES', value: rate?.bcvUsdVes ?? 0),
              const SizedBox(height: 12),
              _RateTile(
                label: 'Binance USDT/VES',
                value: rate?.binanceUsdtVes ?? 0,
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await ref.read(exchangeRateServiceProvider).updateRates(force: true);
        },
        label: Text(text.update),
        icon: const Icon(Icons.refresh),
      ),
    );
  }
}

class _RateTile extends StatelessWidget {
  const _RateTile({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
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
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text(value.toStringAsFixed(2)),
        ],
      ),
    );
  }
}
