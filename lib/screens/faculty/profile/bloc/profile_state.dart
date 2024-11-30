import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Map<String, dynamic> profile;

  ProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileError extends ProfileState {
  final String error;

  ProfileError(this.error);

  @override
  List<Object?> get props => [error];
}

class ProfileUploading extends ProfileState {}

class ProfileUploaded extends ProfileState {
  final String imagePath;

  ProfileUploaded(this.imagePath);
}


