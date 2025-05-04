import 'package:flutter/material.dart';
import 'package:voldt/core/common/cubit/app_user/entitites/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

  void updateUser(User? user) {
    if (user != null) {
      emit(AppUserLoggedIn(user));
    } else {
      emit(AppUserLoggedOut());
    }
  }

  void logOut() {
    emit(AppUserLoggedOut());
  }
}
