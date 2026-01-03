// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/presentations/screens/admin_dashboard/auth/login_screen.dart';
import 'core/utils/di.dart';
import 'core/utils/token_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TokenService().loadToken();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppDependencies.blocProviders(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Company Employee Login',
        routes: {
          '/': (context) => LoginScreen(),
        },
      ),
    );
  }
}
