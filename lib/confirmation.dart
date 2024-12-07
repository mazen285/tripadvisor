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
    _confettiController = ConfettiController(duration: Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _scaleButton(bool isPressed) {
    setState(() {
      _scale = isPressed ? 0.95 : 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              // Title
              AnimatedOpacity(
                opacity: 1.0,
                duration: Duration(milliseconds: 500),
                child: Text(
                  'You have selected:',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),

              // Reservation Details Card
              AnimatedOpacity(
                opacity: 1.0,
                duration: Duration(milliseconds: 800),
                child: Card(
                  color: Colors.white,
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(Icons.location_on, 'Destination', widget.destination),
                        _buildInfoRow(Icons.place, 'Place Name', widget.placeName),
                        _buildInfoRow(Icons.calendar_today, 'Date', date),
                        _buildInfoRow(Icons.access_time, 'Time', time),
                        _buildInfoRow(Icons.group, 'Number of People', numberOfPeople),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Confirm Button
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
                      _confettiController.play();
                      _showConfirmationDialog(context);
                    },
                    child: Text('Confirm Selection'),
                  ),
                ),
              ),

              // Confetti
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  colors: [Colors.blue, Colors.green, Colors.yellow],
                  numberOfParticles: 30,
                  shouldLoop: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Info Row Builder
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          SizedBox(width: 10),
          Text(
            '$label: $value',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  // Show Confirmation Dialog
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Confirmation'),
        content: Text('Your selection has been confirmed!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DashboardScreen(
                    username: widget.reservationDetails['user'] ?? 'Guest',
                    reservationDetails: {
                      'destination': widget.destination,
                      'placeName': widget.placeName,
                      'date': widget.reservationDetails['date'] ?? 'Not Selected',
                      'time': widget.reservationDetails['time'] ?? 'Not Selected',
                      'people': widget.reservationDetails['people'] ?? '1',
                    },
                  ),
                ),
              );
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
