import 'package:flutter/material.dart';

class ConfirmationScreen extends StatelessWidget {
  final String destination;
  final String category;
  final String option;
  final Map<String, String> reservationDetails;

  // Correct constructor
  const ConfirmationScreen({
    required this.destination,
    required this.category,
    required this.option,
    required this.reservationDetails,  // Correctly pass reservationDetails here
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Confirmation')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Fade-in animation for confirmation text
            AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(milliseconds: 500),
              child: Text('You have selected:', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 20),

            // Animated fade-in text for destination, category, and option
            AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(milliseconds: 800),
              child: Column(
                children: [
                  Text('Destination: $destination', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('Category: $category', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('Option: $option', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Confirm Selection Button with scaling effect
            GestureDetector(
              onTapDown: (_) {
                // Trigger scale effect on button press
                _scaleButton(context, true);
              },
              onTapUp: (_) {
                // Reset scale effect after button press
                _scaleButton(context, false);
              },
              onTapCancel: () {
                // Reset scale effect if the tap is canceled
                _scaleButton(context, false);
              },
              child: AnimatedScale(
                scale: 1.0,
                duration: Duration(milliseconds: 100),
                curve: Curves.easeInOut,
                child: ElevatedButton(
                  onPressed: () {
                    // Show confirmation dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text('Confirmation'),
                        content: Text('Your selection has been confirmed!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // Navigate back to the previous screen (or home screen)
                              Navigator.pop(context); // Close the dialog
                              Navigator.pop(context); // Return to the previous screen (could be home screen)
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
          ],
        ),
      ),
    );
  }

  // Method to scale button on press for feedback
  void _scaleButton(BuildContext context, bool isPressed) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isPressed ? 'Button Pressed' : 'Button Released')));
  }
}
