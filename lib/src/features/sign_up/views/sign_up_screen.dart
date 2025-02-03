import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:scrape_supermarkets_uruguay/src/datasources/auth/auth.dart';
import 'package:scrape_supermarkets_uruguay/src/datasources/user/user.dart';
import 'package:scrape_supermarkets_uruguay/src/features/sign_up/bloc/bloc.dart';
import 'package:scrape_supermarkets_uruguay/src/features/sign_up/views/views.dart';
import 'package:scrape_supermarkets_uruguay/src/repositories/auth/auth.dart';
import 'package:scrape_supermarkets_uruguay/src/repositories/user/user.dart';

class SignUpScreen {
  const SignUpScreen();

  static const path = '/sign-up';

  static GoRoute route({
    List<RouteBase> routes = const [],
  }) =>
      GoRoute(
        path: path,
        name: path,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => SignUpBloc(
              authRepository: AuthRepositoryImpl(
                authDatasource: AuthFirebaseDatasource(),
              ),
              userRepository: UserRepositoryImpl(
                userDatasource: UserFirebaseDatasource(),
              ),
            ),
            child: const SignUpPage(),
          );
        },
        routes: routes,
      );
}
