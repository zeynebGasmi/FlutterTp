import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'activity_detail_screen.dart'; 
import 'panier.dart';
class WelcomePage extends StatelessWidget {
  final String userId;
  final String userName;
  WelcomePage({required this.userId, required this.userName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text('Activités'),
            backgroundColor: Colors.green[500], // Set the background color of the app bar
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end, 
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
      backgroundColor: Colors.white, // Set background color to white
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Activites').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(), // Center the loading indicator while fetching data
            );
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Text('No documents found');
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              // Extract data from each document
              var doc = snapshot.data!.docs[index];
              var id = doc.id;
              var image = doc['image'];
              var titre = doc['titre'];
              var lieu = doc['lieu'];
              var prix = doc['prix'];

              // Build a rounded card for each activity
              return GestureDetector(
                onTap: () {
                  // Navigate to detail screen when activity is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ActivityDetailScreen(id: id,userId:userId ),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Add rounded edges
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: SizedBox(
                          width: 100, // Set a fixed width for the image container
                          height: 100, // Set a fixed height for the image container
                          child: image != null ? Image.network(image, fit: BoxFit.cover) : Placeholder(), // Display image or placeholder
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                titre,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green, // Set title text color to green
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Lieu: $lieu',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Prix: $prix €',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.home, color: Colors.green[900]), // Change icon color to darker green
                Text('Activité', style: TextStyle(color: Colors.green[900])), // Add label with darker green color
              ],
            ),
            GestureDetector(
  onTap: () async {
    // Navigate to Panier screen and pass userId as parameter
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Panier(userId: userId,userName:userName)),
    );
  },
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.shopping_cart, color: Colors.green[900]), // Change icon color to darker green
      Text('Panier', style: TextStyle(color: Colors.green[900])), // Add label with darker green color
    ],
  ),
),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person, color: Colors.green[900]), // Change icon color to darker green
                Text('Profile', style: TextStyle(color: Colors.green[900])), // Add label with darker green color
              ],
            ),
          ],
        ),
      ),
    );
  }
}
