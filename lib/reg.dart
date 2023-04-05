import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class RegPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {
  GlobalKey<FormState> _key = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _loginController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _surname = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _middlename = TextEditingController();
  late FirebaseAuth _auth;
  late Map<String, dynamic> imageData = {};
  bool isObscure = true;
  bool _isValid = true;

  @override
  Widget build(BuildContext context) {
    _auth = FirebaseAuth.instance;

    return Scaffold(
       backgroundColor: Colors.grey,
      body: SafeArea(
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Регистрация",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30,color: Color.fromARGB(255, 47,54,51)),
              ),
              Padding(
                padding: EdgeInsets.only(left: 300, right: 300),
                child: TextFormField(
                  controller: _surname,
                  validator: (value) {
                    if (!_isValid) {
                      return null;
                    }
                    if (value!.isEmpty) {
                      return 'Поле пустое';
                    }
                    if (value.length < 3) {
                      return 'Фамилия должна содержать не менее 3 символа';
                    }
                    return null;
                  },
                  maxLength: 255,
                  decoration: const InputDecoration(
                    labelText: 'Фамилия',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              //first name
              Padding(
               padding: EdgeInsets.only(left: 300, right: 300),
                child: TextFormField(
                  controller: _name,
                  validator: (value) {
                    if (!_isValid) {
                      return null;
                    }
                    if (value!.isEmpty) {
                      return 'Поле пустое';
                    }
                    if (value.length < 3) {
                      return 'Имя должно содержать не менее 3 символа';
                    }
                    return null;
                  },
                  maxLength: 255,
                  decoration: const InputDecoration(
                    labelText: 'Имя',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              //middle name
              Padding(
             padding: EdgeInsets.only(left: 300, right: 300),
                child: TextFormField(
                  controller: _middlename,
                  validator: (value) {
                    if (!_isValid) {
                      return null;
                    }
                    if (value!.isEmpty) {
                      return 'Поле пустое';
                    }
                    if (value.length < 3) {
                      return 'Отчество должно содержать не менее 3 символа';
                    }
                    return null;
                  },
                  maxLength: 255,
                  decoration: const InputDecoration(
                    labelText: 'Отчество',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                  width: 10,
              height: 30,
                child: TextFormField(
                  controller: _loginController,
                ),
              ),
             const       SizedBox(
                    height: 20,
                  ),
              SizedBox(
                  width: 200,
              height: 30,
                child: TextFormField(
                  controller: _passwordController,
                 
                ),
              ),
              const     SizedBox(
                    height: 20,
                  ),
                   
              SizedBox(
                   width: 10,
              height: 30,
                    child: ElevatedButton(
                         style: ButtonStyle(
                         backgroundColor: MaterialStateProperty.all<Color>(Colors.white,), ),
                      child: Text("Загрузить фото профиля", style: TextStyle(fontSize: 15, color:Color.fromARGB(255,60,70,70)),),
                      onPressed: () => {_pickFile()},
                    ),
                   
                  ),
                   SizedBox(height: 10,),
              SizedBox(
                  width: 10,
              height: 30,
                    child: ElevatedButton(
                      
                             style: ButtonStyle(
                   backgroundColor: MaterialStateProperty.all<Color>(Colors.white,),
                ),
                      child: const Text("Зарегистрироваться", style: TextStyle(fontSize: 15, color:Color.fromARGB(255,60,70,70)),),
                      onPressed: () => {
                        _isValid = true,
                        if (_key.currentState!.validate()) {reg()}
                      },
                    ),
                  
                  ),
               const   SizedBox(
                    height: 20,
                  ),
              SizedBox(
                  width: 200,
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

  reg() async {
    try {
      UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: _loginController.text, password: _passwordController.text);
          addUserDetails(FirebaseAuth.instance.currentUser!.uid);
      ScaffoldMessenger.of(context).showSnackBar(
    const    SnackBar(
          content: Text("Зарегистрировался"),
        ),
      );
      Navigator.pushNamed(context, 'home');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
       const   SnackBar(
            content: Text("Пароль слабый"),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }
   Future addUserDetails(String id) async {
    await FirebaseFirestore.instance.collection('users').doc(id).set({
      'surname': _surname.text.trim(),
      'name': _name.text.trim(),
      'middlename': _middlename.text.trim(),
      'email': _loginController.text.trim(),
      'images': imageData
    });
  }
   void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;
      await FirebaseStorage.instance
          .ref('uploads/${file.name}')
          .putData(file.bytes!);

      imageData = {
        "size": file.size,
        "file_extensions": file.extension!,
        "name": file.name,
        'storage_path': 'uploads/${file.name}'
      };
    } else {
    }
  }
}