import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
/*
class FirebaseAuthService{
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
   try {
    UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
     return credential.user;
   }
   catch(e) {
    print("some errors occured");
   }
   return null;
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
   try {
    UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
     return credential.user;
   }
   catch(e) {
    print("some errors occured");
   }
   return null;
  }


} 
*/
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    //required String name,
    //required String birthdate,
    //required String address,
   // required String postalCode,
    //required String city,
  }) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update user profile with additional information
      //await credential.user!.updateDisplayName(name);

      // Here, you can add code to store other user information like birthday, address, etc.
      // For example, you can use Firebase Firestore to store these details associated with the user ID.

      return credential.user;
    } catch (e) {
      print("Sign up failed: $e");
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      print("Sign in failed: $e");
      return null;
    }
  }



  Future<void> storeUserData(
    String userId,
    String name,
    String email,
    String birthdate,
    String address,
    String postalCode,
    String city,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'name': name,
        'email': email,
        'birthdate': birthdate,
        'address': address,
        'postalCode': postalCode,
        'city': city,
      });
      print('User data stored successfully');
    } catch (e) {
      print('Error storing user data: $e');
    }
  }

 Future<String?> getUserId() async {
  try {
    // Get the current user from FirebaseAuth
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Return the user's ID
      return user.uid;
    } else {
      // User is not signed in
      return null;
    }
  } catch (e) {
    // Handle any errors
    print('Error getting user ID: $e');
    return null;
  }
}
}
