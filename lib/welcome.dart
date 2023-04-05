import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
   final user = FirebaseAuth.instance.currentUser!;
   late final userData;
  late final imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.grey,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [
          Text("Приветики, вы зашли", 
          style: TextStyle(fontSize: 15, color:Color.fromARGB(255,60,70,70)),
          ),
            SizedBox(height: 20,),
            SizedBox(
             
              width: 200,
              height: 50,
      child:   ElevatedButton(
                   style: ButtonStyle(
                         backgroundColor: MaterialStateProperty.all<Color>(Colors.white,), ),
              onPressed: () {
                Navigator.pushNamed(context, 'users');
              },
              child: const Text("Профиль", style: TextStyle(fontSize: 15, color:Color.fromARGB(255,60,70,70)),)
              )
            )
          ,
                SizedBox(height: 20,),
                 SizedBox(
             
              width: 200,
              height: 50,
      child: 
               ElevatedButton(
                 style: ButtonStyle(
                         backgroundColor: MaterialStateProperty.all<Color>(Colors.white,), ),
              onPressed: () {
                Navigator.pushNamed(context, 'cosmetic');
              },
              child: const Text("Косметика", style: TextStyle(fontSize: 15, color:Color.fromARGB(255,60,70,70)),)
                 )),
      const    SizedBox(
            height: 15,
          ),
             SizedBox(
             
              width: 200,
              height: 50,
      child: 
               ElevatedButton(
                 style: ButtonStyle(
                         backgroundColor: MaterialStateProperty.all<Color>(Colors.white,), ),
              onPressed: () {
                Navigator.pushNamed(context, 'home');
              },
              child: const Text("Назад", style: TextStyle(fontSize: 15, color:Color.fromARGB(255,60,70,70)),)
                 )),
               FutureBuilder<String>(
            future: loadImage(),
            builder: (BuildContext context, AsyncSnapshot<String> image) {
              if (image.hasData) {
                return Container(
                    width: 200,
                    child: Image.network(
                      image.data.toString(),
                      fit: BoxFit.scaleDown,
                    ));
              } else {
                return new Container(); // placeholder
              }
            },
          ),
          ],
        
      )
      ),
    );
  }
  
  Future<String> loadImage() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    var filePath = documentSnapshot['images']['storage_path'];

    Reference ref = FirebaseStorage.instance.ref().child(filePath);

    var url = await ref.getDownloadURL();
    print('url: ' + url);
    return url;
  }
}