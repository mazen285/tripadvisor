import 'package:flutter/material.dart';
import 'Payment Screen.dart';

class ReservationScreen extends StatefulWidget {
  final String restaurantName;
  final String destination;  // Include the destination parameter

  const ReservationScreen({
    Key? key,
    required this.restaurantName,
    required this.destination, // Use destination in the constructor
  }) : super(key: key);

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int numberOfPeople = 1;

  // Function to select the date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  // Function to select the time
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reservation at ${widget.restaurantName}')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Make your reservation at ${widget.restaurantName}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Date picker
            Row(
              children: [
                Text("Date: "),
                Text(selectedDate != null ? "${selectedDate!.toLocal()}".split(' ')[0] : 'Select Date'),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),

            // Time picker
            Row(
              children: [
                Text("Time: "),
                Text(selectedTime != null ? selectedTime!.format(context) : 'Select Time'),
                IconButton(
                  icon: Icon(Icons.access_time),
                  onPressed: () => _selectTime(context),
                ),
              ],
            ),

            // Number of people
            Row(
              children: [
                Text("Number of People: "),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (numberOfPeople > 1) numberOfPeople--;
                    });
                  },
                ),
                Text('$numberOfPeople'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      numberOfPeople++;
                    });
                  },
                ),
              ],
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                if (selectedDate != null && selectedTime != null) {
                  // Convert DateTime and TimeOfDay to String for reservationDetails
                  final reservationDetails = {
                    'restaurant': widget.restaurantName,
                    'destination': widget.destination,  // Pass destination to reservationDetails
                    'date': selectedDate!.toLocal().toString().split(' ')[0], // Convert DateTime to String
                    'time': selectedTime!.format(context), // TimeOfDay to String
                    'people': numberOfPeople.toString(),
                  };

                  // Pass the reservation details to PaymentScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentScreen(reservationDetails: reservationDetails),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select date and time')),
                  );
                }
              },
              child: Text('Confirm Reservation'),
            ),
          ],
        ),
      ),
    );
  }
}
