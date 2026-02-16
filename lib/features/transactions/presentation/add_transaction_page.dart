import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../app/providers.dart';
import '../../../core/data/local/app_database.dart';
import '../../../core/domain/currency.dart';
import '../../../gen/app_localizations.dart';

class AddTransactionPage extends ConsumerStatefulWidget {
  const AddTransactionPage({super.key});

  @override
  ConsumerState<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends ConsumerState<AddTransactionPage> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  TransactionType _type = TransactionType.expense;
  CurrencyCode _currency = CurrencyCode.ves;
  bool _listening = false;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final amount = double.tryParse(_amountController.text.trim());
    if (title.isEmpty || amount == null) {
      return;
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    final id = const Uuid().v4();

    final transaction = TransactionsCompanion.insert(
      id: id,
      type: transactionTypeToString(_type),
      title: title,
      amount: amount,
      currency: currencyCodeToString(_currency),
      accountId: 'default',
      categoryId: 'uncategorized',
      date: now,
      createdAt: now,
      updatedAt: now,
      isDeleted: const Value(false),
    );

    await ref.read(financeRepositoryProvider).upsertTransaction(transaction);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(text.addTransaction),
        actions: [
          IconButton(
            icon: Icon(
              _listening ? CupertinoIcons.mic_fill : CupertinoIcons.mic,
            ),
            onPressed: () => _toggleVoice(text),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            CupertinoTextField(
              controller: _titleController,
              placeholder: text.addTransaction,
            ),
            const SizedBox(height: 16),
            CupertinoTextField(
              controller: _amountController,
              placeholder: text.balance,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 20),
            Text(text.currency),
            const SizedBox(height: 8),
            CupertinoSlidingSegmentedControl<CurrencyCode>(
              groupValue: _currency,
              children: const {
                CurrencyCode.ves: Text('VES'),
                CurrencyCode.usd: Text('USD'),
                CurrencyCode.usdt: Text('USDT'),
              },
              onValueChanged: (value) {
                if (value != null) {
                  setState(() => _currency = value);
                }
              },
            ),
            const SizedBox(height: 20),
            Text(text.transactions),
            const SizedBox(height: 8),
            CupertinoSlidingSegmentedControl<TransactionType>(
              groupValue: _type,
              children: {
                TransactionType.income: Text(text.income),
                TransactionType.expense: Text(text.expense),
                TransactionType.transfer: Text(text.transfer),
              },
              onValueChanged: (value) {
                if (value != null) {
                  setState(() => _type = value);
                }
              },
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _save, child: Text(text.addTransaction)),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleVoice(AppLocalizations text) async {
    if (_listening) {
      await ref.read(voiceServiceProvider).stopListening();
      if (mounted) {
        setState(() => _listening = false);
      }
      return;
    }

    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(text.voicePermissionDenied)));
      }
      return;
    }

    final voiceService = ref.read(voiceServiceProvider);
    final available = await voiceService.initialize();
    if (!available) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(text.voiceNotAvailable)));
      }
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() => _listening = true);
    await voiceService.startListening(
      onResult: (words) {
        if (!mounted) {
          return;
        }
        _titleController.text = words;
        _maybeApplyAmount(words);
        setState(() => _listening = false);
      },
    );
  }

  void _maybeApplyAmount(String words) {
    final matches = RegExp(r'(\d+[\.,]?\d*)').allMatches(words);
    String? value;
    for (final match in matches) {
      value = match.group(1);
    }
    if (value == null) {
      return;
    }
    final normalized = value.replaceAll(',', '.');
    final amount = double.tryParse(normalized);
    if (amount != null) {
      _amountController.text = amount.toStringAsFixed(2);
    }
  }
}
