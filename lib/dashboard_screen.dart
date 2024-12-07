import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // For logout
import 'ProfileScreen.dart'; // Ensure this import is correct
import 'CategorySelection.dart'; // Ensure this import is correct
import 'login.dart'; // Ensure this import is correct

class DashboardScreen extends StatefulWidget {
  final String username; // Accepting username parameter
  final Map<String, String> reservationDetails; // Accepting reservation details

  const DashboardScreen({
    Key? key,
    required this.username,
    required this.reservationDetails,
  }) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? selectedDestination;
  final List<String> destinations = [
    'Paris, France',
    'Tokyo, Japan',
    'New York, USA',
    'London, UK',
    'Sydney, Australia',
    'Rome, Italy',
    'Barcelona, Spain',
    'Cape Town, South Africa',
    'Dubai, UAE',
    'Rio de Janeiro, Brazil',
    'Bangkok, Thailand',
    'Amsterdam, Netherlands',
    'Seoul, South Korea',
    'Buenos Aires, Argentina',
    'Cairo, Egypt',
    'Istanbul, Turkey',
    'Athens, Greece',
    'San Francisco, USA',
    'Moscow, Russia',
  ];

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
    final reservation = widget.reservationDetails;
    final destination = reservation['destination'] ?? 'Not Available';
    final placeName = reservation['placeName'] ?? 'Not Available';
    final date = reservation['date'] ?? 'Not Available';
    final time = reservation['time'] ?? 'Not Available';
    final people = reservation['people'] ?? 'Not Available';

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                  reservationDetails: {
                    'user': widget.username,
                    ...widget.reservationDetails,
                  },
                ),
              ),
            );
          },
          child: Icon(Icons.account_circle, size: 30),
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
            // Welcome Message
            Text(
              'Welcome, ${widget.username}!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),

            // Destination Dropdown
            _buildDestinationDropdown(),
            SizedBox(height: 20),

            // Confirm Destination Button
            _buildConfirmButton(),

            SizedBox(height: 20),

            // Reservation Details
            Text(
              'Reservation Details:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Reservation List
            _buildReservationList(destination, placeName, date, time, people),
          ],
        ),
      ),

      // Logout Button
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to logout: $e')),
            );
          }
        },
        child: Icon(Icons.exit_to_app),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  Widget _buildDestinationDropdown() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedDestination,
        style: TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        ),
        hint: Text('Select a Destination', style: TextStyle(color: Colors.grey)),
        items: destinations.map((destination) {
          return DropdownMenuItem(
            value: destination,
            child: Row(
              children: [
                Icon(Icons.location_on, color: Colors.black),
                SizedBox(width: 10),
                Text(destination),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedDestination = value;
          });
        },
      ),
    );
  }

  Widget _buildConfirmButton() {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      child: AnimatedScale(
        scale: _scale,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: ElevatedButton(
          onPressed: () {
            if (selectedDestination == null || selectedDestination!.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please select a destination!')),
              );
              return;
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategorySelectionScreen(destination: selectedDestination!),
              ),
            );
          },
          child: Text('Confirm Destination'),
        ),
      ),
    );
  }

  Widget _buildReservationList(String destination, String placeName, String date, String time, String people) {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            leading: Icon(Icons.restaurant, color: Colors.blue),
            title: Text('Restaurant Reservation', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Pending: $time, $people people'),
            trailing: Icon(Icons.timer, color: Colors.orange),
          ),
          ListTile(
            leading: Icon(Icons.location_on, color: Colors.blue),
            title: Text('Destination: $destination', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Place: $placeName'),
            trailing: Icon(Icons.info, color: Colors.blue),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today, color: Colors.blue),
            title: Text('Date: $date', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Time: $time'),
            trailing: Icon(Icons.access_time, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
