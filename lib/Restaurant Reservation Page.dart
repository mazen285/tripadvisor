import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'Payment Screen.dart';

class ReservationScreen extends StatefulWidget {
  final String restaurantName;
  final String destination;

  const ReservationScreen({
    Key? key,
    required this.restaurantName,
    required this.destination,
  }) : super(key: key);

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int numberOfPeople = 1;
  bool isLoading = false;

  // Function to select the date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Function to select the time
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  // Confirm navigation to Payment Screen
  void _confirmReservation(BuildContext context) async {
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select date and time')),
      );
      return;
    }

    if (numberOfPeople < 1 || numberOfPeople > 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Number of people must be between 1 and 20')),
      );
      return;
    }

    setState(() => isLoading = true);

    final reservationDetails = {
      'placeName': widget.restaurantName,
      'destination': widget.destination,
      'date': DateFormat('MMMM dd, yyyy').format(selectedDate!),
      'time': selectedTime!.format(context),
      'people': numberOfPeople.toString(),
    };

    // Simulate delay or perform an API call
    await Future.delayed(Duration(seconds: 2));

    setState(() => isLoading = false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(reservationDetails: reservationDetails),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to discard your changes?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
            false;
        return shouldPop;
      },
      child: Scaffold(
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
                  Text(
                    selectedDate != null
                        ? DateFormat('MMMM dd, yyyy').format(selectedDate!)
                        : 'Select Date',
                  ),
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
                  Text(
                    selectedTime != null ? selectedTime!.format(context) : 'Select Time',
                  ),
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
                onPressed: () => _confirmReservation(context),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Confirm Reservation'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
