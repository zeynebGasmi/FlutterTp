import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/*
class UserInfoScreen extends StatefulWidget {
  final String userId;

  UserInfoScreen({required this.userId});

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  late String _name = '';
  late String _email = '';
  late String _birthdate = '';
  late String _address = '';
  late String _postalCode = '';
  late String _city = '';
  late String _oldPassword = '';
  late String _newPassword = '';

  bool _isPasswordVisible = false;
  bool _isOldPasswordCorrect = false;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    try {
      // Retrieve user data from Firestore
      DocumentSnapshot userDataSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
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

  Future<bool> _updateUserData() async {
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
      return true;
    } catch (e) {
      print('Error updating user information: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update user information')));
      return false;
    }
  }

  Future<bool> _updatePassword() async {
    try {
      // Verify old password
      // Replace this logic with your authentication method
      if (_oldPassword == 'user_old_password') {
        // Update password in user collection (sample logic)
        await FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
          'password': _newPassword,
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password updated')));
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Incorrect old password')));
        return false;
      }
    } catch (e) {
      print('Error updating password: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update password')));
      return false;
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
              _buildInfoTile('Email', _email, null), // Email can't be modified
              _buildInfoTile('Birthdate', _birthdate, (value) => _birthdate = value),
              _buildInfoTile('Address', _address, (value) => _address = value),
              _buildInfoTile('Postal Code', _postalCode, (value) => _postalCode = value),
              _buildInfoTile('City', _city, (value) => _city = value),
              SizedBox(height: 20),
              ListTile(
                title: Text('Change Password', style: TextStyle(fontSize: 18)),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
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
                  onPressed: () async {
                    _isOldPasswordCorrect = await _updatePassword();
                    if (_isOldPasswordCorrect) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password updated')));
                    }
                  },
                  child: Text('Update Password'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                  ),
                ),
              ],
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  bool success = await _updateUserData();
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User information updated')));
                  }
                },
                child: Text('Save Changes'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, ValueChanged<String>? onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$title:',
              style: TextStyle(fontSize: 18),
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                if (onChanged != null) {
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
                              if (onChanged != null) {
                                onChanged(value);
                              }
                              Navigator.pop(context);
                            },
                            child: Text('Save'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
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
                obscureText: !_isPasswordVisible && title.contains('Old'), // Hide old password when not visible
                decoration: InputDecoration(hintText: 'Enter $title'),
              ),
            ),
            IconButton(
              icon: Icon(Icons.remove_red_eye),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UserInfoScreen(userId: 'user_id'),
  ));
}
*/
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'panier.dart';
import 'home_page.dart';
import 'login_page.dart';

class UserInfoScreen extends StatefulWidget {
  final String userId;
  final String userName;
  UserInfoScreen({required this.userId, required this.userName});

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  late String _name = '';
  late String _email = '';
  late String _birthdate = '';
  late String _address = '';
  late String _postalCode = '';
  late String _city = '';
  late String _oldPassword = '';
  late String _newPassword = '';

