import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:scrape_supermarkets_uruguay/src/facades/facades.dart' as f;
import 'package:scrape_supermarkets_uruguay/src/features/home/home.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    super.key,
  });

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 2), () {});

      f.Router.instance.goRouter.goNamed(HomeScreen.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final iconProvider = Theme.of(context).icons;

    return Scaffold(
      body: Center(
        child: Hero(
          tag: 'logo',
          child: iconProvider.logo(
            size: UISpacing.space20x,
          ),
        ),
      ),
    );
  }
}
