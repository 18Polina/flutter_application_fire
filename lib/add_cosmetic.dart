import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AddCosmPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddCosmPageState();
}

class _AddCosmPageState extends State<AddCosmPage> {
  final user = FirebaseAuth.instance.currentUser!;
  GlobalKey<FormState> _key = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _nameCosmetik = TextEditingController();
  TextEditingController _opisaniecosmetic = TextEditingController();
  bool isObscure = true;
  bool _isValid = true;
  late Map<String, dynamic> imageData = {};

  Future<String> loadImage(DocumentSnapshot documentSnapshot) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child(documentSnapshot['images']['storage_path']);

    var url = await ref.getDownloadURL();
    print(url);
    return url;
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _cosmetic = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cosmetic')
        .snapshots();

    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Добавление косметики",
          style: TextStyle(fontSize: 30,color: Color.fromARGB(255, 47,54,51)),
          ),
          Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //title
                Padding(
                  padding: EdgeInsets.only(left: 300, right: 300),
                  child: TextFormField(
                    controller: _nameCosmetik,
                    validator: (value) {
                      if (!_isValid) {
                        return null;
                      }
                      if (value!.isEmpty) {
                        return 'Поле пустое';
                      }
                      if (value.length < 1) {
                        return 'Заголовок должнен содержать не менее 1 символа';
                      }
                      return null;
                    },
                    maxLength: 255,
                    decoration: const InputDecoration(
                      labelText: 'Заголовок',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                //description
                Padding(
                  padding: EdgeInsets.only(left: 300, right: 300),
                  child: TextFormField(
                    controller: _opisaniecosmetic,
                    validator: (value) {
                      if (!_isValid) {
                        return null;
                      }
                      if (value!.isEmpty) {
                        return 'Поле пустое';
                      }
                      if (value.length < 1) {
                        return 'Описание должно содержать не менее 1 символа';
                      }
                      return null;
                    },
                    maxLength: 255,
                    decoration: const InputDecoration(
                      labelText: 'Описание',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
           const     SizedBox(
                    height: 20,
                  ),
          SizedBox(
               width: 200,
              height: 50,
                    child: ElevatedButton(
                         style: ButtonStyle(
                         backgroundColor: MaterialStateProperty.all<Color>(Colors.white,), ),
                  child: Text("Загрузить фото", style: TextStyle(fontSize: 15, color:Color.fromARGB(255,60,70,70)),),
                  onPressed: () => {_pickFile()},
                ),
              ),
               const     SizedBox(
                    height: 20,
                  ),
          SizedBox(
               width: 200,
              height: 50,
                    child: ElevatedButton(
                         style: ButtonStyle(
                         backgroundColor: MaterialStateProperty.all<Color>(Colors.white,), ),
                  child: Text("Добавить косметику", style: TextStyle(fontSize: 15, color:Color.fromARGB(255,60,70,70)),),
                  onPressed: () => {
                    _isValid = true,
                    if (_key.currentState!.validate()) {addCosm()}
                  },
                ),
              ),
               const     SizedBox(
                    height: 20,
                  ),
          SizedBox(
              width: 200,
              height: 50,
                    child: ElevatedButton(
                         style: ButtonStyle(
                         backgroundColor: MaterialStateProperty.all<Color>(Colors.white,), ),
                child: Text("Главная", style: TextStyle(fontSize: 15, color:Color.fromARGB(255,60,70,70)),),
                onPressed: () => {
                  _isValid = false,
                  _key.currentState!.validate(),
                  Navigator.pushNamed(context, 'welcome'),
                },
              )),
          SizedBox(
            height: 25,
          ),
          Text(
            "Косметика",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 25,
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: _cosmetic,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: Text('Пока нет косметики'));
              }
              if (snapshot.hasError) {
                return Text('Что-то пошло не так');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Загрузка");
              }

              if (snapshot.hasData) {
                return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot documentSnapshot =
                          snapshot.data!.docs[index];
                      return Column(
                        children: [
                          FutureBuilder<String>(
                            future: loadImage(documentSnapshot),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> image) {
                              if (image.hasData) {
                                return Column(
                                  children: [
                                    Container(
                                      width: 150,
                                      child: Image.network(
                                        image.data.toString(),
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                    Text(
                                        'Размер фото: ' +
                                            documentSnapshot['images']
                                                    ['size']
                                                .toString(),
                                        style: TextStyle(fontSize: 15)),
                                    Text(
                                        'Название фото: ' +
                                            documentSnapshot['images']
                                                ['name'],
                                        style: TextStyle(fontSize: 15)),
                                  ],
                                );
                              } else {
                                return new Container(); // placeholder
                              }
                            },
                          ),
                          Text('Название косметики: ' + documentSnapshot['name'],
                              style: TextStyle(fontSize: 30)),
                          SizedBox(
                            height: 15,
                          ),
                          Text('Описание: ' + documentSnapshot['opisanie'],
                              style: TextStyle(fontSize: 22)),
                          Row(
                            // ignore: sort_child_properties_last
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white),
                                  onPressed: () {
                                    FirebaseStorage.instance
                                        .ref()
                                        .child(documentSnapshot["images"]
                                            ['storage_path'])
                                        .delete();
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(user.uid)
                                        .collection('cosmetic')
                                        .doc(documentSnapshot.id)
                                        .delete();
                                  },
                                  child: Text(
                                    "Удалить",
                                    style: TextStyle(color: Colors.red),
                                  )),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white),
                                  onPressed: () {
                                    Map<String, dynamic> values = {
                                      'Cosmetika': documentSnapshot
                                    };
                                    Navigator.pushNamed(context, 'updateCosm',
                                        arguments: values);
                                  },
                                  child: Text(
                                    "Изменить",
                                    style: TextStyle(color: Colors.black),
                                  )),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      );
                    });
              }

              return Container();
            },
          ))
        ],
      )),
    );
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
    } else {}
  }

  Future addCosm() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cosmetic')
        .add({
      'name': _nameCosmetik.text.trim(),
      'opisanie': _opisaniecosmetic.text.trim(),
      'images': imageData
    });
  }
}
