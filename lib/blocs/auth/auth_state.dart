import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class Authenticated extends AuthState {
  final String userId;
  const Authenticated(this.userId);
  @override
  List<Object?> get props => [userId];
}

class Unauthenticated extends AuthState {}
