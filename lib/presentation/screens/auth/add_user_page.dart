import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_attendance_system/blocs/auth/auth_cubit.dart';
import 'package:gps_attendance_system/core/models/user_model.dart';
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
  bool _isLoading = false;

  // add new user
  void _addNewUser() async {
    if (_formKey.currentState!.validate()) {
      UserModel userModel = UserModel(
        name: _fullNameController.text,
        email: _emailController.text,
        role: Role.employee,
        contactNumber: '',
        isOnLeave: false,
      );

      AuthCubit authCubit = AuthCubit.get(context);
      await authCubit.signUp(
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is AccountCreated) {
          CustomSnackBar.show(
            context,
            'Account Created Successfully',
          );
          _isLoading = false;
          _emailController.clear();
          _passwordController.clear();
          _fullNameController.clear();
          _confirmPasswordController.clear();
        } else if (state is AuthError) {
          CustomSnackBar.show(
            context,
            state.message,
          );
          _isLoading = false;
        } else if (state is AuthLoading) {
          _isLoading = true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Add User',
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: _isLoading
                ? const CircularProgressIndicator()
                : Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        TextFormFieldWidget(
                          labelText: 'Full Name',
                          controller: _fullNameController,
                          validator: _validateFullName,
                          prefixIcon: Icons.person,
                        ),
                        const SizedBox(height: 10),
                        TextFormFieldWidget(
                          labelText: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          validator: _validateEmail,
                          prefixIcon: Icons.email,
                        ),
                        const SizedBox(height: 10),
                        //----------- Password text field ----------//
                        BlocBuilder<AuthCubit, AuthStates>(
                          builder: (context, state) {
                            AuthCubit authCubit = AuthCubit.get(context);
                            return TextFormFieldWidget(
                              labelText: 'Password',
                              obscureText: authCubit.passwordVisible,
                              controller: _passwordController,
                              validator: _validatePassword,
                              prefixIcon: Icons.lock,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  authCubit.changePasswordVisibility();
                                },
                                icon: Icon(authCubit.icon1),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        //----------- Confirm Password text field ----------//
                        BlocBuilder<AuthCubit, AuthStates>(
                          builder: (context, state) {
                            AuthCubit authCubit = AuthCubit.get(context);
                            return TextFormFieldWidget(
                              labelText: 'Confirm Password',
                              obscureText: authCubit.confirmPasswordVisible,
                              controller: _confirmPasswordController,
                              validator: _validateConfirmPassword,
                              prefixIcon: Icons.lock,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  authCubit.changeConfirmPasswordVisibility();
                                },
                                icon: Icon(authCubit.icon2),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        //----------- Add User Button ----------//
                        BlocBuilder<AuthCubit, AuthStates>(
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: _addNewUser,
                              child: _isLoading
                                  ? const CircularProgressIndicator()
                                  : const Text(
                                      'Add User',
                                    ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  // Validations --------------
  String? _validateFullName(String? value) {
    if (value == null || value.isEmpty || !RegExp('^[A-Z]').hasMatch(value)) {
      return 'Full name must start with a capital letter';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty || !value.contains('@')) {
      return 'Enter a valid email address';
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
