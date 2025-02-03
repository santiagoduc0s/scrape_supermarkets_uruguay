import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:scrape_supermarkets_uruguay/src/datasources/datasources.dart';
import 'package:scrape_supermarkets_uruguay/src/features/forgot_password/forgot_password.dart';
import 'package:scrape_supermarkets_uruguay/src/repositories/repositories.dart';

class ForgotPasswordScreen {
  const ForgotPasswordScreen();

  static const path = '/forgot-password';

  static GoRoute route({
    List<RouteBase> routes = const [],
  }) =>
      GoRoute(
        path: path,
        name: path,
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';

          return BlocProvider(
            create: (context) => ForgotPasswordBloc(
              authRepository: AuthRepositoryImpl(
                authDatasource: AuthFirebaseDatasource(),
              ),
            )..add(ForgotPasswordInit(initialEmail: email)),
            child: const ForgotPasswordPage(),
          );
        },
        routes: routes,
      );
}
