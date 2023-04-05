import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AvtoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AvtoPageState();
}

class _AvtoPageState extends State<AvtoPage> {
  GlobalKey<FormState> _key = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _loginController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool isObscure = true;
  bool _isValid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
               const   SizedBox(
                height: 100,
              ),
              const Text(
                "Авторизация",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 58,73,80)),
              ),
          const   SizedBox(
                    height: 160,
                  ),
              SizedBox(
                  width: 10,
              height: 30,
                child: TextFormField(
                  controller: _loginController,
                  ),
              ),
        const     SizedBox(
                    height: 20,
                  ),
              SizedBox(
                  width: 10,
              height: 30,
                child: TextFormField(
                  controller: _passwordController,

                ),
              ),
          const    SizedBox(
                    height: 20,
                  ),
              Container(
                  width: 10,
              height: 30,
                    child: TextButton(
                        style: ButtonStyle( 
                   backgroundColor: MaterialStateProperty.all<Color>(Colors.white,), 
                ),
                      child: const Text("Вход", style: TextStyle(fontSize: 15, color:Color.fromARGB(255,60,70,70)),),
                      onPressed: () => {
                        _isValid = true,
                        if (_key.currentState!.validate()) {avto()}
                      },
                    ),
                  
                  ),
    const SizedBox(
                    height: 20,
                  ),
              SizedBox(
                  width: 10,
              height: 30,
                    child: ElevatedButton(
                        style: ButtonStyle(
                   backgroundColor: MaterialStateProperty.all<Color>(Colors.white,),
                ),
                      child: const Text("Вход анонимно", style: TextStyle(fontSize: 15, color:Color.fromARGB(255,60,70,70)),),
                      onPressed: () => {avtorAnonim()},
                    ),
                  
                  ),
            
         const    SizedBox(
                    height: 20,
                  ),
              SizedBox(
                  width: 10,
              height: 30,
                  child: ElevatedButton(
                      style: ButtonStyle(
                   backgroundColor: MaterialStateProperty.all<Color>(Colors.white,),
                ),
                    child: const Text("Назад", style: TextStyle(fontSize: 15, color:Color.fromARGB(255,60,70,70)),),
                    onPressed: () => {
                      _loginController.clear(),
                      _passwordController.clear(),
                      _isValid = false,
                      _key.currentState!.validate(),
                      Navigator.pushNamed(context, 'home'),
                    },
                  ))
            ],
          ),
        ),
     
      ),
    );
  }
avtorAnonim() async {
    final auth = FirebaseAuth.instance;
    try {
      final userCredential = await auth.signInAnonymously();

      Navigator.pushNamed(context, 'welcome');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Не удалось авторизоваться"),
        ),
      );
    }
  }

  avto() async {
    final auth = FirebaseAuth.instance;
    try {
      UserCredential user = await auth.signInWithEmailAndPassword(
          email: _loginController.text, password: _passwordController.text);
      Navigator.pushNamed(context, 'welcome');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
        const  SnackBar(
            content: Text("Пользователь не найден"),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
      const    SnackBar(
            content: Text("Не правильный пароль"),
          ),
        );
      }
    }
  }

  
}