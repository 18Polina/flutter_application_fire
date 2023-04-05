import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UpdateCosmPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UpdateCosmState();
}

class _UpdateCosmState extends State<UpdateCosmPage> {
  final user = FirebaseAuth.instance.currentUser!;
  GlobalKey<FormState> _key = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
 TextEditingController _nameCosmetik = TextEditingController();
  TextEditingController _opisaniecosmetic = TextEditingController();
  bool isObscure = true;
  bool _isValid = true;
  late Map<String, dynamic> imageData = {};
  String noteId = "";

  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context)!.settings.arguments;

    if (data != null) {
      Map<String, dynamic> values = data as Map<String, dynamic>;
      DocumentSnapshot note = values['Cosmetika'];

      _nameCosmetik.text = note['name'];
      _opisaniecosmetic.text = note['opisanie'];
      imageData = note['images'];
      noteId = note.id;
    }

    return Scaffold(
       backgroundColor: Colors.grey,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //title
                Padding(
                  padding: EdgeInsets.only(left: 100, right: 100, top: 15),
                  child: TextFormField(
                    controller: _nameCosmetik,
                    validator: (value) {
                      if (!_isValid) {
                        return null;
                      }
                      if (value!.isEmpty) {
                        return 'Поле пустое';
                      }
                      if (value.length < 5) {
                        return 'Заголовок должнен содержать не менее 5 символа';
                      }
                      return null;
                    },
                    maxLength: 200,
                    decoration: const InputDecoration(
                      labelText: 'Косметика',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                //description
                Padding(
                  padding: EdgeInsets.only(left: 100, right: 100, top: 15),
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
                    maxLength: 200,
                    decoration: const InputDecoration(
                      labelText: 'Описание',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),
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
                SizedBox(height: 20,),
          SizedBox(
             
              width: 200,
              height: 50,
                child: ElevatedButton(
                   style: ButtonStyle(
                         backgroundColor: MaterialStateProperty.all<Color>(Colors.white,), ),
                  child: Text("Сохранить изменения", style: TextStyle(fontSize: 15, color:Color.fromARGB(255,60,70,70)),),
                  onPressed: () => {
                    _isValid = true,
                    if (_key.currentState!.validate()) {UpdateCosm(noteId)}
                  },
                ),
              ),
                SizedBox(height: 20,),
          SizedBox(
               width: 200,
              height: 50,
              child: ElevatedButton(
                 style: ButtonStyle(
                         backgroundColor: MaterialStateProperty.all<Color>(Colors.white,), ),
                child: Text("Вся косметика", style: TextStyle(fontSize: 15, color:Color.fromARGB(255,60,70,70)),),
                onPressed: () => {
                  _isValid = false,
                  _key.currentState!.validate(),
                  Navigator.pushNamed(context, 'cosmetic'),
                },
              )),
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

  Future UpdateCosm(String id) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cosmetic')
        .doc(id)
        .set({
          'name': _nameCosmetik.text.trim(),
      'opisanie': _opisaniecosmetic.text.trim(),
      'images': imageData
        })
        .then((value) => {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Запись изменена"),
                ),
              ),
              Navigator.pushNamed(context, 'cosmetic'),
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