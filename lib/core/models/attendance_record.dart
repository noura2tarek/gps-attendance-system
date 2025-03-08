import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceRecord {
  final String userId;
  final String type;
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final bool isOnTime;

  AttendanceRecord({
    required this.userId,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.isOnTime,
  });

  factory AttendanceRecord.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data() as Map<String, dynamic>?;
    return AttendanceRecord(
      userId: data?['userId'] as String? ?? 'Unknown',
      type: data?['type'] as String? ?? 'Unknown',
      latitude: (data?['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (data?['longitude'] as num?)?.toDouble() ?? 0.0,
      timestamp: (data?['timestamp'] as Timestamp?)?.toDate() ?? DateTime(2000),
      isOnTime: data?['isOnTime'] as bool ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "userId": userId,
      "type": type,
      "latitude": latitude,
      "longitude": longitude,
      "timestamp": Timestamp.fromDate(timestamp),
      "isOnTime": isOnTime,
    };
  }
}
