import 'package:flutter/material.dart';
import 'confirmation.dart';  // Ensure this import is correct

class PaymentScreen extends StatelessWidget {
  final Map<String, String> reservationDetails;

  const PaymentScreen({Key? key, required this.reservationDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure that 'destination' and 'category' are not null. Provide default values if they are null.
    final String restaurant = reservationDetails['restaurant'] ?? 'Unknown Restaurant';
    final String destination = reservationDetails['destination'] ?? 'Unknown Destination';
    final String category = reservationDetails['category'] ?? 'Unknown Category';
    final String date = reservationDetails['date'] ?? 'Unknown Date';
    final String time = reservationDetails['time'] ?? 'Unknown Time';
    final String people = reservationDetails['people'] ?? '1';

    return Scaffold(
      appBar: AppBar(title: Text('Payment')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Payment for reservation at $restaurant',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Date: $date'),
            Text('Time: $time'),
            Text('Number of People: $people'),
            SizedBox(height: 20),

            // Payment form (just a placeholder)
            TextField(
              decoration: InputDecoration(labelText: 'Card Number'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Expiry Date'),
              keyboardType: TextInputType.datetime,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'CVV'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                // After payment confirmation, navigate to the ConfirmationScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfirmationScreen(
                      reservationDetails: reservationDetails,
                      destination: destination,
                      category: category,
                      option: restaurant,
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
