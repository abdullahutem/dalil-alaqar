import 'package:equatable/equatable.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/entities/updated_user_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileEntity profile;

  const ProfileLoaded({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ProfileUpdating extends ProfileState {}

class ProfileUpdated extends ProfileState {
  final UpdatedUserEntity updatedUser;

  const ProfileUpdated({required this.updatedUser});

  @override
  List<Object?> get props => [updatedUser];
}

class ProfileUpdateError extends ProfileState {
  final String message;

  const ProfileUpdateError({required this.message});

  @override
  List<Object?> get props => [message];
}
