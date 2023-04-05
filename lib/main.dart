import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_fire/avtor.dart';
import 'package:flutter_application_fire/home.dart';
import 'package:flutter_application_fire/reg.dart';
import 'package:flutter_application_fire/update_cosmetic.dart';
import 'package:flutter_application_fire/users.dart';
import 'package:flutter_application_fire/welcome.dart';
import 'add_cosmetic.dart';
import 'firebase_options.dart';

Future <void> main() async {
WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'firebaseApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: 'home',
      routes: {
        'home': (context) => HomePage(),
        'avto': (context) => AvtoPage(),
        'reg': (context) => RegPage(),
        'welcome': (context) => WelcomePage(),
        'users': (context) => Users(),
        'cosmetic': (context) => AddCosmPage(),
        'updateCosm': (context) => UpdateCosmPage(),
        
      },
    );
  }
}