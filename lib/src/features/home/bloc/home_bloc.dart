import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrape_supermarkets_uruguay/src/features/home/bloc/bloc.dart';
import 'package:scrape_supermarkets_uruguay/src/helpers/helpers.dart';
import 'package:scrape_supermarkets_uruguay/src/models/models.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required String userName,
  }) : super(HomeState.initial(userName: userName)) {
    on<HomeListen>(_onHomeListen);
    on<UpdateUserName>(_onUpdateUserName);
  }

  late final StreamSubscription<User> userSubscription;

  @override
  Future<void> close() async {
    await userSubscription.cancel();
    return super.close();
  }

  void _onHomeListen(
    HomeListen event,
    Emitter<HomeState> emit,
  ) {
    userSubscription = userUpdateNotifier.stream.listen((user) {
      add(UpdateUserName(user.firstName));
    });
  }

  void _onUpdateUserName(
    UpdateUserName event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(userName: event.userName));
  }
}
