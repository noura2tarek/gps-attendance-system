// import 'dart:async';
// import 'package:bloc/bloc.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:gps_attendance_system/blocs/auth/auth_event.dart';
// import 'package:gps_attendance_system/blocs/auth/auth_state.dart';
//
// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//
//   AuthBloc() : super(AuthInitial()) {
//     // Listen for changes in Firebase Author's state.
//     _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
//       if (user != null) {
//         add(LoggedIn());
//       } else {
//         add(LoggedOut());
//       }
//     });
//
//     // Define event handlers.
//     on<AppStarted>(_onAppStarted);
//     on<LoggedIn>(_onLoggedIn);
//     on<LoggedOut>(_onLoggedOut);
//   }
//   late final StreamSubscription<User?> _authSubscription;
//
//   Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       emit(Authenticated(user.uid));
//     } else {
//       emit(Unauthenticated());
//     }
//   // }
//
//   void _onLoggedIn(LoggedIn event, Emitter<AuthState> emit) {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       emit(Authenticated(user.uid));
//     }
//   }
//
//   void _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) {
//     emit(Unauthenticated());
//   }
//
//   @override
//   Future<void> close() {
//     _authSubscription.cancel();
//     return super.close();
//   }
// }
