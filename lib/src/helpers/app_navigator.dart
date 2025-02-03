import 'package:scrape_supermarkets_uruguay/src/facades/facades.dart';
import 'package:scrape_supermarkets_uruguay/src/features/features.dart';

class AppNavigator {
  AppNavigator._singleton();

  static final AppNavigator instance = AppNavigator._singleton();

  Future<String?> pushForgotPassword({
    String? email,
  }) {
    return Router.instance.goRouter.pushNamed<String>(
      ForgotPasswordScreen.path,
      queryParameters: {
        'email': email ?? '',
      },
    );
  }
}
