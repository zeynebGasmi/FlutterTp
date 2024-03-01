import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Panier extends StatefulWidget {
  final String userId;
  final String userName;

  Panier({required this.userId, required this.userName});

  @override
  _PanierState createState() => _PanierState();
}

class _PanierState extends State<Panier> {
  List<String> activityIds = [];

  @override
  void initState() {
    super.initState();
    getActivities();
  }

  Future<void> getActivities() async {
    try {
      // Reference to the "Panier" collection
      var panierRef = FirebaseFirestore.instance.collection('Panier');

      // Query documents where userId matches
      var querySnapshot = await panierRef.where('userId', isEqualTo: widget.userId).get();

      // Extract activity IDs
      List<String> ids = [];
      querySnapshot.docs.forEach((doc) {
        ids.add(doc['activityId']);
      });

      setState(() {
        activityIds = ids;
      });
    } catch (e) {
      print('Error retrieving activities: $e');
    }
  }

  Future<void> removeFromPanier(String activityId) async {
    try {
      // Reference to the "Panier" collection
      var panierRef = FirebaseFirestore.instance.collection('Panier');

      // Query the document to delete
      var querySnapshot = await panierRef.where('userId', isEqualTo: widget.userId).where('activityId', isEqualTo: activityId).get();

      // Delete the document
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });

      // Refresh the list of activities
      getActivities();
    } catch (e) {
      print('Error removing from Panier: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[500], // Set app bar background color to green[500]
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
                color: Colors.white, // Set app bar title text color to white
                fontSize: 20, // Adjust the font size of the title as needed
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white, // Set background color to white
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Bonjour ${widget.userName}, Vous êtes dans votre panier',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: activityIds.length,
              itemBuilder: (BuildContext context, int index) {
                return FutureBuilder(
                  future: FirebaseFirestore.instance.collection('Activites').doc(activityIds[index]).get(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return Text('Activity not found');
                    }

                    var data = snapshot.data!;
                    var titre = data['titre'];
                    var lieu = data['lieu'];
                    var prix = data['prix'];
                    var nombreParticipantsMin = data['nombreParticipantsMin'];
                    var categorie = data['categorie'];

                    return Card(
                      margin: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // Add rounded edges
                      ),
                      child: ListTile(
                        title: Text(
                          titre,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[500], // Set title text color to green[500]
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Lieu: $lieu'),
                            Text('Prix: $prix €'),
                            Text('Nombre de participants minimum: $nombreParticipantsMin'),
                            Text('Catégorie: $categorie'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red), // Set delete icon color to red
                          onPressed: () {
                            removeFromPanier(activityIds[index]);
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
