import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../helpers/firestore_helper.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffe63946),
        title: Text(
          'Homepage',
          style: GoogleFonts.balooBhai2(fontSize: 25),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xfff1faee),
      body: StreamBuilder(
        stream: FireStoreHelper.fireStoreHelper.fetchBookAuthorData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            QuerySnapshot? res = snapshot.data;

            List<QueryDocumentSnapshot> data = res!.docs;

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, i) {
                Uint8List image = base64.decode(data[i]['image']);

                return Container(
                  margin:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black12),
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 150,
                        width: 110,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red,
                            image: DecorationImage(
                                image: MemoryImage(image), fit: BoxFit.cover)),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Author : ${data[i]['author']}',
                            style: GoogleFonts.balooBhai2(fontSize: 17),
                          ),
                          Text(
                            'Book : ${data[i]['book']}',
                            style: GoogleFonts.balooBhai2(fontSize: 17),
                          ),
                          Text(
                            'Desc : ${data[i]['description']}',
                            style: GoogleFonts.balooBhai2(fontSize: 17),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {

                                  Map res = {
                                    'id': data[i].id,
                                    'image' : image,
                                    'author' : data[i]['author'],
                                    'book' : data[i]['book'],
                                    'description' : data[i]['description'],
                                  };
                                  Navigator.pushNamed(context, 'author_crud', arguments: res);
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent),
                                child: const Icon(Icons.edit),
                              ),
                              const SizedBox(width: 15),
                              OutlinedButton(
                                onPressed: () {
                                  FireStoreHelper.fireStoreHelper.deleteBookAuthorData(id: data[i].id);
                                },
                                style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.red)),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
              backgroundColor: Colors.transparent,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('author_page');
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
    );
  }
}