import 'package:flutter/material.dart';
import 'ProfileScreen.dart'; // Ensure this import is correct
import 'CategorySelection.dart'; // Ensure this import is correct

class DashboardScreen extends StatefulWidget {
  final String username; // Accepting username parameter

  const DashboardScreen({Key? key, required this.username}) : super(key: key); // Passing the username in the constructor

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? selectedDestination;
  final List<String> destinations = ['Paris, France', 'Tokyo, Japan', 'New York, USA', 'London, UK'];
  double _scale = 1.0;

  // Method to scale button on press for feedback
  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.95;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.blueAccent,
        leading: GestureDetector(
          onTap: () {
            // Navigate to the profile screen with the username passed
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                  reservationDetails: {'user': widget.username}, // Passing the username to the Profile screen
                ),
              ),
            );
          },
          child: Icon(Icons.account_circle, size: 30),  // User icon
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.blue.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message with username
            AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(milliseconds: 700),
              child: Text(
                'Welcome, ${widget.username}!', // Displaying username
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),

            // Dropdown for destination selection
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: DropdownButtonFormField<String>(
                value: selectedDestination,
                hint: Text('Select a Destination', style: TextStyle(color: Colors.white)),
                items: destinations.map((destination) {
                  return DropdownMenuItem(
                    value: destination,
                    child: Text(destination, style: TextStyle(color: Colors.black)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDestination = value;
                  });
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 30),

            // Confirm Destination Button with scaling effect
            GestureDetector(
              onTapDown: _onTapDown,
              onTapUp: _onTapUp,
              child: AnimatedScale(
                scale: _scale,
                duration: Duration(milliseconds: 100),
                curve: Curves.easeInOut,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    elevation: MaterialStateProperty.all(10.0),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (selectedDestination != null) {
                      // Navigate to CategorySelectionScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategorySelectionScreen(destination: selectedDestination!),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please select a destination!')),
                      );
                    }
                  },
                  child: Text('Confirm Destination'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
