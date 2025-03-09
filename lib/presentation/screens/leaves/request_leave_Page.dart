import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gps_attendance_system/core/models/leave_model.dart';
import 'package:gps_attendance_system/core/services/leave_service.dart';
import 'package:gps_attendance_system/core/themes/app_colors.dart';
import 'package:gps_attendance_system/presentation/screens/admin_dashboard/widgets/custom_text_field.dart';
import 'package:gps_attendance_system/presentation/screens/leaves/widgets/custom_button.dart';
import 'package:gps_attendance_system/presentation/widgets/snakbar_widget.dart';
import 'package:intl/intl.dart';

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
    if (_formKey.currentState!.validate() && selectedLeaveType != null) {
      try {
        // var uuid = Uuid().v4();
        // Create a leave model
        LeaveModel leaveModel = LeaveModel(
          title: titleController.text,
          leaveType: selectedLeaveType!,
          contactNumber: contactController.text,
          status: 'Pending',
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
        titleController.clear();
        contactController.clear();
        startDateController.clear();
        endDateController.clear();
        reasonController.clear();
        setState(() {
          selectedLeaveType = null;
        });
      } catch (e) {
        CustomSnackBar.show(
          context,
          'Error: ${e.toString()}',
          color: chooseSnackBarColor(ToastStates.ERROR),
        );
      }
    } else {
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
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        title: const Text(
          'Apply Leave',
          style: TextStyle(color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.whiteColor),
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
                    labelText: 'Title',
                    hintText: 'Enter Title',
                    controller: titleController,
                  ),
                  CustomTextFormField(
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
                    labelText: 'Contact Number',
                    hintText: 'Enter Contact Number',
                    keyboardType: TextInputType.phone,
                    controller: contactController,
                  ),
                  CustomTextFormField(
                    labelText: 'Start Date',
                    hintText: 'Select Start Date',
                    controller: startDateController,
                    isDateField: true,
                    onDateTap: () => _selectDate(context, startDateController),
                  ),
                  CustomTextFormField(
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
                  ),
                  const SizedBox(height: 20),
                  //--- Apply Leave Button ----//
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
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
