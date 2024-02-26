import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityDetailScreen extends StatelessWidget {
  final String id;

  ActivityDetailScreen({required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text(
         // 'Activity Details',
        //  style: TextStyle(color: Colors.green), // Set title text color to green
       // ),
           backgroundColor: Colors.green[500], // Set the background color of the app bar
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end, 
          children: [
            Text(
              'ActiVenture',
              style: TextStyle(
                color: Colors.white, // Set the color of the title text to white
                fontSize: 20, // Adjust the font size of the title as needed
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Image.asset(
                '../lib/images/Logoblanc.png', // Replace with your logo asset path
                width: 50, // Adjust the width of the logo as needed
              ),
            ),
            
          ],
        ),
      ),
      backgroundColor: Colors.white, // Set background color to white
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

          // Extract activity data from snapshot
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
                // Display activity image
                Container(
                  height: 200, // Set a fixed height for the image container
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Display activity details
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display structured title with green color
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
                // Add button to add to cart
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Implement add to cart functionality here
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white), // Set button background color to white
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0), // Set button border radius
                          side: BorderSide(color: Colors.green), // Set button border color to green
                        ),
                      ),
                    ),
                    child: Text(
                      'Ajouter au panier',
                      style: TextStyle(color: Colors.green), // Set button text color to green
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

