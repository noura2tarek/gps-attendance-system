import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_attendance_system/blocs/leaves/leaves_bloc.dart';
import 'package:gps_attendance_system/core/app_routes.dart';
import 'package:gps_attendance_system/presentation/screens/leaves/widgets/custom_button.dart';
import 'package:gps_attendance_system/presentation/screens/leaves/widgets/leaves_status_square.dart';
import 'package:intl/intl.dart';

class LeavesPage extends StatefulWidget {
  const LeavesPage({super.key});

  @override
  State<LeavesPage> createState() => _LeavesPageState();
}

class _LeavesPageState extends State<LeavesPage> {
  String _selectedFilter = 'All';

  final List<String> _filterOptions = [
    'All',
    'Pending',
    'Approved',
    'Rejected'
  ];

  @override
  void initState() {
    super.initState();
    context.read<LeaveBloc>().add(FetchLeaves());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'All Leaves',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Summary of Leave Status
              BlocBuilder<LeaveBloc, LeaveState>(
                builder: (context, state) {
                  if (state is LeaveLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is LeaveError) {
                    return Center(child: Text(state.message));
                  } else if (state is LeaveLoaded) {
                    final leaves = state.leaves;
                    final pendingLeaves = leaves
                        .where((leave) => leave.status == 'Pending')
                        .length;
                    final approvedLeaves = leaves
                        .where((leave) => leave.status == 'Approved')
                        .length;
                    final rejectedLeaves = leaves
                        .where((leave) => leave.status == 'Rejected')
                        .length;

                    return GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        LeaveStatusSquare(
                          title: 'Leave Balance',
                          count: 25, // Example value
                          color: Colors.green,
                          opacity: 0.2,
                        ),
                        LeaveStatusSquare(
                          title: 'Approved',
                          count: approvedLeaves,
                          color: Colors.blue,
                          opacity: 0.2,
                        ),
                        LeaveStatusSquare(
                          title: 'Pending',
                          count: pendingLeaves,
                          color: Colors.orange,
                          opacity: 0.2,
                        ),
                        LeaveStatusSquare(
                          title: 'Rejected',
                          count: rejectedLeaves,
                          color: Colors.red,
                          opacity: 0.2,
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),

              const SizedBox(height: 14),

              // Upcoming Leaves Header
              const Text(
                'Upcoming Leaves',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Filter Dropdown
              Row(
                children: [
                  const Text(
                    'Filter by:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: _selectedFilter,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedFilter = newValue!;
                      });
                      context
                          .read<LeaveBloc>()
                          .add(FilterLeaves(_selectedFilter));
                    },
                    items: _filterOptions
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Upcoming Leaves List
              BlocBuilder<LeaveBloc, LeaveState>(
                builder: (context, state) {
                  if (state is LeaveLoaded) {
                    final filteredLeaves = state.leaves;

                    // Date formatter
                    final dateFormat = DateFormat('yyyy-MM-dd');

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredLeaves.length,
                      itemBuilder: (context, index) {
                        final leave = filteredLeaves[index];
                        final startDate =
                            dateFormat.format(leave.startDate.toDate());
                        final endDate =
                            dateFormat.format(leave.endDate.toDate());
                        final days = leave.endDate
                            .toDate()
                            .difference(leave.startDate.toDate())
                            .inDays;

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            title: Text(
                              '$startDate - $endDate',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              leave.status,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: leave.status == 'Approved'
                                    ? Colors.green
                                    : leave.status == 'Pending'
                                        ? Colors.orange
                                        : Colors.red,
                              ),
                            ),
                            trailing: Text(
                              '$days Day${days != 1 ? 's' : ''}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),

              const SizedBox(height: 10),

              // Request Leave Button
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: CustomButton(
                  text: 'Request a Leave',
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.requestLeave,
                    ).then((_) {
                      // Refresh leaves after returning
                      context.read<LeaveBloc>().add(FetchLeaves());
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
