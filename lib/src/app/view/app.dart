import 'dart:async';

import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:scrape_supermarkets_uruguay/l10n/l10n.dart';
import 'package:scrape_supermarkets_uruguay/src/facades/facades.dart';
import 'package:scrape_supermarkets_uruguay/src/facades/router.dart' as r;
import 'package:scrape_supermarkets_uruguay/src/helpers/helpers.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final StreamSubscription<Preference> _subscription;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ConnectivityHelper.instance.initialize();
    });

    _subscription = Preference.instance.stream.listen((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = Preference.instance.themeMode;
    final locale = Preference.instance.locale;

    return ReactiveFormConfig(
      validationMessages: validationMessages,
      child: MaterialApp.router(
        scaffoldMessengerKey: AppKeys.instance.scaffoldMessengerKey,
        theme: UIThemeLight.instance.theme,
        darkTheme: UIThemeDark.instance.theme,
        themeMode: themeMode,
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: r.Router.instance.goRouter,
        onGenerateTitle: (context) {
          Localization.buildContext = context;
          return context.l10n.appName;
        },
      ),
    );
  }
}
