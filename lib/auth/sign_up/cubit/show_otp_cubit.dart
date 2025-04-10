import 'package:flutter_bloc/flutter_bloc.dart';

class ShowOtpCubit extends Cubit<bool> {
  ShowOtpCubit() : super(false);

  void changeScreen({required bool showOtp}) {
    emit(showOtp);
  }
}
