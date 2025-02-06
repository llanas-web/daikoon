import 'package:bloc/bloc.dart';

enum AuthStatus { home, login, signUp }

class AuthCubit extends Cubit<AuthStatus> {
  AuthCubit() : super(AuthStatus.home);

  void changeAuth({required AuthStatus status}) {
    emit(status);
  }
}
