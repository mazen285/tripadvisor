import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ProfileScreen.dart';
import 'CategorySelection.dart';
import 'login.dart';

class DashboardScreen extends StatefulWidget {
  final String username;
  final Map<String, String> reservationDetails;

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
  List<String> destinations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDestinations();
  }

  Future<void> fetchDestinations() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('destination').get();
      if (snapshot.docs.isNotEmpty) {
        final fetchedDestinations = snapshot.docs.map((doc) => doc['name'] as String).toList();
        setState(() {
          destinations = fetchedDestinations;
          isLoading = false; // Stop loading spinner
        });
      } else {
        setState(() {
          destinations = [];
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No destinations found in the database!')),
        );
      }
    } catch (e) {
      print("Error fetching destinations: $e");
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching destinations. Please try again later.')),
      );
    }
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
            Text(
              'Welcome, ${widget.username}!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : destinations.isEmpty
                ? Center(child: Text('No destinations available.', style: TextStyle(color: Colors.white)))
                : _buildDestinationDropdown(),
            SizedBox(height: 20),
            _buildConfirmButton(),
            SizedBox(height: 20),
            Text(
              'Reservation Details:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildReservationList(destination, placeName, date, time, people),
          ],
        ),
      ),
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
    return ElevatedButton(
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
