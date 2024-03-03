import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'activity_detail_screen.dart'; 
import 'panier.dart';
import 'Activities_by_category.dart';
import 'user_info_screen.dart';

class WelcomePage extends StatelessWidget {
  final String userId;
  final String userName;

  WelcomePage({required this.userId, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[500], // Set the app bar background color to green[500]
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              '../lib/images/Logoblanc.png',
              width: 50,
            ),
            Text(
              'ActiVenture',
              style: TextStyle(
                color: Colors.white, // Set the color of the title text to white
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white), // Set icon color to white
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Panier(userId: userId, userName: userName)),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: Container(
            height: 40.0,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('Activites').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                  return Center(child: Text('Error fetching categories'));
                }

                var categories = <String>{};
                snapshot.data!.docs.forEach((doc) {
                  var category = doc['categorie'];
                  if (category != null && category is String && category.isNotEmpty) {
                    categories.add(category);
                  }
                });

                return ListView(
                  scrollDirection: Axis.horizontal,
                  children: categories.map((category) {
                    return _buildCategoryButton(context, category, userId, userName);
                  }).toList(),
                );
              },
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.white, // Set the background color of the body to white
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Coucou $userName 😊, votre nouvelle aventure vous attend!',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900],
                ),
              ),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('Activites').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return Text('No activities found');
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      var doc = snapshot.data!.docs[index];
                      var id = doc.id;
                      var image = doc['image'];
                      var titre = doc['titre'];
                      var lieu = doc['lieu'];
                      var prix = doc['prix'];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ActivityDetailScreen(id: id, userId: userId),
                            ),
                          );
                        },
                        child: Card(
                          margin: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: image != null ? Image.network(image, fit: BoxFit.cover) : Placeholder(),
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
                                          color: Colors.green,
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
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.home, color: Colors.green[500]),
                Text('Activités', style: TextStyle(color: Colors.green[500], fontWeight: FontWeight.bold)), // Bold text to indicate selected section
              ],
            ),
            GestureDetector(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Panier(userId: userId, userName: userName)),
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
                  MaterialPageRoute(builder: (context) => UserInfoScreen(userId: userId, userName: userName)),
                );
              },
          
              child :Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person, color: Colors.green[900]),
                Text('Profile', style: TextStyle(color: Colors.green[900])),
              ],
            ),
            ),
      
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(BuildContext context, String category, String userId, String userName) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ActivitiesByCategory(userId: userId, userName: userName, category: category)),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.center,
        margin: EdgeInsets.only(right: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
        ),
        child: Text(
          category,
          style: TextStyle(
            color: Colors.green[900],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
