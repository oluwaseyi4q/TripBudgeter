import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';


class UserProfileEditPage extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const UserProfileEditPage({super.key, this.userData});

  @override
  _UserProfileEditPageState createState() => _UserProfileEditPageState();
}

class _UserProfileEditPageState extends State<UserProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  String fullname = "";
  String username = "";
  String email = "";
  String address = "";
  String age = "";
  String gender = "Male";
  String preferredCurrency = "USD";
  String travelPreferences = "";
  String? profileImageUrl;

  File? _profileImage;

  @override
  void initState() {
    super.initState();
    if (widget.userData != null) {
      fullname = widget.userData!['fullname'] ?? '';
      username = widget.userData!['username'] ?? '';
      email = widget.userData!['email'] ?? '';
      address = widget.userData!['address'] ?? '';
      age = widget.userData!['age'] ?? '';
      gender = widget.userData!['gender'] ?? 'Male';
      preferredCurrency = widget.userData!['preferredCurrency'] ?? 'USD';
      travelPreferences = widget.userData!['travelPreferences'] ?? '';
      profileImageUrl = widget.userData!['profileImage'] ?? null;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadProfileImage() async {
    if (_profileImage == null) return;

    try {
      final userId = _auth.currentUser!.uid;
      final storageRef = _storage.ref().child('profile_pictures/$userId.jpg');
      await storageRef.putFile(_profileImage!);

      final downloadUrl = await storageRef.getDownloadURL();

      await _firestore.collection('users').doc(userId).update({
        'profileImage': downloadUrl,
      });

      setState(() {
        profileImageUrl = downloadUrl;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile picture updated!')),
      );
    } catch (e) {
      print('Error uploading profile image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload profile picture')),
      );
    }
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var userId = _auth.currentUser!.uid;
      await _firestore.collection('users').doc(userId).update({
        'fullname': fullname,
        'username': username,
        'address': address,
        'age': age,
        'gender': gender,
        'preferredCurrency': preferredCurrency,
        'travelPreferences': travelPreferences,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
    }
  }

  // Function to get current location
  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return; // Permission denied, handle it gracefully
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      String currentAddress =
          '${place.locality}, ${place.administrativeArea}, ${place.country}';

      setState(() {
        address = currentAddress;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: profileImageUrl != null
                        ? NetworkImage(profileImageUrl!)
                        : (_profileImage != null
                        ? FileImage(_profileImage!)
                        : AssetImage('assets/default_profile.png')) as ImageProvider,
                    child: Icon(Icons.camera_alt, size: 30, color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _uploadProfileImage,
                  child: Text('Upload Profile Picture'),
                ),
                TextFormField(
                  initialValue: fullname,
                  decoration: InputDecoration(labelText: 'Full Name'),
                  onSaved: (value) {
                    fullname = value!;
                  },
                ),
                TextFormField(
                  initialValue: username,
                  decoration: InputDecoration(labelText: 'Username'),
                  onSaved: (value) {
                    username = value!;
                  },
                ),
                TextFormField(
                  initialValue: email,
                  readOnly: true,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextFormField(
                  initialValue: address,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.location_on),
                      onPressed: _getCurrentLocation, // Call location function
                    ),
                  ),
                  onSaved: (value) {
                    address = value!;
                  },
                ),
                TextFormField(
                  initialValue: age,
                  decoration: InputDecoration(labelText: 'Age'),
                  onSaved: (value) {
                    age = value!;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: gender,
                  items: ['Male', 'Female', 'Other']
                      .map((label) => DropdownMenuItem(
                    child: Text(label),
                    value: label,
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      gender = value!;
                    });
                  },
                ),
                DropdownButtonFormField<String>(
                  value: preferredCurrency,
                  items: ['USD', 'EUR', 'GBP', 'NGN', 'JPY']
                      .map((label) => DropdownMenuItem(
                    child: Text(label),
                    value: label,
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      preferredCurrency = value!;
                    });
                  },
                ),
                TextFormField(
                  initialValue: travelPreferences,
                  decoration: InputDecoration(labelText: 'Travel Preferences'),
                  onSaved: (value) {
                    travelPreferences = value!;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveChanges,
                  child: Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
