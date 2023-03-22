import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_pencake_clone/page/note_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NotePage extends StatelessWidget {
  NotePage({Key? key}) : super(key: key);

  int? index = Get.arguments;

  Widget _noteWidget() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('notes')
          .orderBy("created_at", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        final documents = snapshot.data!.docs;
        final note = documents[index!];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  note['note_title'],
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  DateFormat('yyyy년 m월 dd일 (E) ah:mm')
                      .format(note['created_at'].toDate()),
                  style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                      color: Colors.black38),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: SingleChildScrollView(
                  child: Text(
                    note['content'].toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: Colors.black54),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.black26,
            )),
      ),
      body: Stack(
        children: [
          Positioned.fill(child: _noteWidget()),
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                Get.to(() => NoteEditPage());
              },
              child: Container(
                color: Colors.black.withOpacity(0),
              ),
            ),
          )
        ],
      ),
    );
  }
}
