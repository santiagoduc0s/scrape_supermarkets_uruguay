import 'package:go_router/go_router.dart';
import 'package:scrape_supermarkets_uruguay/src/features/splash/views/views.dart';
import 'package:scrape_supermarkets_uruguay/src/helpers/helpers.dart';

class SplashScreen {
  const SplashScreen();

  static const path = '/splash';

  static GoRoute route({
    List<RouteBase> routes = const [],
  }) =>
      GoRoute(
        path: path,
        name: path,
        pageBuilder: (context, state) {
          return RouteAnimation.noAnimationTransition(
            key: state.pageKey,
            child: const SplashPage(),
          );
        },
        routes: routes,
      );
}
