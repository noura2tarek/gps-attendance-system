import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_attendance_system/blocs/auth/auth_cubit.dart';
import 'package:gps_attendance_system/core/models/user_model.dart';
import 'package:gps_attendance_system/core/themes/app_colors.dart';
import 'package:gps_attendance_system/presentation/widgets/custom_auth_button.dart';
import 'package:gps_attendance_system/presentation/widgets/snakbar_widget.dart';
import 'package:gps_attendance_system/presentation/widgets/text_form_field.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({
    super.key,
  });

  @override
  State<AddUserPage> createState() => AddUserPageState();
}

class AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  bool isPasswordObscure = true;
  bool isConfirmPasswordObscure = true;

  bool _isLoading = false;

  Role _selectedRole = Role.employee;
  String _selectedGender = 'male';

  void _addNewUser() async {
    if (_formKey.currentState!.validate()) {
      UserModel userModel = UserModel(
        name: _fullNameController.text,
        email: _emailController.text,
        role: _selectedRole,
        contactNumber: _contactController.text,
        position: _positionController.text,
        gender: _selectedGender,
      );

      AuthCubit authCubit = AuthCubit.get(context);
      await authCubit.addUser(
        email: _emailController.text,
        password: _passwordController.text,
        userModel: userModel,
      );
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _contactController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add User',
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {
          if (state is AccountCreated) {
            CustomSnackBar.show(
              context,
              'Account Created Successfully',
              color: chooseSnackBarColor(ToastStates.SUCCESS),
            );
            _isLoading = false;
            _emailController.clear();
            _passwordController.clear();
            _fullNameController.clear();
            _confirmPasswordController.clear();
            _positionController.clear();
            _contactController.clear();
          } else if (state is AuthError) {
            CustomSnackBar.show(
              context,
              state.message,
              color: chooseSnackBarColor(ToastStates.ERROR),
            );
            _isLoading = false;
          } else if (state is AuthLoading) {
            _isLoading = true;
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //----------- Full Name text field ----------//
                    TextFormFieldWidget(
                      keyboardType: TextInputType.name,
                      labelText: 'Full Name',
                      hintText: 'Enter Full Name..',
                      controller: _fullNameController,
                      validator: _validateFullName,
                      prefixIcon: Icons.person,
                    ),
                    const SizedBox(height: 10),
                    //----------- Email text field ----------//
                    TextFormFieldWidget(
                      labelText: 'Email',
                      hintText: 'Enter Email..',
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      validator: _validateEmail,
                      prefixIcon: Icons.email,
                    ),
                    const SizedBox(height: 10),
                    //----------- Password text field ----------//
                    TextFormFieldWidget(
                      keyboardType: TextInputType.visiblePassword,
                      labelText: 'Password',
                      hintText: 'Enter Password..',
                      obscureText: isPasswordObscure,
                      controller: _passwordController,
                      validator: _validatePassword,
                      prefixIcon: Icons.lock,
                      suffixPressed: () {
                        setState(() {
                          isPasswordObscure = !isPasswordObscure;
                        });
                      },
                      suffixIcon: isPasswordObscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    const SizedBox(height: 10),
                    //----------- Confirm Password text field ----------//
                    TextFormFieldWidget(
                      keyboardType: TextInputType.visiblePassword,
                      labelText: 'Confirm Password',
                      hintText: 'Enter Confirm Password..',
                      obscureText: isConfirmPasswordObscure,
                      controller: _confirmPasswordController,
                      validator: _validateConfirmPassword,
                      prefixIcon: Icons.lock,
                      suffixPressed: () {
                        setState(() {
                          isConfirmPasswordObscure = !isConfirmPasswordObscure;
                        });
                      },
                      suffixIcon: isConfirmPasswordObscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    //----------- Phone text field ----------//
                    TextFormFieldWidget(
                      labelText: 'Phone',
                      hintText: 'Enter Phone..',
                      keyboardType: TextInputType.number,
                      controller: _contactController,
                      validator: _validatePhone,
                      prefixIcon: Icons.phone,
                    ),
                    const SizedBox(height: 10),
                    //----------- Position text field ----------//
                    TextFormFieldWidget(
                      labelText: 'Position',
                      hintText: 'Enter Position..',
                      keyboardType: TextInputType.text,
                      controller: _positionController,
                      validator: _validatePosition,
                      prefixIcon: Icons.work,
                    ),
                    const Padding(
                      padding: EdgeInsetsDirectional.all(8),
                      child: Text(
                        'Select user role',
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                    //-- Radio buttons to select user role --//
                    Row(
                      children: [
                        Radio<Role>(
                          value: Role.employee,
                          groupValue: _selectedRole,
                          onChanged: (Role? value) {
                            setState(() {
                              _selectedRole = value!;
                            });
                          },
                        ),
                        const Text('Employee'),
                        Radio<Role>(
                          value: Role.manager,
                          groupValue: _selectedRole,
                          onChanged: (Role? value) {
                            setState(() {
                              _selectedRole = value!;
                            });
                          },
                        ),
                        const Text('Manager'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsetsDirectional.all(8),
                      child: Text(
                        'Select gender',
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                    //-- Radio buttons to select gender --//
                    Row(
                      children: [
                        Radio<String>(
                          value: 'male',
                          groupValue: _selectedGender,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedGender = value!;
                            });
                          },
                        ),
                        const Text('Male'),
                        Radio<String>(
                          value: 'female',
                          groupValue: _selectedGender,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedGender = value!;
                            });
                          },
                        ),
                        const Text('Female'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    //----------- Add User Button ----------//
                    BlocBuilder<AuthCubit, AuthStates>(
                      builder: (context, state) {
                        return CustomAuthButton(
                          buttonText: 'Add User',
                          isLoading: _isLoading,
                          onTap: _addNewUser,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Validations --------------
  String? _validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a full name';
    } else if (!value.startsWith(RegExp(r'[A-Z]'))) {
      return 'Full name must start with a capital letter';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address';
    } else if (!value.contains('@')) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePosition(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a position';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty || value.length != 11) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }
}
