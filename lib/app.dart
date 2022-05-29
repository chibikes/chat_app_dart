import 'package:authentication_repository/authentication_repository.dart';
import 'package:chat_app_dart/message_bloc/bloc/message_bloc.dart';
import 'package:chat_app_dart/message_bloc/bloc/message_event.dart';
import 'package:chat_app_dart/screens/users_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'authentication_bloc/authentication_bloc.dart';
import 'login_screen/login.dart';
import 'message_bloc/bloc/message_state.dart';
import 'theme.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required this.authenticationRepository,
  }) : super(key: key);

  final AuthenticationRepository authenticationRepository;


  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthenticationBloc(
              authenticationRepository: authenticationRepository,
            ),
          ),
          BlocProvider(create: (_) => MessageBloc(MessagesLoading(), MessagesRepository())..add(LoadRecentMessages(),),),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState? get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      navigatorKey: _navigatorKey,
      routes: {
        '/': (context) {
          return Scaffold(
            backgroundColor: const Color(0xff521c99),
            body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                if (state.status == AuthenticationStatus.authenticated) {
                  return const UsersPage();
                }
                else {
                  return const LoginPage();
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          );
        },
      },
    );
  }
}

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('chat app 1.1'),
      ),
    );
  }

  static route() {
    return MaterialPageRoute(builder: (builder) {
      return const SplashPage();
    });
  }

}
