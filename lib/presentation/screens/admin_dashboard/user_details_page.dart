import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gps_attendance_system/core/models/user_model.dart';
import 'package:gps_attendance_system/core/services/user_services.dart';
import 'package:gps_attendance_system/core/utils/attendance_helper.dart';
import 'package:gps_attendance_system/core/utils/custom_calendar_timeline.dart';
import 'package:intl/intl.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({required this.userModel, super.key});

  final UserModel userModel;

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  DateTime selectedDate = DateTime.now();

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchAttendanceRecords() {
    String selectedDateString = DateFormat('yyyy-M-d').format(selectedDate);

    log("Fetching attendance for ID: ${widget.userModel.id} on $selectedDateString");

    return FirebaseFirestore.instance
        .collection('attendanceRecords')
        .where('userId', isEqualTo: widget.userModel.id)
        .where('date', isEqualTo: selectedDateString)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text('${widget.userModel.name} Attendance')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          children: [
            CustomCalendarTimeline(
              onDateSelected: (date) {
                setState(() => selectedDate = date);
              },
            ),
            const SizedBox(height: 15),
            // Text(widget.userModel.id),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: fetchAttendanceRecords(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  final attendanceRecords = snapshot.data!.docs;
                  if (attendanceRecords.isEmpty) {
                    return const Center(
                        child: Text("No attendance records found"));
                  }

                  return ListView.builder(
                    itemCount: attendanceRecords.length,
                    itemBuilder: (context, index) {
                      final record = attendanceRecords[index];
                      DateTime date = DateFormat('yyyy-M-d')
                          .parse(record['date'] as String);
                      // String status = AttendanceHelper.getAttendanceStatus(record['checkInTime']?.toString() ?? '');
                      // Color statusColor = AttendanceHelper.getStatusColor(status);

                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(
                            date.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.login, color: Colors.green),
                                  const SizedBox(width: 5),
                                  Text("Check-In: ${record['checkInTime']}"),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.logout, color: Colors.red),
                                  const SizedBox(width: 5),
                                  Text("Check-Out: ${record['checkOutTime']}"),
                                ],
                              ),
                              // Row(
                              //   children: [
                              //     Icon(Icons.info, color: statusColor),
                              //     const SizedBox(width: 5),
                              //     Text(status,
                              //         style: TextStyle(
                              //             color: statusColor,
                              //             fontWeight: FontWeight.bold)),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
