import 'package:flutter/material.dart';
import 'package:tripadvisor/signup.dart';
import 'login.dart';
import 'dashboard_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TripAdvisor Clone',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login', // Set initial screen as login
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/dashboard') {
          final args = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => DashboardScreen(username: args),
          );
        }
        return null; // Default route handling
      },
    );
  }
}
