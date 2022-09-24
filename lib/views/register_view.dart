import 'dart:developer' as devtools show log;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_state.dart';
import '../utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (State is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, 'weak password');
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, 'Email Already in use');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Failed to Register');
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'Invalid Email');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Enter your email and password to see your notes '),
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'Enter your email'),
              ),
              TextField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                controller: _password,
                decoration:
                    const InputDecoration(hintText: 'Enter your password'),
              ),
              Center(
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        context.read<AuthBloc>().add(
                              AuthEventRegister(
                                email,
                                password,
                              ),
                            );

                        // try {
                        //   await AuthService.firebase().createUser(
                        //     email: email,
                        //     password: password,
                        //   );
                        //   AuthService.firebase().sendEmailVerification();
                        //   Navigator.of(context).pushNamed(emailVerifyRoute);
                        //   // devtools.log(
                        //   //  userCredentials.toString(),
                        //   //  );
                        // } on WeakPasswordAuthException {
                        //   await showErrorDialog(
                        //     context,
                        //     'Weak Password',
                        //   );
                        // } on EmailAlreadyInUseAuthException {
                        //   await showErrorDialog(
                        //     context,
                        //     'Email already in use',
                        //   );
                        // } on InvalidEmailAuthException {
                        //   await showErrorDialog(
                        //     context,
                        //     'Invalid email',
                        //   );
                        // } on GenericAuthException {
                        //   await showErrorDialog(context, 'Failed to Register');
                        // }
                      },
                      child: const Text('Register'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthEventLogout());
                        // Navigator.of(context).pushNamedAndRemoveUntil(
                        //   loginRoute,
                        //   (route) => false,
                        // );
                      },
                      child: const Text('Already Rgistered? Click Here !!'),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
