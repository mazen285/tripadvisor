import 'package:flutter/material.dart';
import 'confirmation.dart';

class CategorySelectionScreen extends StatefulWidget {
  final String destination;

  const CategorySelectionScreen({Key? key, required this.destination}) : super(key: key);

  @override
  _CategorySelectionScreenState createState() => _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  String? selectedCategory;
  final List<String> categories = ['Hotel', 'Restaurant'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Category')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Slide-in animation for destination text
            AnimatedSlide(
              offset: Offset(0, 0),
              duration: Duration(milliseconds: 500),
              child: Text(
                'Destination: ${widget.destination}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),

            // Category dropdown with fade-in animation
            AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(milliseconds: 700),
              child: DropdownButtonFormField<String>(
                value: selectedCategory,
                hint: Text('Select Category'),
                items: categories.map((category) {
                  return DropdownMenuItem(value: category, child: Text(category));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
            ),
            SizedBox(height: 30),

            // Animated button with scale effect
            AnimatedScale(
              scale: 1.0,
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedCategory != null) {
                    // Show a transition animation and navigate to the confirmation screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConfirmationScreen(
                          destination: widget.destination,
                          category: selectedCategory!,
                          option: 'Example Option', // Placeholder for actual options
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please select a category!')),
                    );
                  }
                },
                child: Text('Confirm Category'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
