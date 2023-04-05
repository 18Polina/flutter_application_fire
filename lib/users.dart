import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Users extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  GlobalKey<FormState> _key = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
   TextEditingController _surname = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _middlename = TextEditingController();
  late Map<String, dynamic> imageData = {};
  bool isObscure = true;
  bool _isValid = true;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    String id = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
        backgroundColor: Colors.grey,
        body: Column(
      // ignore: sort_child_properties_last
      children: [
        FutureBuilder<DocumentSnapshot>(
          future: users.doc(id).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Что-то пошло не так");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return Text("Документ не существует");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              _surname.text = data['surname'];
              _name.text = data['name'];
              _middlename.text = data['middlename'];
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _key,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "Изменение профиля",
                          textAlign: TextAlign.center,
                         style: TextStyle(fontSize: 15, color:Color.fromARGB(255,60,70,70))
                        ),

                        //last name
                        Padding(
                          padding:
                              EdgeInsets.only(left: 300, right: 300),
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
                            maxLength: 200,
                            decoration: const InputDecoration(
                              labelText: 'Фамилия',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),

                        //first name
                        Padding(
                          padding:
                             EdgeInsets.only(left: 300, right: 300),
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
                            maxLength: 200,
                            decoration: const InputDecoration(
                              labelText: 'Имя',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        //middle name
                        Padding(
                          padding:
                              EdgeInsets.only(left: 300, right: 300),
                          child: TextFormField(
                            controller: _middlename,
                            validator: (value) {
                              if (!_isValid) {
                                return null;
                              }
                              if (value!.isEmpty) {
                                return 'Поле пустое';
                              }
                              if (value.length < 1) {
                                return 'Отчество должно содержать не менее 1 символа';
                              }
                              return null;
                            },
                            maxLength: 200,
                            decoration: const InputDecoration(
                              labelText: 'Отчество',
                              border: OutlineInputBorder(),
                            ),
                          ),
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
                         backgroundColor: MaterialStateProperty.all<Color>(Colors.white,), ),
                                child: Text("Сохранить изменения", style: TextStyle(fontSize: 15, color:Color.fromARGB(255,60,70,70)),),
                                onPressed: () => {
                                  _isValid = true,
                                  if (_key.currentState!.validate())
                                    {saveChanges()}
                                },
                              ),
                            ),
                             SizedBox(height: 10,),
                        SizedBox(
                width: 10,
              height: 30,
                    child: ElevatedButton(
                         style: ButtonStyle(
                         backgroundColor: MaterialStateProperty.all<Color>(Colors.white,), ),
                              child: Text("Назад", style: TextStyle(fontSize: 15, color:Color.fromARGB(255,60,70,70)),),
                              onPressed: () => {
                                _isValid = false,
                                _key.currentState!.validate(),
                                Navigator.pushNamed(context, 'welcome'),
                              },
                            ))
                      ],
                    ),
                  ),
                ],
              );
            }

            return const Center(
              child: Text("Загрузка..."),
            );
          },
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    ));
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Изображение успешно загружено"),
        ),
      );
    } else {}
  }

  Future saveChanges() async {
    String id = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set({
          'surname': _surname.text.trim(),
          'name': _name.text.trim(),
          'middlename': _middlename.text.trim(),
          'images': imageData
        })
        .then((value) => {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Данные сохранены"),
                ),
              ),
              Navigator.pushNamed(context, 'welcome'),
            })
        .onError((error, stackTrace) => {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Не удалось сохранить изменения"),
                ),
              )
            });
  }
}
