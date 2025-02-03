import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:scrape_supermarkets_uruguay/src/facades/facades.dart';
import 'package:scrape_supermarkets_uruguay/src/features/home/home.dart';

class HomeScreen {
  const HomeScreen();

  static const path = '/home';

  static GoRoute route({
    List<RouteBase> routes = const [],
  }) =>
      GoRoute(
        path: path,
        name: path,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => HomeBloc(
              userName: Auth.instance.user()!.firstName,
            )..add(HomeListen()),
            child: const HomePage(),
          );
        },
        routes: routes,
      );
}
