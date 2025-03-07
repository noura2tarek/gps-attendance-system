part of 'auth_cubit.dart';

@immutable
sealed class AuthStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthStates {}

class AuthLoading extends AuthStates {}

class Authenticated extends AuthStates {
  Authenticated(this.userId);

  final String userId;

  @override
  List<Object?> get props => [userId];
}

class Unauthenticated extends AuthStates {}

class AuthError extends AuthStates {
  AuthError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class AccountCreated extends AuthStates {}

class ChangePasswordVisibility extends AuthStates {}

class ChangeConfirmPasswordVisibility extends AuthStates {}
