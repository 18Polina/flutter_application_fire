import 'package:flutter/material.dart';
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.grey,
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: 200,
              height: 30,
              child: ElevatedButton(
                 style: ButtonStyle(
                   backgroundColor: MaterialStateProperty.all<Color>(Colors.white,),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'reg');
                },
                child: const Text("Зарегистрироваться", style: TextStyle(fontSize: 15, color:Color.fromARGB(255,60,70,70)),),
              )),
    const      SizedBox(
            height: 5,
          ),
          SizedBox(
              width: 200,
              height: 30,
              child: ElevatedButton( 
                style: ButtonStyle(
                   backgroundColor: MaterialStateProperty.all<Color>(Colors.white,),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'avto');
                },
                child: const Text("Авторизироваться", style: TextStyle(fontSize: 15, color:Color.fromARGB(255,60,70,70)),),
              )),
      const    SizedBox(
            height: 15,
          )
        ],
      )),
    );
  }
}