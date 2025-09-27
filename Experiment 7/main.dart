import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Registration Form (Migrated)',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RegistrationForm(),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  // controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  // dropdown & radio state
  String? _selectedCountry;
  String? _selectedCity;
  String? _gender;

  final Map<String, List<String>> countryCityMap = {
    'India': ['Mumbai', 'Delhi', 'Bangalore'],
    'USA': ['New York', 'Los Angeles', 'Chicago'],
    'UK': ['London', 'Manchester', 'Birmingham'],
  };

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registration Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Create Account",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                  (value == null || value.trim().isEmpty)
                      ? 'Please enter your name'
                      : null,
                ),
                const SizedBox(height: 12),

                // Email
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Password
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Confirm Password
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                // Country dropdown
                DropdownButtonFormField<String>(
                  initialValue: _selectedCountry,
                  decoration: InputDecoration(
                    labelText: 'Country',
                    hintText: 'Select your country',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.public, color: Colors.blue),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  items: countryCityMap.keys
                      .map((country) => DropdownMenuItem<String>(
                    value: country,
                    child: Text(country, style: const TextStyle(fontSize: 16)),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCountry = value;
                      _selectedCity = null;
                    });
                  },
                  validator: (value) =>
                  value == null ? 'Please select a country' : null,
                ),

                const SizedBox(height: 16),

                // City dropdown
                DropdownButtonFormField<String>(
                  initialValue: _selectedCity,
                  decoration: InputDecoration(
                    labelText: 'City',
                    hintText: 'Select your city',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.location_city, color: Colors.blue),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  items: _selectedCountry == null
                      ? []
                      : countryCityMap[_selectedCountry!]!
                      .map((city) => DropdownMenuItem<String>(
                    value: city,
                    child: Text(city, style: const TextStyle(fontSize: 16)),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCity = value;
                    });
                  },
                  validator: (value) =>
                  value == null ? 'Please select a city' : null,
                ),

                // Gender using RadioGroup (new API)
                const Text('Gender', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 6),
                RadioGroup<String>(
                  // RadioGroup manages the selected value and onChanged
                  groupValue: _gender,
                  onChanged: (String? value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                  child: Column(
                    children: [
                      RadioListTile<String>(
                        value: 'Male',
                        title: const Text('Male'),
                        // Optional: visually mark tile as selected
                        selected: _gender == 'Male',
                      ),
                      RadioListTile<String>(
                        value: 'Female',
                        title: const Text('Female'),
                        selected: _gender == 'Female',
                      ),
                      RadioListTile<String>(
                        value: 'Other',
                        title: const Text('Other'),
                        selected: _gender == 'Other',
                      ),
                    ],
                  ),
                ),
                if (_gender == null)
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, top: 6),
                    child: Text('Please select a gender',
                        style: TextStyle(color: Colors.red, fontSize: 12)),
                  ),

                const SizedBox(height: 22),

                // Submit button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      final valid = _formKey.currentState?.validate() ?? false;
                      if (valid && _gender != null) {
                        // All good
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Registered: ${_nameController.text} ($_gender) from ${_selectedCity ?? '-'}, ${_selectedCountry ?? '-'}',
                            ),
                          ),
                        );
                      } else {
                        // show validation errors (gender checked above)
                        if (_gender == null) {
                          // force rebuild to show the gender error text
                          setState(() {});
                        }
                      }
                    },
                    child: const Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 22.0, vertical: 12),
                      child: Text('Register', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}