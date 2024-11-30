import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityCubit extends Cubit<bool> {
  final Connectivity _connectivity = Connectivity();

  ConnectivityCubit() : super(true) {
    _connectivity.onConnectivityChanged.listen((result) {
      emit(result != ConnectivityResult.none);
    });
    checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    var result = await _connectivity.checkConnectivity();
    emit(result != ConnectivityResult.none);
  }
}