  bool _isPasswordVisible = false;
  bool _isOldPasswordCorrect = false;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    try {
      // Retrieve user data from Firestore using the provided userId
      DocumentSnapshot userDataSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
      Map<String, dynamic> userData = userDataSnapshot.data() as Map<String, dynamic>;

      // Update the state with the retrieved user data
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

  Future<bool> _updateUserData() async {
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
      return true;
    } catch (e) {
      print('Error updating user information: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update user information')));
      return false;
    }
  }

  Future<bool> _updatePassword() async {
    try {
      // Verify old password
      final currentUser = FirebaseAuth.instance.currentUser;
      final credential = EmailAuthProvider.credential(email: currentUser!.email!, password: _oldPassword);
      await currentUser.reauthenticateWithCredential(credential);

      // Update password
      await currentUser.updatePassword(_newPassword);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password updated')));
      return true;
    } on FirebaseAuthException catch (e) {
      print('Error updating password: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update password')));
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
        backgroundColor: Colors.green[500], // Set app bar background color to green[500]
        title: Row(
          
           mainAxisAlignment: MainAxisAlignment.center, // Center the logo and text
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
                color: Colors.white, // Set app bar title text color to white
                fontSize: 20, // Adjust the font size of the title as needed
              ),
            ),
          ],
        ),
          actions: [
          IconButton(
           onPressed: () {
              FirebaseAuth.instance.signOut();
              // Navigator.pushReplacementNamed(context, '/login_page'); // Navigate to login page
               Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
            },
              icon: Row(
               children: [
               Icon(Icons.logout, color: Colors.white), // Icon
               SizedBox(width: 8), // Spacer between icon and text
               Text('Déconnexion', style: TextStyle(color: Colors.white)), // Text
                ],
              ),
           
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Container(
          color: Color.fromARGB(255, 255, 255, 255), // Set background color to white
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(
                'Bienvenue $_name 😊 dans ton espace personnel!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green[900]),
              ),
              SizedBox(height: 10),
              Text(
                'Information Générales',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green[500]),
              ),
              SizedBox(height: 20),
              _buildInfoTile('Name', _name),
              _buildInfoTile('Email', _email),
              _buildInfoTile('Birthdate', _birthdate),
              _buildInfoTile('Address', _address),
              _buildInfoTile('Postal Code', _postalCode),
              _buildInfoTile('City', _city),
              SizedBox(height: 20),
              Row(
               mainAxisAlignment: MainAxisAlignment.end, // Align button to the right
               children: [
              ElevatedButton(
                onPressed: () async {
                  bool success = await _updateUserData();
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User information updated')));
                  }
                },
                child: Text('Enregister les changements'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                ),
              ),
               ],
              ),
              SizedBox(height: 20),
             Text(
                ' Mot de pass',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green[500]),
              ),
              SizedBox(height: 20),
              _buildPasswordTile('Old Password', _oldPassword, (value) => _oldPassword = value),
              _buildPasswordTile('New Password', _newPassword, (value) => _newPassword = value),
              SizedBox(height: 20),
              
               Row(
               mainAxisAlignment: MainAxisAlignment.end, // Align button to the right
               children: [
              ElevatedButton(
                
                onPressed: () async {
                  _isOldPasswordCorrect = await _updatePassword();
                  if (_isOldPasswordCorrect) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mot de pass mis à jour')));
                  }
                },
                child: Text('Modifier le mot de pass'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green[500],
                  onPrimary: Colors.white,
                ),
              ),
               ],
               ),
            ],
          ),
          
        ),
      ),
            bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomePage(userId: widget.userId, userName: widget.userName)),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.home, color: Colors.green[900]),
                  Text('Activités', style: TextStyle(color: Colors.green[900])),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Panier(userId: widget.userId, userName: widget.userName)),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_cart, color: Colors.green[900]),
                  Text('Panier', style: TextStyle(color: Colors.green[900])),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserInfoScreen(userId: widget.userId,userName: widget.userName)),
                );
              },
              child : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person, color: Colors.green[500]),
                Text('Profile', style: TextStyle(color: Colors.green[500])),
              ],
            ),
            ),
           
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$title: $value',
              style: TextStyle(fontSize: 16),
            ),
            IconButton(
              icon: Icon(Icons.edit),
              color: Colors.green[900],
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Edit $title'),
                      content: TextField(
                        onChanged: (newValue) {
                          setState(() {
                            value = newValue;
                          });
                        },
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

  Widget _buildPasswordTile(String title, String value, ValueChanged<String> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title:',
          style: TextStyle(fontSize: 16),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: onChanged,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(hintText: 'Enter $title'),
              ),
            ),
            IconButton(
              icon: Icon(Icons.remove_red_eye),
              color: Colors.green[900],
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UserInfoScreen(userId: 'user_id',userName: 'user_name'), // Pass the user ID here
  ));
}
