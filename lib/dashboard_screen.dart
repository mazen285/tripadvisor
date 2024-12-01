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
    'Dubai, UAE',
    'Buenos Aires, Argentina',
    'Cairo, Egypt',
    'Istanbul, Turkey',
    'Athens, Greece',
    'San Francisco, USA',
    'Moscow, Russia'
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
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
          child: Icon(Icons.account_circle, size: 30), // User icon
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
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Destination Selection UI
            _buildDestinationDropdown(),

            SizedBox(height: 30),

            // Confirm Destination Button
            _buildConfirmButton(),

            SizedBox(height: 20),

            // Cards with destination info


            SizedBox(height: 20),

            // List of reservations or other dynamic content
            _buildReservationList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Floating action button logic (e.g., add new reservation)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Add New Reservation!')),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  // Destination Dropdown with icons and hint
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
        hint: Text('Select a Destination', style: TextStyle(color: Colors.white)),
        items: destinations.map((destination) {
          return DropdownMenuItem(
            value: destination,
            child: Row(
              children: [
                Icon(Icons.location_on, color: Colors.black),
                SizedBox(width: 10),
                Text(destination, style: TextStyle(color: Colors.black)),
              ],
            ),
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
    );
  }

  // Confirm Button with scaling effect
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
    );
  }


  // ListTile Widget for Reservations
  Widget _buildReservationList() {
    return ListView(
      shrinkWrap: true,
      children: [
        ListTile(
          leading: Icon(Icons.restaurant, color: Colors.blue),
          title: Text('Restaurant Reservation'),
          subtitle: Text('Confirmed: 5:00 PM, 2 people'),
          trailing: Icon(Icons.check_circle, color: Colors.green),
          onTap: () {
            // Handle reservation item tap
          },
        ),
        ListTile(
          leading: Icon(Icons.restaurant, color: Colors.blue),
          title: Text('Restaurant Reservation'),
          subtitle: Text('Pending: 7:00 PM, 4 people'),
          trailing: Icon(Icons.timer, color: Colors.orange),
          onTap: () {
            // Handle reservation item tap
          },
        ),
      ],
    );
  }
}
