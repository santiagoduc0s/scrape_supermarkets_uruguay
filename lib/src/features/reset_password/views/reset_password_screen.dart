import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:scrape_supermarkets_uruguay/src/datasources/datasources.dart';
import 'package:scrape_supermarkets_uruguay/src/features/reset_password/reset_password.dart';
import 'package:scrape_supermarkets_uruguay/src/repositories/repositories.dart';

class ResetPasswordScreen {
  const ResetPasswordScreen();

  static const path = '/reset-password';

  static GoRoute route({
    List<RouteBase> routes = const [],
  }) =>
      GoRoute(
        path: path,
        name: path,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => ResetPasswordBloc(
              authRepository: AuthRepositoryImpl(
                authDatasource: AuthFirebaseDatasource(),
              ),
            ),
            child: const ResetPasswordPage(),
          );
        },
        routes: routes,
      );
}
