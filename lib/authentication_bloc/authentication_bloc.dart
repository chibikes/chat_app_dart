import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pedantic/pedantic.dart';
import 'package:authentication_repository/authentication_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository,
        super(const AuthenticationState.unknown()) {
    _userSubscription = _authenticationRepository.user.listen(
          (user) => add(AuthenticationUserChanged(user)),
    );

  }

  final AuthenticationRepository _authenticationRepository;
  StreamSubscription? _userSubscription;

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event
      ) async* {
    if (event is AuthenticationUserChanged) {
      User user = await _authenticationRepository.getUserData(event.user);
      yield _mapAuthenticationUserChangedToState(user);
    } else if (event is AuthenticationLogOutRequested) {
      unawaited(_authenticationRepository.logOut());
    }
    else if (event is UpdateUser) {
      yield* _mapUpdateUserToState(event);
    }
  }

  @override
  Future<Function?> close() {
    _userSubscription?.cancel();
    return super.close().then((value) => value as Function?);
  }

  AuthenticationState _mapAuthenticationUserChangedToState(
      User user,
      ) {
    return user != User.empty
        ? AuthenticationState.authenticated(user)
        : const AuthenticationState.unauthenticated();
  }

  Stream<AuthenticationState> _mapUpdateUserToState(UpdateUser event) async* {
    await _authenticationRepository.updateUser(event.user);
    add(AuthenticationUserChanged(event.user));
  }
}