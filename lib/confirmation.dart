import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart'; // Import confetti package
import 'dashboard_screen.dart'; // Import DashboardScreen

class ConfirmationScreen extends StatefulWidget {
  final String destination;
  final Map<String, String> reservationDetails;
  final String placeName;

  const ConfirmationScreen({
    required this.destination,
    required this.reservationDetails,
    required this.placeName,
    Key? key,
  }) : super(key: key);

  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  late ConfettiController _confettiController;
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 2)); // Initialize confetti controller
  }

  @override
  void dispose() {
    _confettiController.dispose(); // Dispose confetti controller
    super.dispose();
  }

  // Function to handle scaling effect of the confirm button
  void _scaleButton(bool isPressed) {
    setState(() {
      _scale = isPressed ? 0.95 : 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get reservation details from widget
    String date = widget.reservationDetails['date'] ?? 'Not Selected';
    String time = widget.reservationDetails['time'] ?? 'Not Selected';
    String numberOfPeople = widget.reservationDetails['people'] ?? '1';

    return Scaffold(
      appBar: AppBar(title: Text('Confirmation')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.blue.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title with fade-in animation
              AnimatedOpacity(
                opacity: 1.0,
                duration: Duration(milliseconds: 500),
                child: Text(
                  'You have selected:',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),

              // Card for displaying reservation details
              AnimatedOpacity(
                opacity: 1.0,
                duration: Duration(milliseconds: 800),
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.blue),
                            SizedBox(width: 10),
                            Text('Destination: ${widget.destination}', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.place, color: Colors.blue),
                            SizedBox(width: 10),
                            Text('Place Name: ${widget.placeName}', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.blue),
                            SizedBox(width: 10),
                            Text('Date: $date', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.blue),
                            SizedBox(width: 10),
                            Text('Time: $time', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.group, color: Colors.blue),
                            SizedBox(width: 10),
                            Text('Number of People: $numberOfPeople', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Confirm Button with scaling effect and confetti
              GestureDetector(
                onTapDown: (_) => _scaleButton(true),
                onTapUp: (_) => _scaleButton(false),
                onTapCancel: () => _scaleButton(false),
                child: AnimatedScale(
                  scale: _scale,
                  duration: Duration(milliseconds: 100),
                  curve: Curves.easeInOut,
                  child: ElevatedButton(
                    onPressed: () {
                      _confettiController.play(); // Play confetti when button is pressed
                      // Show confirmation dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text('Confirmation'),
                          content: Text('Your selection has been confirmed!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close the dialog
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const DashboardScreen(username: '',)), // Navigate to DashboardScreen
                                );
                              },
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text('Confirm Selection'),
                  ),
                ),
              ),

              // Confetti effect when button is pressed
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  colors: [Colors.blue, Colors.green, Colors.yellow],
                  numberOfParticles: 20,
                  shouldLoop: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
