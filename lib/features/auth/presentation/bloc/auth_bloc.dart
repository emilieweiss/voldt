import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voldt/core/usecase/usecase.dart';
import 'package:voldt/features/auth/domain/entitites/user.dart';
import 'package:voldt/features/auth/domain/usecases/current_user.dart';
import 'package:voldt/features/auth/domain/usecases/user_login.dart';
import 'package:voldt/features/auth/domain/usecases/user_sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
  }) : _userLogin = userLogin,
       _userSignUp = userSignUp,
       _currentUser = currentUser,
       super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
  }

  void _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _currentUser(NoParams());

    res.fold(
      (failure) {
        emit(AuthFailure(failure.message));
      },
      (user) {
        print(
          'Bruger logget ind: ${user.email}',
        ); // Udskriv til konsollen
        emit(AuthSuccess(user));
      },
    );
  }

  void _onAuthSignUp(
    AuthSignUp event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final res = await _userSignUp(
      UserSignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );

    res.fold((failure) {
      emit(AuthFailure(failure.message));
    }, (user) => emit(AuthSuccess(user)));
  }

  void _onAuthLogin(
    AuthLogin event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final res = await _userLogin(
      UserLoginParams(
        email: event.email,
        password: event.password,
      ),
    );

    res.fold((failure) {
      emit(AuthFailure(failure.message));
    }, (user) => emit(AuthSuccess(user)));
  }
}
