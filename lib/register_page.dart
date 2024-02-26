import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:tp2/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';


class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController birthdateController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  bool _obscureText = true;
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  _selectDate(context);
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: TextEditingController(
                        text: selectedDate != null
                            ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                            : ''),
                    decoration: InputDecoration(
                      labelText: 'Birthdate',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: 'Select birthdate',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: postalCodeController,
                decoration: InputDecoration(
                  labelText: 'Postal Code',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: cityController,
                decoration: InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  onPressed: register,
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    birthdateController.dispose();
    addressController.dispose();
    postalCodeController.dispose();
    cityController.dispose();
    super.dispose();
  }
 /*
  void register() async {
    try {
      String name = nameController.text;
      String email = emailController.text;
      String password = passwordController.text;
      String birthdate = DateFormat('yyyy-MM-dd').format(selectedDate!);
      String address = addressController.text;
      String postalCode = postalCodeController.text;
      String city = cityController.text;

      User? user = await _auth.signUpWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
        birthdate: birthdate,
        address: address,
        postalCode: postalCode,
        city: city,
      );
      

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User successfully created!'),
            duration: Duration(seconds: 3),
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        print("Some error happened");
      }
    } catch (e) {
      print('Registration failed: $e');
    }
  }
  */
  void register() async {
  try {
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String birthdate = DateFormat('yyyy-MM-dd').format(selectedDate!);
    String address = addressController.text;
    String postalCode = postalCodeController.text;
    String city = cityController.text;

    // Register user with email and password
    User? user = await _auth.signUpWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (user != null) {
      // Store additional user data in Firestore
      await _auth.storeUserData(
        user.uid,
        name,
        email,
        birthdate,
        address,
        postalCode,
        city,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User successfully created!'),
          duration: Duration(seconds: 3),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      print("Some error happened");
    }
  } catch (e) {
    print('Registration failed: $e');
  }
}

}



