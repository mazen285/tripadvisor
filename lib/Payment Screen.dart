import 'package:flutter/material.dart';
import 'confirmation.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, String> reservationDetails;

  const PaymentScreen({Key? key, required this.reservationDetails})
      : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  String paymentMethod = 'Credit Card';

  @override
  Widget build(BuildContext context) {
    // Extract details and provide defaults if necessary
    final String placeName = widget.reservationDetails['placeName'] ?? 'Unknown Place';
    final String destination = widget.reservationDetails['destination'] ?? 'Unknown Destination';
    final String date = widget.reservationDetails['date'] ?? 'Unknown Date';
    final String time = widget.reservationDetails['time'] ?? 'Unknown Time';
    final String people = widget.reservationDetails['people'] ?? '1';

    return Scaffold(
      appBar: AppBar(title: Text('Payment')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reservation Summary
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Reservation Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Place Name: $placeName'),
                  Text('Destination: $destination'),
                  Text('Date: $date'),
                  Text('Time: $time'),
                  Text('Number of People: $people'),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Payment Form
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Payment Method Dropdown
                  Text('Payment Method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    value: paymentMethod,
                    items: [
                      DropdownMenuItem(value: 'Credit Card', child: Text('Credit Card')),
                      DropdownMenuItem(value: 'PayPal', child: Text('PayPal')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        paymentMethod = value!;
                      });
                    },
                  ),
                  SizedBox(height: 20),

                  // Card Number
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Card Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.credit_card),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 16) {
                        return 'Please enter a valid card number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // Expiry Date
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Expiry Date (MM/YY)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    keyboardType: TextInputType.datetime,
                    validator: (value) {
                      if (value == null || value.isEmpty || !RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$').hasMatch(value)) {
                        return 'Please enter a valid expiry date';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // CVV
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length != 3) {
                        return 'Please enter a valid CVV';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),

            // Confirm Payment Button
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Show loading indicator
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => Center(child: CircularProgressIndicator()),
                    );

                    // Simulate payment processing delay
                    await Future.delayed(Duration(seconds: 2));

                    // Close loading indicator and navigate to ConfirmationScreen
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConfirmationScreen(
                          reservationDetails: widget.reservationDetails,
                          destination: destination,
                          placeName: placeName, // Pass placeName here
                        ),
                      ),
                    );
                  } else {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill in all fields correctly')),
                    );
                  }
                },
                child: Text('Confirm Payment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
