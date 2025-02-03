import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:scrape_supermarkets_uruguay/src/features/public_onboard/bloc/bloc.dart';
import 'package:scrape_supermarkets_uruguay/src/features/public_onboard/views/views.dart';
import 'package:scrape_supermarkets_uruguay/src/helpers/helpers.dart';

class PublicOnboardScreen {
  const PublicOnboardScreen();

  static const path = '/public-onboard';

  static GoRoute route({
    List<RouteBase> routes = const [],
  }) =>
      GoRoute(
        path: path,
        name: path,
        pageBuilder: (context, state) {
          return RouteAnimation.slideDownToUpTransition(
            duration: const Duration(milliseconds: 1500),
            key: state.pageKey,
            child: BlocProvider(
              create: (context) =>
                  PublicOnboardBloc()..add(PublicOnboardListeners()),
              child: const PublicOnboardPage(),
            ),
            curve: Curves.elasticInOut,
          );
        },
        routes: routes,
      );
}
