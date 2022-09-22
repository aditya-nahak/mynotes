import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'dart:developer' as devtools show log;

import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/utilities/dialogs/loading_dialog.dart';
import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_state.dart';
import '../utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, 'User Not Found');
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'Wrong Credentials');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentication Error');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Column(
          children: [
            TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'Enter your email'),
            ),
            TextField(
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              controller: _password,
              decoration:
                  const InputDecoration(hintText: 'Enter your password here'),
            ),
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                context.read<AuthBloc>().add(AuthEventLogin(
                      email,
                      password,
                    ));
                //try {

                // //final userCredentials =

                // await AuthService.firebase().logIn(
                //   email: email,
                //   password: password,
                // );
                // final user = AuthService.firebase().currentUser;
                // if (user?.isEmailVerified ?? false) {
                //   //user's email is verified
                //   Navigator.of(context).pushNamedAndRemoveUntil(
                //     notesRoute,
                //     (route) => false,
                //   );
                // } else {
                //   //user's email is NOT verified
                //   Navigator.of(context).pushNamedAndRemoveUntil(
                //     emailVerifyRoute,
                //     (route) => false,
                //   );
                // }

                // //devtools.log(userCredentials.toString());
                // //print(userCredentials);
                // } on UserNotFoundAuthException {
                //   await showErrorDialog(
                //     context,
                //     'User Not Found',
                //   );
                // } on WrongPasswordAuthException {
                //   await showErrorDialog(
                //     context,
                //     'Wrong Password',
                //   );
                // } on GenericAuthException {
                //   await showErrorDialog(
                //     context,
                //     'Authentication Error',
                //   );
                // }
              },
              child: const Text('Login'),
            ),
            TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventShouldRegister());

                  // Navigator.of(context).pushNamedAndRemoveUntil(
                  //   registerRoute,
                  //   (route) => false,
                  // );
                },
                child: const Text('Not Registered yet? Register here !!'))
          ],
        ),
      ),
    );
  }
}
