import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saibya_daily/Services/local_storage_service.dart';

/// Authentication states
abstract class AuthState {}

class LoggedOut extends AuthState {}

class LoggedIn extends AuthState {}

/// Authentication Cubit
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(LoggedOut());

  final LocalStorageService _storageService = LocalStorageService.instance;

  /// Initialize authentication state based on local storage
  void initAuthState() {
    final bool isLoggedIn = _storageService.isLoggedIn;
    if (isLoggedIn) {
      emit(LoggedIn());
    } else {
      emit(LoggedOut());
    }
  }

  /// Call this method when the user logs in
  void logIn() {
    _storageService.isLoggedIn = true;
    emit(LoggedIn());
  }

  /// Call this method when the user logs out
  Future<void> logOut() async {
    _storageService.isLoggedIn = false;
    _storageService.clearLocalStorage();
    emit(LoggedOut());
  }
}
