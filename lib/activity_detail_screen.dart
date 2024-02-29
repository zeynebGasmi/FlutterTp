import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:provider/provider.dart';
import 'provider/UserIdProvider.dart';


class ActivityDetailScreen extends StatelessWidget {
  final String id;
  final FirebaseAuthService _auth = FirebaseAuthService();
  ActivityDetailScreen({required this.id});

Future<void> addToPanier(String? userId, String activityId) async {
  try {
    // Reference to the "Cart" collection
    var panierRef = FirebaseFirestore.instance.collection('Panier');

    // Add a new document to the "Cart" collection
    await panierRef.add({
      'userId': userId,
      'activityId': activityId,
    });
  } catch (e) {
    print('Error adding to Panier: $e');
  }
}




  @override
  Widget build(BuildContext context) {
      String? userId = Provider.of<UserIdProvider>(context).userId;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[500],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'ActiVenture',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Image.asset(
                '../lib/images/Logoblanc.png',
                width: 50,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('Activites').doc(id).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Activity not found'));
          }

          var data = snapshot.data!;
          var titre = data['titre'];
          var image = data['image'];
          var lieu = data['lieu'];
          var prix = data['prix'];
          var nombreParticipantsMin = data['nombreParticipantsMin'];
          var categorie = data['categorie'];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titre,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      SizedBox(height: 10),
                      Text('Lieu: $lieu', style: TextStyle(fontSize: 18)),
                      Text('Prix: $prix €', style: TextStyle(fontSize: 18)),
                      Text('Nombre de participants minimum: $nombreParticipantsMin', style: TextStyle(fontSize: 18)),
                      Text('Catégorie: $categorie', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      // Get the current user's ID
                      print('getting user id');
                      print(id);
                      String? userId = await _auth.getUserId();
                      print(userId);
                      
                      // Add the activity to the user's cart
                      addToPanier(userId,id);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.green),
                        ),
                      ),
                    ),
                    child: Text(
                      'Ajouter au panier',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

