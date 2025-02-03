import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:scrape_supermarkets_uruguay/src/datasources/storage/storage.dart';
import 'package:scrape_supermarkets_uruguay/src/datasources/user/user.dart';
import 'package:scrape_supermarkets_uruguay/src/facades/facades.dart';
import 'package:scrape_supermarkets_uruguay/src/features/profile/bloc/bloc.dart';
import 'package:scrape_supermarkets_uruguay/src/features/profile/views/views.dart';
import 'package:scrape_supermarkets_uruguay/src/repositories/storage/storage.dart';
import 'package:scrape_supermarkets_uruguay/src/repositories/user/user.dart';

class ProfileScreen {
  const ProfileScreen();

  static const path = '/profile';

  static GoRoute route({
    List<RouteBase> routes = const [],
  }) =>
      GoRoute(
        path: path,
        name: path,
        builder: (context, state) {
          final user = Auth.instance.user()!;

          return BlocProvider(
            create: (context) => ProfileBloc(
              userRepository: UserRepositoryImpl(
                userDatasource: UserFirebaseDatasource(),
              ),
              storageRepository: StorageRepositoryImpl(
                storageDatasource: StorageFirebaseDatasource(),
              ),
              imageUser: user.photo,
              initials: user.initials,
            )..init(),
            child: const ProfilePage(),
          );
        },
        routes: routes,
      );
}
