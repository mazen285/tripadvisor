import 'package:flutter/material.dart';
import 'confirmation.dart'; // Ensure this import is correct

class PaymentScreen extends StatelessWidget {
  final Map<String, String> reservationDetails;

  const PaymentScreen({Key? key, required this.reservationDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract details and provide defaults if necessary
    final String category = reservationDetails['category'] ?? 'Unknown Category'; // Default if category is not set
    final String destination = reservationDetails['destination'] ?? 'Unknown Destination';
    final String date = reservationDetails['date'] ?? 'Unknown Date';
    final String time = reservationDetails['time'] ?? 'Unknown Time';
    final String people = reservationDetails['people'] ?? '1';
    final String placeName = reservationDetails['placeName'] ?? 'Unknown Place';

    return Scaffold(
      appBar: AppBar(title: Text('Payment')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display reservation details
            Text(
              'Payment for reservation at $placeName ($category)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Destination: $destination'),
            Text('Date: $date'),
            Text('Time: $time'),
            Text('Number of People: $people'),
            SizedBox(height: 20),

            // Payment form (with placeholders for card details)
            TextField(
              decoration: InputDecoration(labelText: 'Card Number'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Expiry Date (MM/YY)'),
              keyboardType: TextInputType.datetime,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'CVV'),
              keyboardType: TextInputType.number,
              obscureText: true, // To hide the CVV
            ),
            SizedBox(height: 20),

            // Confirm Payment Button
            ElevatedButton(
              onPressed: () {
                // Navigate to ConfirmationScreen after payment
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfirmationScreen(
                      reservationDetails: reservationDetails,
                      destination: destination,
                      category: category, // Pass 'Hotel' or 'Restaurant' as category
                    ),
                  ),
                );
              },
              child: Text('Confirm Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
