
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth_state.dart';

class RegisterNotifier extends StateNotifier<AuthState> {
  RegisterNotifier() : super(AuthState());

  void emailChange(String email) {
    state = state.copyWith(email: email);
  }

  void passwordChange(String password) {
    state = state.copyWith(password: password);
  }
  void usernameChange(String username){
    state = state.copyWith(username: username);
  }
  void fullnameChange(String fullname){
    state = state.copyWith(fullname: fullname);
  }void addressChange(String address){
    state = state.copyWith(address: address);
  }

}

var registerNotifierProvider =
StateNotifierProvider<RegisterNotifier, AuthState>(
      (ref) => RegisterNotifier(),
);
