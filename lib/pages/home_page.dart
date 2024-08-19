import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasecrudtut/services/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController textController = TextEditingController();
  void openNoteBox(String? docID) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (docID == null){
                firestoreService.addNote(textController.text);
              }
              else {
                firestoreService.updateNote(docID, textController.text);
              }
              textController.clear();
              Navigator.pop(context);
            },
            child: Text("Add"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade50,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Notes",style: TextStyle(
          color: Colors.white,

        ),),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: ()=> openNoteBox(null),
        child: const Icon(Icons.add,
        color: Colors.white,),

      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNoteStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;
            return ListView.builder(

              itemCount: notesList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = notesList[index];
                String docID = document.id;
                Map<String,dynamic>data= document.data() as Map<String,dynamic>;
                String noteText = data['note'];
                return Padding(


                  padding: const EdgeInsets.only(left: 10.0,right: 10.0,top: 14),
                  child: Container(


                    margin: EdgeInsets.only(top: 10),
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade600,
                      border: Border(),
                      borderRadius: BorderRadius.circular(10),

                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: ListTile(

                        title: Text(noteText),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: ()=>openNoteBox(docID),
                              icon: const Icon(Icons.settings),
                            ),
                            IconButton(
                              onPressed: ()=>firestoreService.deleteNote(docID),
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        )
                      ),
                    ),
                  ),
                );

              },
            );
          }
          else{
            return const Text("No notes..");
          }
        },
      ),
    );
  }
}
