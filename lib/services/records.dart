
// States
import 'package:bloc/bloc.dart';

import 'api_service.dart';

abstract class RecordsState {}

class RecordsInitial extends RecordsState {}

class RecordsLoading extends RecordsState {}

class RecordsLoaded extends RecordsState {
  final  List<Map<String, dynamic>> records;
  RecordsLoaded(this.records);
}

class RecordsError extends RecordsState {
  final String message;
  RecordsError(this.message);
}

class FingerprintLoading extends RecordsState {}

class FingerprintLoaded extends RecordsState {
  final  List<Map<String, dynamic>> fingerprint;
  FingerprintLoaded(this.fingerprint);
}

class FingerprintError extends RecordsState {
  final String message;
  FingerprintError(this.message);
}

// Cubit
class RecordsCubit extends Cubit<RecordsState> {
  final ApiService _apiService = ApiService();

  RecordsCubit() : super(RecordsInitial());

  Future<void> fetchAttendanceRecords(int faculty_id) async {
    emit(RecordsLoading());
    try {
      final records = await _apiService.fetchAttendanceRecords(faculty_id);
      emit(RecordsLoaded(records));
    } catch (e) {
      emit(RecordsError('Failed to fetch records: $e'));
    }
  }

    Future<void>  fetchFingerprintPreparation(int faculty_id) async {
    emit(FingerprintLoading());
    try {
      final Fingerprint = await _apiService.fetchFingerprintPreparation(faculty_id);
      emit(FingerprintLoaded(Fingerprint));
    } catch (e) {
      emit(FingerprintError('Failed to fetch records: $e'));
    }
  }
}