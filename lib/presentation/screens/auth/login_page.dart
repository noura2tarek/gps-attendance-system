import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_attendance_system/blocs/auth/auth_cubit.dart';
import 'package:gps_attendance_system/presentation/animation/fade.dart';
import 'package:gps_attendance_system/presentation/screens/home/check_in.dart';
import 'package:gps_attendance_system/presentation/widgets/snakbar_widget.dart';
import 'package:gps_attendance_system/presentation/widgets/text_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // log in method
  Future<void> _logIn() async {
    if (_formKey.currentState!.validate()) {
      AuthCubit authCubit = AuthCubit.get(context);
      await authCubit.login(
        email: _emailController.text,
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
        ),
        centerTitle: true,
      ),
      body: BlocListener<AuthCubit, AuthStates>(
        listener: (context, state) {
          if (state is Authenticated) {
            _isLoading = false;
            // check user role first
            // if admin -> navigate to admin dashboard
            // else -> navigate to user home page
            Navigator.pushReplacement(
              context,
              FadePageTransition(
                page: const CheckIn(),
              ),
            );
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
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  //---------- Email text field ----------//
                  TextFormFieldWidget(
                    labelText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    validator: _validateEmail,
                    prefixIcon: Icons.email,
                  ),
                  const SizedBox(height: 10),
                  //---------- Password text field ----------//
                  BlocBuilder<AuthCubit, AuthStates>(
                    builder: (context, state) {
                      AuthCubit authCubit = AuthCubit.get(context);
                      return TextFormFieldWidget(
                        labelText: 'Password',
                        obscureText: authCubit.loginPasswordVisible,
                        controller: _passwordController,
                        validator: _validatePassword,
                        prefixIcon: Icons.lock,
                        suffixIcon: IconButton(
                          onPressed: () {
                            authCubit.changeLoginPasswordVisibility();
                          },
                          icon: Icon(authCubit.loginIcon),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  //---------- Login button ----------//
                  ElevatedButton(
                    onPressed: _logIn,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Validations
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
}
