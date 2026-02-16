import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/app_config.dart';
import '../gen/app_localizations.dart';
import 'providers.dart';
import 'router.dart';
import 'theme.dart';

class ZentraApp extends ConsumerStatefulWidget {
  const ZentraApp({super.key});

  @override
  ConsumerState<ZentraApp> createState() => _ZentraAppState();
}

class _ZentraAppState extends ConsumerState<ZentraApp>
    with WidgetsBindingObserver {
  Timer? _ratesTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startRatesUpdates();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopRatesUpdates();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startRatesUpdates();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _stopRatesUpdates();
    }
  }

  void _startRatesUpdates() {
    _stopRatesUpdates();
    ref.read(exchangeRateServiceProvider).updateRates(force: true);
    _ratesTimer = Timer.periodic(
      const Duration(minutes: AppConfig.exchangeRatesUpdateMinutes),
      (_) => ref.read(exchangeRateServiceProvider).updateRatesIfNeeded(),
    );
  }

  void _stopRatesUpdates() {
    _ratesTimer?.cancel();
    _ratesTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsControllerProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Zentra',
      routerConfig: router,
      theme: ZentraTheme.light(),
      darkTheme: ZentraTheme.dark(),
      themeMode: settings.themeMode,
      locale: settings.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
