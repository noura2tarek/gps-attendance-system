// Role enum
import 'package:cloud_firestore/cloud_firestore.dart';

enum Role { admin, employee, manager }

class UserModel {
//  final String? uid;
  final String name;
  final String email;
  final String contactNumber;
  final bool isOnLeave; // for admin to track
  final Role role; // admin, employee, manager

  UserModel({
   // this.uid,
    required this.name,
    required this.email,
    required this.contactNumber,
    required this.isOnLeave,
    required this.role,
  });

  factory UserModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return UserModel(
     // uid: data?['uid'] as String,
      name: data?['name'] as String,
      email: data?['email'] as String,
      contactNumber: data?['contactNumber'] as String,
      isOnLeave: data?['isOnLeave'] as bool,
      role: roleFromString(data?['role'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      //'uid': uid,
      'name': name,
      'email': email,
      'contactNumber': contactNumber,
      'isOnLeave': isOnLeave,
      'role': stringFromRole(role),
    };
  }
}

//////////////////////////
// convert role to string
String stringFromRole(Role role) {
  switch (role) {
    case Role.admin:
      return 'Admin';
    case Role.employee:
      return 'Employee';
    case Role.manager:
      return 'Manager';
  }
}

// convert string from database to role
Role roleFromString(String role) {
  switch (role) {
    case 'Admin':
      return Role.admin;
    case 'Employee':
      return Role.employee;
    case 'Manager':
      return Role.manager;
    default:
      return Role.employee;
  }
}
