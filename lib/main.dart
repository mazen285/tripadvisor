import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'firebase_options.dart'; // Import Firebase options
import 'signup.dart';
import 'login.dart';
import 'dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Firebase is initialized
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, // Use platform-specific Firebase options
    );
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TripAdvisor Clone',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/', // Check user authentication state at startup
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/dashboard') {
          final args = settings.arguments as Map<String, dynamic>?;

          if (args != null) {
            final username = args['username'] ?? 'Guest';
            final reservationDetails = args['reservationDetails'] ?? {};

            return MaterialPageRoute(
              builder: (context) => DashboardScreen(
                username: username,
                reservationDetails: reservationDetails,
              ),
            );
          } else {
            return MaterialPageRoute(
              builder: (context) => DashboardScreen(
                username: 'Guest',
                reservationDetails: {},
              ),
            );
          }
        }
        return null; // Default route handling
      },
      home: _buildHome(), // Dynamically decide the initial screen
    );
  }

  Widget _buildHome() {
    // Redirect to dashboard if user is logged in, otherwise to login
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Pass logged-in username and other data if needed
      return DashboardScreen(
        username: user.displayName ?? 'Guest',
        reservationDetails: {}, // Default to empty reservation details
      );
    } else {
      return LoginScreen(); // Show LoginScreen if not authenticated
    }
  }
}
