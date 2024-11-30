import 'package:bloc/bloc.dart';
import '../../../../services/api_service.dart';
import 'registration_state.dart';


class RegistrationCubit extends Cubit<RegistrationState> {
  final ApiService apiService;

  RegistrationCubit(this.apiService) : super(RegistrationInitial());

  Future<void>  registerStudentFaceRepresentation(int id, List<String> images) async {
    emit(RegistrationLoading());
    try {
      final message = await apiService.registerStudentFaceRepresentation(id, images);
      emit(RegistrationSuccess(message));
    } catch (e) {
      emit(RegistrationFailure(e.toString()));
    }
  }
}
