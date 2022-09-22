import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/services/auth/firebase_auth_provider.dart';
import 'package:mynotes/views/email_verify_view.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes/create_update_note_view.dart';
import 'package:mynotes/views/notes/notes_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        // loginRoute: (context) => const LoginView(),
        // registerRoute: (context) => const RegisterView(),
        // notesRoute: (context) => const NotesView(),
        // emailVerifyRoute: (context) => EmailVerifyView(),
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedsVerification) {
          return const EmailVerifyView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}






//     return FutureBuilder(
//       future: AuthService.firebase().initialize(),
//       builder: (context, snapshot) {
//         switch (snapshot.connectionState) {
//           case ConnectionState.done:
//             final user = AuthService.firebase().currentUser;
//             if (user != null) {
//               if (user.isEmailVerified) {
//                 return const NotesView();
//               } else {
//                 return EmailVerifyView();
//               }
//             } else {
//               return LoginView();
//             }
//           // print(user);
//           // if (user?.emailVerified ?? false) {
//           //   return const Text('Done');
//           // } else {
//           //   return const EmailVerifyView();
//           // }
//           //return const LoginView();

//           default:
//             return CircularProgressIndicator();
//         }
//       },
//     );
//   }
// }


















// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late final TextEditingController _controller;

//   @override
//   void initState() {
//     _controller = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => CounterBloc(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Testing Bloc'),
//         ),
//         body: BlocConsumer<CounterBloc, CounterState>(
//           listener: (context, state) {
//             _controller.clear();
//           },
//           builder: (context, state) {
//             final invalidValue =
//                 (state is CounterSateInavlidNumber) ? state.invalidValue : '';
//             return Column(
//               children: [
//                 Text('Current Value => ${state.value}'),
//                 Visibility(
//                   child: Text('inavlid Input: $invalidValue'),
//                   visible: state is CounterSateInavlidNumber,
//                 ),
//                 TextField(
//                   controller: _controller,
//                   decoration: InputDecoration(
//                     hintText: 'Enter a number here',
//                   ),
//                   keyboardType: TextInputType.number,
//                 ),
//                 Row(
//                   children: [
//                     TextButton(
//                       onPressed: () {
//                         context.read<CounterBloc>().add(
//                               DecreamentEvent(_controller.text),
//                             );
//                       },
//                       child: const Text('-'),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         context.read<CounterBloc>().add(
//                               IncreamentEvent(_controller.text),
//                             );
//                       },
//                       child: const Text('+'),
//                     ),
//                   ],
//                 )
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// @immutable
// abstract class CounterState {
//   final int value;
//   const CounterState(this.value);
// }

// class CounterStateValid extends CounterState {
//   CounterStateValid(int value) : super(value);
// }

// class CounterSateInavlidNumber extends CounterState {
//   final String invalidValue;
//   const CounterSateInavlidNumber({
//     required this.invalidValue,
//     required int previousValue,
//   }) : super(previousValue);
// }

// @immutable
// abstract class CounterEvent {
//   final String value;
//   const CounterEvent(this.value);
// }

// class IncreamentEvent extends CounterEvent {
//   const IncreamentEvent(String value) : super(value);
// }

// class DecreamentEvent extends CounterEvent {
//   const DecreamentEvent(String value) : super(value);
// }

// class CounterBloc extends Bloc<CounterEvent, CounterState> {
//   CounterBloc() : super(CounterStateValid(0)) {
//     on<IncreamentEvent>((event, emit) {
//       final integer = int.tryParse(event.value);
//       if (integer == null) {
//         emit(
//           CounterSateInavlidNumber(
//             invalidValue: event.value,
//             previousValue: state.value,
//           ),
//         );
//       } else {
//         emit(CounterStateValid(state.value + integer));
//       }
//     });
//     on<DecreamentEvent>((event, emit) {
//       final integer = int.tryParse(event.value);
//       if (integer == null) {
//         emit(
//           CounterSateInavlidNumber(
//             invalidValue: event.value,
//             previousValue: state.value,
//           ),
//         );
//       } else {
//         emit(CounterStateValid(state.value - integer));
//       }
//     });
//   }
// }
