import 'package:go_router/go_router.dart';
import 'package:scrape_supermarkets_uruguay/src/facades/facades.dart';

class RouterHelper {
  static RouteMatchList get getCurrentRouteMatch {
    final router = Router.instance.goRouter;

    if (router.routerDelegate.currentConfiguration.isEmpty) {
      return router.routerDelegate.currentConfiguration;
    }

    final lastMatch = router.routerDelegate.currentConfiguration.last;
    final matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : router.routerDelegate.currentConfiguration;

    return matchList;
  }
}
