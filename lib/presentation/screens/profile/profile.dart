import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    user = _auth.currentUser;

    if (user != null) {
      final DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user!.uid).get();

      if (userDoc.exists) {
        setState(() {
          userData = userDoc.data()! as Map<String, dynamic>;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${userData!['name']}',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${userData!['position']}',
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              Text(
                '${userData!['email']}',
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              const Divider(),
              ListView(
                shrinkWrap: true,
                children: const [
                  ListTile(
                    leading: Icon(Icons.person, color: Colors.grey),
                    title: Text('My Profile'),
                    trailing: Icon(Icons.chevron_right, color: Colors.grey),
                  ),
                  ListTile(
                    leading: Icon(Icons.lock, color: Colors.grey),
                    title: Text('Change Password'),
                    trailing: Icon(Icons.chevron_right, color: Colors.grey),
                  ),
                  ListTile(
                    leading: Icon(Icons.description, color: Colors.grey),
                    title: Text('View Attendance Record'),
                    trailing: Icon(Icons.chevron_right, color: Colors.grey),
                  ),
                  ListTile(
                    leading: Icon(Icons.settings, color: Colors.grey),
                    title: Text('Settings'),
                    trailing: Icon(Icons.chevron_right, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
