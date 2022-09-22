import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';

import '../services/auth/bloc/auth_bloc.dart';

class EmailVerifyView extends StatefulWidget {
  const EmailVerifyView({Key? key}) : super(key: key);

  @override
  State<EmailVerifyView> createState() => _EmailVerifyViewState();
}

class _EmailVerifyViewState extends State<EmailVerifyView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Email'),
      ),
      body: Column(
        children: [
          const Text(
              "We've sent you an email verification. Please open it to verify your account"),
          const Text(
              "If you haven't received a verification email yet, press the button below "),
          TextButton(
            onPressed: () /*async */ {
              context
                  .read<AuthBloc>()
                  .add(const AuthEventSendEmailVerification());
              //await AuthService.firebase().sendEmailVerification();
            },
            child: const Text('Send Email Verification'),
          ),
          TextButton(
            onPressed: () /*async */ {
              context.read<AuthBloc>().add(const AuthEventLogout());

              // await AuthService.firebase().logOut();
              // Navigator.of(context).pushNamedAndRemoveUntil(
              //   registerRoute,
              //   (route) => false,
              // );
            },
            child: const Text('Restart'),
          )
        ],
      ),
    );
  }
}
