import 'package:bloc/bloc.dart';
import 'splash_state.dart';
import 'dart:async';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial()) {
    _startSplash();
  }

  void _startSplash() {
    Timer(const Duration(seconds: 3), () {
      emit(SplashLoaded());
    });
  }
}
