import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'home_page.dart';
import 'register_page.dart';
import 'package:tp2/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:provider/provider.dart';
import 'provider/UserIdProvider.dart';

/*
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true; // Added boolean variable to control password visibility
  String _errorMessage = ''; // Added variable to hold authentication error message
  String useruid ='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('ActiVenture'),
          backgroundColor: Colors.green[500], // Set the background color of the app bar
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Image.asset(
                '../lib/images/Logoblanc.png', // Replace with your logo asset path
                width: 50, // Adjust the width of the logo as needed
              ),
            ),
            Text(
              'ActiVenture',
              style: TextStyle(
                color: Colors.white, // Set the color of the title text to white
                fontSize: 20, // Adjust the font size of the title as needed
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              '../lib/images/LogoActiVenture.png', // Replace with your logo file path
              width: 150, // Adjust the width as needed
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
              obscureText: _obscureText, // Use boolean variable to control password visibility
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off, // Toggle icon based on _obscureText value
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    // Toggle the value of _obscureText when the eye icon is pressed
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Visibility(
              visible: _errorMessage.isNotEmpty, // Show error message only if it is not empty
              child: Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                ),
                onPressed: () async {
                  try {
                    // Reset error message when attempting login
                    setState(() {
                      _errorMessage = '';
                    });


                    // Simulated authentication for demonstration
                    await Future.delayed(Duration(seconds: 2));
                    // Get user ID and update the provider
                  
                    // String? userId = Provider.of<UserIdProvider>(context, listen: false).userId;
                     
                    // Navigate to the welcome page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WelcomePage(userId:useruid),),
                    );
                  } catch (e) {
                    // Handle authentication errors
                    setState(() {
                      _errorMessage = 'Authentication failed: $e'; // Set error message to display on the screen
                    });
                    print('Authentication failed: $e');
                  }
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Navigate to the registration page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationPage()),
                );
              },
              child: Text('Don\'t have an account? Register here'),
            ),
          ],
        ),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:tp2/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:provider/provider.dart';
import 'provider/UserIdProvider.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  String _errorMessage = '';
  String userUid = '';

  Future<void> signIn() async {
    String email = emailController.text;
    String password = passwordController.text;
    try {
      User? user = await FirebaseAuthService().signInWithEmailAndPassword(email, password);
      if (user != null) {
        setState(() {
          userUid = user.uid;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WelcomePage(userId: userUid)),
        );
      } else {
        setState(() {
          _errorMessage = 'Authentication failed: User not found';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Authentication failed: $e';
      });
      print('Authentication failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[500],
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Image.asset(
                '../lib/images/Logoblanc.png',
                width: 50,
              ),
            ),
            Text(
              'ActiVenture',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              '../lib/images/LogoActiVenture.png',
              width: 150,
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
            Visibility(
              visible: _errorMessage.isNotEmpty,
              child: Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                ),
                onPressed: signIn,
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationPage()),
                );
              },
              child: Text('Don\'t have an account? Register here'),
            ),
          ],
        ),
      ),
    );
  }
}

