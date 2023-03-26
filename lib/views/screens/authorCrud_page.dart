import 'dart:convert';
import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../helpers/firestore_helper.dart';

class AuthorCrud extends StatefulWidget {
  const AuthorCrud({Key? key}) : super(key: key);

  @override
  State<AuthorCrud> createState() => _AuthorCrudState();
}

class _AuthorCrudState extends State<AuthorCrud> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController authorNameController = TextEditingController();
  TextEditingController bookNameController = TextEditingController();
  TextEditingController bookDescriptionController = TextEditingController();

  Uint8List? img;

  @override
  Widget build(BuildContext context) {

    Map res = ModalRoute.of(context)!.settings.arguments as Map;

    img = res['image'];
    authorNameController.value = TextEditingValue(text: '${res['author']}');
    bookNameController.value = TextEditingValue(text: '${res['book']}');
    bookDescriptionController.value = TextEditingValue(text: '${res['description']}');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade400,
        title: Text(
          'Author',
          style: GoogleFonts.balooBhai2(fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 90),
                child: DottedBorder(
                  color: Colors.black,
                  borderType: BorderType.RRect,
                  strokeWidth: 2,
                  dashPattern: const [3],
                  radius: const Radius.circular(30),
                  child: GestureDetector(
                    onTap: () async {
                      ImagePicker picker = ImagePicker();

                      XFile? xFile =
                      await picker.pickImage(source: ImageSource.camera);

                      img = await xFile?.readAsBytes();

                      setImage() async{

                        img = await FlutterImageCompress
                            .compressWithList(
                          img!,
                          minHeight: 150,
                          minWidth: 150,
                          quality: 60,
                        );
                      }

                      setState(() {
                        setImage();
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.black26,
                        image: (img != null)
                            ? DecorationImage(
                          image: MemoryImage(img!),
                          fit: BoxFit.cover,
                        )
                            : null,
                      ),
                      child: (img == null)
                          ? Text(
                        'Add photo',
                        style: GoogleFonts.habibi(fontSize: 18),
                      )
                          : const Text(''),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                style:
                GoogleFonts.balooBhai2(color: Colors.black, fontSize: 17),
                controller: authorNameController,
                decoration: InputDecoration(
                  labelText: 'Author',
                  labelStyle: GoogleFonts.balooBhai2(
                      color: Colors.black54, fontSize: 20),
                  prefixIcon: const Icon(
                    CupertinoIcons.person,
                    color: Colors.black54,
                  ),
                  contentPadding: const EdgeInsets.only(left: 14.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                style:
                GoogleFonts.balooBhai2(color: Colors.black, fontSize: 17),
                controller: bookNameController,
                decoration: InputDecoration(
                  labelText: 'Book',
                  labelStyle: GoogleFonts.balooBhai2(
                      color: Colors.black54, fontSize: 20),
                  prefixIcon: const Icon(
                    CupertinoIcons.book,
                    color: Colors.black54,
                  ),
                  contentPadding: const EdgeInsets.only(left: 14.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                style:
                GoogleFonts.balooBhai2(color: Colors.black, fontSize: 17),
                controller: bookDescriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: GoogleFonts.balooBhai2(
                      color: Colors.black54, fontSize: 20),
                  prefixIcon: const Icon(
                    CupertinoIcons.news,
                    color: Colors.black54,
                  ),
                  contentPadding: const EdgeInsets.only(left: 14.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              const SizedBox(height: 150),
              GestureDetector(
                onTap: () async {
                  if (formKey.currentState!.validate()) {

                    String image = base64.encode(img!);

                    Map<String, dynamic> data = {
                      'image': image,
                      'author': authorNameController.text,
                      'book': bookNameController.text,
                      'description': bookDescriptionController.text,
                    };

                    await FireStoreHelper
                        .fireStoreHelper
                        .updateBookAuthorData(id: res['id'],data: data);

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Author Detail Update...'),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                child: Container(
                  height: 55,
                  width: 200,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  decoration: BoxDecoration(
                      color: Colors.green.shade400,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.black,width: 3)),
                  child: Text(
                    'Update Book',
                    style: GoogleFonts.balooBhai2(
                        fontSize: 27, color: Colors.black),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}