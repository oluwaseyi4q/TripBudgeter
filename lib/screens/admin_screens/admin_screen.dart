import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Trip {
  final String destination;
  final String itinerary;
  final String? currency;
  final String? exchangeRate;
  final String? imageUrl;

  Trip({
    required this.destination,
    required this.itinerary,
    this.currency,
    this.exchangeRate,
    this.imageUrl,
  });
}

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  void _showTripForm() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const TripForm();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Page',
          style: TextStyle(color: Colors.white),
        ),
        toolbarHeight: 90,
        backgroundColor: const Color.fromARGB(255, 4, 120, 228),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add trips',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _showTripForm,
                child: Container(
                  width: double.infinity,
                  height: 130,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 209, 209, 209),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.add,
                      size: 48,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TripForm extends StatefulWidget {
  const TripForm({super.key});

  @override
  _TripFormState createState() => _TripFormState();
}

class _TripFormState extends State<TripForm> {
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _itineraryController = TextEditingController();
  String? _selectedCurrency;
  String? _selectedExchangeRate;
  XFile? _image;
  String? _imageUrl;
  final ImagePicker _picker = ImagePicker();
  final String hereApiKey = "YOUR_HERE_API_KEY"; // Replace with your HERE API key
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }

  Future<void> _uploadImageToFirebase() async {
    if (_image == null) return;

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('trip_images/${_image!.name}');
      final uploadTask = storageRef.putFile(File(_image!.path));
      final taskSnapshot = await uploadTask;
      final downloadUrl = await taskSnapshot.ref.getDownloadURL();

      setState(() {
        _imageUrl = downloadUrl;
      });
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error uploading image')),
      );
    }
  }

  Future<List<String>> _getSuggestions(String query) async {
    final response = await http.get(
      Uri.parse('https://geocode.search.hereapi.com/v1/geocode?q=$query&apiKey=$hereApiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List items = data['items'];
      return items.map((item) => item['address']['label'].toString()).toList();
    } else {
      return [];
    }
  }

  void _fetchPlaceDetails(String destination) async {
    final response = await http.get(
      Uri.parse('https://geocode.search.hereapi.com/v1/geocode?q=$destination&apiKey=$hereApiKey'),
    );

    if (response.statusCode == 200) {
      final placeData = json.decode(response.body);
      final items = placeData['items'] as List;

      if (items.isNotEmpty) {
        final place = items[0];
        setState(() {
          _imageUrl = place['address']['label']; // Example, replace with actual image URL
          String countryCode = place['address']['countryCode'];
          _fetchCurrencyAndExchangeRate(countryCode);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No place found')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching place details')),
      );
    }
  }

  Future<void> _fetchCurrencyAndExchangeRate(String countryCode) async {
    final response = await http.get(
      Uri.parse('https://v6.exchangerate-api.com/v6/9b3da8dd9643be9434944d75/latest/USD'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['conversion_rates'].containsKey(countryCode)) {
        setState(() {
          _selectedCurrency = countryCode;
          _selectedExchangeRate = data['conversion_rates'][countryCode].toString();
        });
      } else {
        setState(() {
          _selectedCurrency = 'Unknown';
          _selectedExchangeRate = 'Unknown';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Currency not available for this country')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching currency data')),
      );
    }
  }

  Future<void> _submitForm() async {
    if (_destinationController.text.isEmpty || _itineraryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _uploadImageToFirebase();

      await FirebaseFirestore.instance.collection('trips').add({
        'destination': _destinationController.text,
        'itinerary': _itineraryController.text,
        'currency': _selectedCurrency,
        'exchangeRate': _selectedExchangeRate,
        'imageUrl': _imageUrl,
        'createdAt': Timestamp.now(),
      });

      _destinationController.clear();
      _itineraryController.clear();
      _selectedCurrency = null;
      _selectedExchangeRate = null;
      _image = null;

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving trip: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TypeAheadField<String>(
            controller: _destinationController,
            suggestionsCallback: (pattern) async {
              return await _getSuggestions(pattern);
            },
            itemBuilder: (context, String suggestion) {
              return ListTile(
                title: Text(suggestion),
              );
            },
            onSelected: (String suggestion) {
              _destinationController.text = suggestion;
              _fetchPlaceDetails(suggestion);
            },
          ),
          const SizedBox(height: 10),
          _buildTextField(_itineraryController, 'Itinerary Details', maxLines: 4),
          const SizedBox(height: 10),
          if (_imageUrl != null) Image.network(_imageUrl!),
          if (_imageUrl != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fetched image selected')),
                    );
                  },
                  child: const Text('Choose this image'),
                ),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Upload your image'),
                ),
              ],
            ),
          const SizedBox(height: 10),
          Text("Currency: ${_selectedCurrency ?? 'N/A'}"),
          Text("Exchange Rate: ${_selectedExchangeRate ?? 'N/A'}"),
          const SizedBox(height: 10),
          if (_isLoading)
            const CircularProgressIndicator()
          else
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Save Trip'),
            ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
    );
  }
}
