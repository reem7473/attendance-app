import 'dart:io';

import 'package:bloc/bloc.dart';
import 'profile_state.dart';
import '../../../../services/api_service.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ApiService apiService;

  ProfileCubit(this.apiService) : super(ProfileInitial());

  Future<void> fetchProfile(int facultyId) async {
    try {
      emit(ProfileLoading());
      final profile = await apiService.fetchFacultyProfile(facultyId);
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError('Failed to fetch profile'));
    }
  }

  Future<void> uploadImage(File image, int facultyId) async {
    try {
      emit(ProfileUploading());
      final imagePath = await apiService.uploadProfileImage(image, facultyId);
      fetchProfile(facultyId); // Fetch updated profile
      emit(ProfileUploaded(imagePath));
    } catch (e) {
      emit(ProfileError('Failed to upload image'));
    }
  }

  Future<void> updateName(int facultyId, String newName) async {
    try {
      emit(ProfileLoading());
      await apiService.updateFacultyName(facultyId, newName);
      fetchProfile(facultyId); // Fetch updated profile
    } catch (e) {
      emit(ProfileError('Failed to update name'));
    }
  }

  Future<void> updatePhoneNumber(int facultyId, String newPhoneNumber) async {
    try {
      emit(ProfileLoading());
      await apiService.updateFacultyPhoneNumber(facultyId, newPhoneNumber);
      fetchProfile(facultyId); // Fetch updated profile
    } catch (e) {
      emit(ProfileError('Failed to update phone number'));
    }
  }

  Future<void> updateEmail(int facultyId, String newEmail) async {
    try {
      emit(ProfileLoading());
      await apiService.updateFacultyEmail(facultyId, newEmail);
      fetchProfile(facultyId); // Fetch updated profile
    } catch (e) {
      emit(ProfileError('Failed to update email'));
    }
  }

  Future<void> updatePassword(int facultyId, String newPassword) async {
    try {
      emit(ProfileLoading());
      await apiService.updateFacultyPassword(facultyId, newPassword);
      fetchProfile(facultyId); // Fetch updated profile
    } catch (e) {
      emit(ProfileError('Failed to update password'));
    }
  }
}
