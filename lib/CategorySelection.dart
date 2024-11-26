import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'confirmation.dart';

class CategorySelectionScreen extends StatefulWidget {
  final String destination;

  const CategorySelectionScreen({Key? key, required this.destination}) : super(key: key);

  @override
  _CategorySelectionScreenState createState() => _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  String? selectedCategory;
  List<dynamic> places = [];  // List to hold places (hotels or restaurants)
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedCategory = 'Hotel';  // Default category
    _fetchPlaces();
  }

  // Function to fetch places based on selected category
  Future<void> _fetchPlaces() async {
    setState(() {
      isLoading = true;
    });

    final String category = selectedCategory == 'Hotel' ? 'hotel' : 'restaurant';
    final String location = widget.destination;

    try {
      // OpenStreetMap Nominatim API URL for hotel or restaurant search
      final String osmUrl =
          'https://nominatim.openstreetmap.org/search?q=$category+$location&format=json';

      final response = await http.get(Uri.parse(osmUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          places = data;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load places')));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  double _scale = 1.0;

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
      appBar: AppBar(title: Text('Select Category')),
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
            // Slide-in animation for destination text
            AnimatedSlide(
              offset: Offset(0, 0),
              duration: Duration(milliseconds: 500),
              child: Text(
                'Destination: ${widget.destination}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),

            // Category dropdown with fade-in animation
            AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(milliseconds: 700),
              child: DropdownButtonFormField<String>(
                value: selectedCategory,
                hint: Text('Select Category', style: TextStyle(color: Colors.white)),
                items: ['Hotel', 'Restaurant'].map((category) {
                  return DropdownMenuItem(value: category, child: Text(category, style: TextStyle(color: Colors.black)));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                    _fetchPlaces(); // Fetch places based on selected category
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Show loading spinner when fetching data
            if (isLoading)
              Center(child: CircularProgressIndicator())
            else if (places.isEmpty)
              Center(child: Text("No places found. Try a different search.", style: TextStyle(color: Colors.white)))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: places.length,
                  itemBuilder: (context, index) {
                    final place = places[index];
                    // Check if 'address' exists and show a fallback if not
                    final address = place['address'] != null ? place['address'] : 'Address not available';
                    final name = place['display_name'] ?? 'No name';

                    return ListTile(
                      title: Text(name),
                      subtitle: Text(address),  // Displaying the address or fallback message
                      onTap: () {
                        // Handle the selection of a place
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConfirmationScreen(
                              destination: widget.destination,
                              category: selectedCategory!,
                              option: name,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

            // Animated button with scale effect
            GestureDetector(
              onTapDown: _onTapDown,
              onTapUp: _onTapUp,
              child: AnimatedScale(
                scale: _scale,
                duration: Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    elevation: MaterialStateProperty.all(10.0),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (places.isNotEmpty) {
                      // Show a transition animation and navigate to the confirmation screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConfirmationScreen(
                            destination: widget.destination,
                            category: selectedCategory!,
                            option: places.first['display_name'] ?? 'Example Option',
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('No places found!')),
                      );
                    }
                  },
                  child: Text('Confirm Category'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
