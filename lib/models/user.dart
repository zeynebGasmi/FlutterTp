import 'package:flutter/material.dart';

class AppUser {
  final String uid;
  final String email;
  final String name;
  final DateTime birthdate;
  final String address;
  final String postalCode;
  final String city;

  // Constructor with named parameters
  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.birthdate,
    required this.address,
    required this.postalCode,
    required this.city,
  });

  // Method to convert User object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'birthdate': birthdate,
      'address': address,
      'postalCode': postalCode,
      'city': city,
    };
  }
}
