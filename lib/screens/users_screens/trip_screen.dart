import 'package:flutter/material.dart';

class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Trips'),
          backgroundColor: const Color(0xFF0478E4), // Custom app color
          bottom: const TabBar(
            tabs: [
              Tab(text: 'New Trip'),
              Tab(text: 'Active Trips'),
              Tab(text: 'Completed Trips'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            NewTripForm(),
            ActiveTrips(),
            CompletedTrips(),
          ],
        ),
      ),
    );
  }
}

class NewTripForm extends StatefulWidget {
  const NewTripForm({super.key});

  @override
  _NewTripFormState createState() => _NewTripFormState();
}

class _NewTripFormState extends State<NewTripForm> {
  final _formKey = GlobalKey<FormState>();
  String? _tripName;
  DateTimeRange? _tripDates;
  String? _destination;
  double? _budget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            _buildTextField('Trip Name', onSaved: (value) => _tripName = value),
            const SizedBox(height: 16),
            _buildDateRangeField(),
            const SizedBox(height: 16),
            _buildTextField('Destination', onSaved: (value) => _destination = value),
            const SizedBox(height: 16),
            _buildBudgetField(),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0478E4),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Trip Created!')),
                    );
                  }
                },
                child: const Text('Create Trip', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {required Function(String?) onSaved}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: const Color.fromARGB(255, 245, 245, 245),
      ),
      validator: (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
      onSaved: onSaved,
    );
  }

  Widget _buildDateRangeField() {
    return GestureDetector(
      onTap: () async {
        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) {
          setState(() {
            _tripDates = picked;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 245, 245, 245),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        child: Text(
          _tripDates == null ? 'Select Trip Dates' : '${_tripDates!.start} - ${_tripDates!.end}',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildBudgetField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Budget',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: const Color.fromARGB(255, 245, 245, 245),
      ),
      keyboardType: TextInputType.number,
      validator: (value) => value == null || double.tryParse(value) == null ? 'Please enter a valid budget' : null,
      onSaved: (value) => _budget = double.tryParse(value!),
    );
  }
}

class ActiveTrips extends StatelessWidget {
  const ActiveTrips({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5, // Replace with actual trip data count
      itemBuilder: (context, country) {
        return ListTile(
          title: Text('Trip to  ${country}'),
          subtitle: Text('Ongoing'),
          trailing: IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              // Navigate to trip details page
            },
          ),
        );
      },
    );
  }
}

class CompletedTrips extends StatelessWidget {
  const CompletedTrips({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3, // Replace with actual trip data count
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Completed Trip ${index + 1}'),
          subtitle: Text('Completed'),
          trailing: IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              // Navigate to trip details page
            },
          ),
        );
      },
    );
  }
}
