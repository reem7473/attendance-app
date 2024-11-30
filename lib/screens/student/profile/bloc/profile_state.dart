import 'package:equatable/equatable.dart';

class ProfileStudentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileStudentState {}

class ProfileLoading extends ProfileStudentState {}

class ProfileLoaded extends ProfileStudentState {
  final Map<String, dynamic> profile;

  ProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileError extends ProfileStudentState {
  final String error;

  ProfileError(this.error);

  @override
  List<Object?> get props => [error];
}

class ProfileUploading extends ProfileStudentState {}

class ProfileUploaded extends ProfileStudentState {
  final String imagePath;

  ProfileUploaded(this.imagePath);
}



