import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfoScreen extends StatefulWidget {
  final String userId;

  UserInfoScreen({required this.userId});

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  late String _name = '';
  late String _email='';
  late String _birthdate='';
  late String _address='';
  late String _postalCode='';
  late String _city='';
  late String _oldPassword='';
  late String _newPassword='';

  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    try {
      // Retrieve user data from Firestore
      DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
      Map<String, dynamic> userData = userDataSnapshot.data() as Map<String, dynamic>;

      setState(() {
        _name = userData['name'];
        _email = userData['email'];
        _birthdate = userData['birthdate'];
        _address = userData['address'];
        _postalCode = userData['postalCode'];
        _city = userData['city'];
      });
    } catch (e) {
      print('Error getting user data: $e');
    }
  }

  Future<void> _updateUserData() async {
    try {
      // Update user data in Firestore
      await FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
        'name': _name,
        'birthdate': _birthdate,
        'address': _address,
        'postalCode': _postalCode,
        'city': _city,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User information updated')));
    } catch (e) {
      print('Error updating user information: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update user information')));
    }
  }

  Future<void> _updatePassword() async {
    try {
      // Verify old password
      // Replace this logic with your authentication method
      if (_oldPassword == 'user_old_password') {
        // Update password in user collection (sample logic)
        await FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
          'password': _newPassword,
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password updated')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Incorrect old password')));
      }
    } catch (e) {
      print('Error updating password: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update password')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Information'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoTile('Name', _name, (value) => _name = value),
              _buildInfoTile('Email', _email, (value) => _email = value),
              _buildInfoTile('Birthdate', _birthdate, (value) => _birthdate = value),
              _buildInfoTile('Address', _address, (value) => _address = value),
              _buildInfoTile('Postal Code', _postalCode, (value) => _postalCode = value),
              _buildInfoTile('City', _city, (value) => _city = value),
              SizedBox(height: 20),
              ListTile(
                title: Text('Change Password', style: TextStyle(fontSize: 18)),
                trailing: IconButton(
                  icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              if (_isPasswordVisible) ...[
                _buildPasswordTile('Old Password', _oldPassword, (value) => _oldPassword = value),
                _buildPasswordTile('New Password', _newPassword, (value) => _newPassword = value),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updatePassword,
                  child: Text('Update Password'),
                ),
              ],
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateUserData,
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, ValueChanged<String> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title: $value',
          style: TextStyle(fontSize: 18),
        ),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Edit $title'),
                  content: TextField(
                    onChanged: onChanged,
                    decoration: InputDecoration(hintText: 'Enter new $title'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _updateUserData();
                        Navigator.pop(context);
                      },
                      child: Text('Save'),
                    ),
                  ],
                );
              },
            );
          },
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildPasswordTile(String title, String value, ValueChanged<String> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title:',
          style: TextStyle(fontSize: 18),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: onChanged,
                obscureText: true,
                decoration: InputDecoration(hintText: 'Enter $title'),
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Edit $title'),
                      content: TextField(
                        onChanged: onChanged,
                        obscureText: true,
                        decoration: InputDecoration(hintText: 'Enter new $title'),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _updatePassword();
                            Navigator.pop(context);
                          },
                          child: Text('Save'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
