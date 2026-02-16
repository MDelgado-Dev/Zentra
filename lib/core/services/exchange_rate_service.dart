import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../data/local/app_database.dart';
import '../data/repositories/finance_repository.dart';

class ExchangeRateService {
  ExchangeRateService(this._repository, {http.Client? client})
    : _client = client ?? http.Client();

  final FinanceRepository _repository;
  final http.Client _client;

  Future<void> updateRatesIfNeeded() async {
    final now = DateTime.now();
    final current = await _repository.getExchangeRate('default');
    if (current == null) {
      await _fetchAndStore();
      return;
    }

    final lastUpdate = DateTime.fromMillisecondsSinceEpoch(
      current.lastBcvUpdate > current.lastBinanceUpdate
          ? current.lastBcvUpdate
          : current.lastBinanceUpdate,
    );

    if (now.difference(lastUpdate).inMinutes >=
        AppConfig.exchangeRatesUpdateMinutes) {
      await _fetchAndStore();
    }
  }

  Future<void> updateRates({bool force = false}) async {
    if (force) {
      await _fetchAndStore();
      return;
    }

    await updateRatesIfNeeded();
  }

  Future<void> _fetchAndStore() async {
    try {
      final response = await _client.get(
        Uri.parse(AppConfig.exchangeRatesSource),
      );
      final parsed = _parseRates(response.body);
      if (parsed == null) {
        return;
      }

      final now = DateTime.now().millisecondsSinceEpoch;
      await _repository.upsertExchangeRate(
        ExchangeRatesCompanion.insert(
          id: 'default',
          bcvUsdVes: parsed.bcvUsdVes,
          binanceUsdtVes: parsed.binanceUsdtVes,
          lastBcvUpdate: now,
          lastBinanceUpdate: now,
        ),
      );
    } catch (error) {
      debugPrint('ExchangeRateService error: $error');
    }
  }

  _ParsedRates? _parseRates(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is List) {
        double? bcvRate;
        double? binanceRate;

        for (final entry in decoded) {
          if (entry is! Map<String, dynamic>) {
            continue;
          }
          final fuente = entry['fuente']?.toString().toLowerCase();
          final promedio = entry['promedio'];
          if (promedio is! num) {
            continue;
          }
          if (fuente == 'oficial') {
            bcvRate = promedio.toDouble();
          } else if (fuente == 'paralelo') {
            binanceRate = promedio.toDouble();
          }
        }

        if (bcvRate != null && binanceRate != null) {
          return _ParsedRates(
            bcvUsdVes: bcvRate,
            binanceUsdtVes: binanceRate,
          );
        }
      }
    } catch (_) {
      // Ignore JSON parse errors.
    }

    return null;
  }
}

class _ParsedRates {
  const _ParsedRates({required this.bcvUsdVes, required this.binanceUsdtVes});

  final double bcvUsdVes;
  final double binanceUsdtVes;
}
