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
        backgroundColor: Colors.green.shade400,
        title: Text(
          'Homepage',
          style: GoogleFonts.balooBhai2(fontSize: 30),
        ),
        centerTitle: true,
      ),
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
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green.shade100),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 110,
                        width: 110,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red,
                            image: DecorationImage(
                                image: MemoryImage(image), fit: BoxFit.cover)),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 30,),
                          Text(
                            'Author : ${data[i]['author']}',
                            style: GoogleFonts.balooBhai2(fontSize: 20,fontWeight: FontWeight.w500),
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
                                    backgroundColor: Colors.green.shade300),
                                child: const Icon(Icons.edit,color: Colors.black,),
                              ),
                              const SizedBox(width: 30),
                              OutlinedButton(
                                onPressed: () {
                                  FireStoreHelper.fireStoreHelper.deleteBookAuthorData(id: data[i].id);
                                },
                                style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.green)),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.black,
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
              color: Colors.green,
              backgroundColor: Colors.transparent,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('author_page');
        },
        backgroundColor: Colors.green.shade300,
        child: const Icon(Icons.add,color: Colors.black,size: 40,),
      ),
    );
  }
}