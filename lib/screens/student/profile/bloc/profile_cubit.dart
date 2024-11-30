import 'dart:io';

import 'package:bloc/bloc.dart';
import '../../../../services/api_service.dart';
import 'profile_state.dart';

class ProfileStudentCubit extends Cubit<ProfileStudentState> {
  final ApiService apiService;

  ProfileStudentCubit(this.apiService) : super(ProfileInitial());

  Future<void> fetchProfile(int studentId) async {
    try {
      emit(ProfileLoading());
      final profile = await apiService.fetchStudentProfile(studentId);
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError('Failed to fetch profile'));
    }
  }

  Future<void> uploadImage(File image, int studentId) async {
    try {
      emit(ProfileUploading());
      final imagePath =
          await apiService.uploadProfileImageStudent(image, studentId);

      emit(ProfileUploaded(imagePath));
      fetchProfile(studentId);
    } catch (e) {
      emit(ProfileError('Failed to upload image'));
    }
  }

  Future<void> updateName(int studentId, String newName) async {
    try {
      emit(ProfileLoading());
      await apiService.updateStudentName(studentId, newName);
      fetchProfile(studentId);
      // Fetch updated profile
    } catch (e) {
      emit(ProfileError('Failed to update name'));
    }
  }

  Future<void> updatePhoneNumber(int studentId, String newUnNumber) async {
    try {
      emit(ProfileLoading());
      await apiService.updateStudentUnNumber(studentId, newUnNumber);
      fetchProfile(studentId);
    } catch (e) {
      emit(ProfileError('Failed to update un number'));
    }
  }

  Future<void> updateEmail(int studentId, String newEmail) async {
    try {
      emit(ProfileLoading());
      await apiService.updateStudentEmail(studentId, newEmail);
      fetchProfile(studentId);
    } catch (e) {
      emit(ProfileError('هذا الايميل موجود فعلا'));
    }
  }

  Future<void> updatePassword(int studentId, String newPassword) async {
    try {
      emit(ProfileLoading());
      await apiService.updateStudentPassword(studentId, newPassword);
      fetchProfile(studentId);
    } catch (e) {
      emit(ProfileError('Failed to update password'));
    }
  }
}
