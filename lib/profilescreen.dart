import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final Map<String, String> reservationDetails; // The reservation details

  // Constructor to accept reservationDetails
  const ProfileScreen({
    Key? key,
    required this.reservationDetails, // The reservation details
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Reservation Details:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Restaurant: ${reservationDetails['restaurant'] ?? 'N/A'}'),
            Text('Date: ${reservationDetails['date'] ?? 'N/A'}'),
            Text('Time: ${reservationDetails['time'] ?? 'N/A'}'),
            Text('People: ${reservationDetails['people'] ?? 'N/A'}'),
            SizedBox(height: 20),

            // Save Button
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Profile updated successfully')),
                );
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
