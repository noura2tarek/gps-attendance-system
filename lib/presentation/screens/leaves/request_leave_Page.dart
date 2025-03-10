import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gps_attendance_system/core/models/leave_model.dart';
import 'package:gps_attendance_system/core/services/leave_service.dart';
import 'package:gps_attendance_system/presentation/screens/admin_dashboard/widgets/custom_text_field.dart';
import 'package:gps_attendance_system/presentation/screens/leaves/widgets/custom_button.dart';
import 'package:gps_attendance_system/presentation/widgets/snakbar_widget.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ApplyLeaveScreen extends StatefulWidget {
  const ApplyLeaveScreen({super.key});

  @override
  _ApplyLeaveScreenState createState() => _ApplyLeaveScreenState();
}

class _ApplyLeaveScreenState extends State<ApplyLeaveScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  String? selectedLeaveType;
  bool _isLoading = false;

  //--- Select Date Method ----//
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  //--- Apply Leave Method ----//
  Future<void> _applyLeave() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate() && selectedLeaveType != null) {
      try {
        var uuid = const Uuid().v4();
        // Create a leave model
        LeaveModel leaveModel = LeaveModel(
          id: uuid,
          title: titleController.text,
          leaveType: selectedLeaveType!,
          contactNumber: contactController.text,
          startDate:
              Timestamp.fromDate(DateTime.parse(startDateController.text)),
          endDate: Timestamp.fromDate(DateTime.parse(endDateController.text)),
          reason: reasonController.text,
          userId: userId ?? 'unknown',
        );
        // Save the leave to the database
        await LeaveService.applyLeave(leaveModel);
        CustomSnackBar.show(
          context,
          'Leave applied successfully!',
          color: chooseSnackBarColor(ToastStates.SUCCESS),
        );
        setState(() {
          _isLoading = false;
        });
        titleController.clear();
        contactController.clear();
        startDateController.clear();
        endDateController.clear();
        reasonController.clear();
        setState(() {
          selectedLeaveType = null;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        CustomSnackBar.show(
          context,
          'Error: ${e.toString()}',
          color: chooseSnackBarColor(ToastStates.ERROR),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      CustomSnackBar.show(
        context,
        'Please fill all fields',
        color: chooseSnackBarColor(ToastStates.ERROR),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Apply Leave',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    context: context,
                    labelText: 'Title',
                    hintText: 'Enter Title',
                    controller: titleController,
                  ),
                  CustomTextFormField(
                    context: context,
                    labelText: 'Leave Type',
                    hintText: 'Select Leave Type',
                    isDropdown: true,
                    dropdownItems: const [
                      'Sick Leave',
                      'Casual Leave',
                      'Annual Leave',
                    ],
                    onChanged: (value) =>
                        setState(() => selectedLeaveType = value),
                  ),
                  CustomTextFormField(
                    context: context,
                    labelText: 'Contact Number',
                    hintText: 'Enter Contact Number',
                    keyboardType: TextInputType.phone,
                    controller: contactController,
                  ),
                  CustomTextFormField(
                    context: context,
                    labelText: 'Start Date',
                    hintText: 'Select Start Date',
                    controller: startDateController,
                    isDateField: true,
                    onDateTap: () => _selectDate(context, startDateController),
                  ),
                  CustomTextFormField(
                    context: context,
                    labelText: 'End Date',
                    hintText: 'Select End Date',
                    controller: endDateController,
                    isDateField: true,
                    onDateTap: () => _selectDate(context, endDateController),
                  ),
                  CustomTextFormField(
                    labelText: 'Reason for Leave',
                    hintText: 'Enter Reason',
                    controller: reasonController,
                    context: context,
                  ),
                  const SizedBox(height: 20),
                  //--- Apply Leave Button ----//
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      isLoading: _isLoading,
                      text: 'Apply Leave',
                      onPressed: _applyLeave,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
