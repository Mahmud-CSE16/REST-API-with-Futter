import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:restapi/models/note.dart';
import 'package:restapi/models/note_inserted.dart';
import 'package:restapi/services/note_services.dart';

class NoteModify extends StatefulWidget {
  final String noteId;
  NoteModify({this.noteId});

  @override
  _NoteModifyState createState() => _NoteModifyState();
}

class _NoteModifyState extends State<NoteModify> {

  bool get isEditing => widget.noteId != null;

  NoteService get service => GetIt.I<NoteService>();

  String errorMessage;
  Note note;

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    
    if(isEditing){
      setState(() {
        _isLoading = true;
      });
      
      service.getNote(widget.noteId).then((response){

        setState(() {
          _isLoading = false;
        });

        if(response.error){
          errorMessage = response.errorMessage ?? 'An Error Occoured';
        }
        note = response.data;
        titleController.text = note.noteTitle;
        contentController.text = note.noteContent;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing? 'Edit Note':'Create Note'),
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator()): Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Note title',
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: contentController,
              decoration: InputDecoration(
                hintText: 'Note Content',
              ),
            ),
            SizedBox(height: 10,),
            SizedBox(
              height: 40.0,
              width: double.infinity,
              child: RaisedButton(
                child: Text("Submit",style: TextStyle(color:Colors.white),),
                color: Theme.of(context).primaryColor,
                onPressed: () async{
                  setState(() {
                    _isLoading = true;
                  });

                  if(isEditing){
                    //update note
                    final note = NoteInsert(noteTitle: titleController.text,noteContent: contentController.text);
                    final result = await service.updateNote(widget.noteId,note);

                    final title = "Done";
                    final text = result.error ? (result.errorMessage?? "An Error Occoured"): "Your note was updated";

                    setState(() {
                      _isLoading = false;
                    });

                    showDialog(
                      context: context,
                      builder: (_)=> AlertDialog(
                        title: Text(title),
                        content: Text(text),
                        actions: [
                          FlatButton(onPressed: ()=>Navigator.of(context).pop(), child: Text("OK"))
                        ],
                      )
                    ).then((value) => Navigator.of(context).pop());
                  }else{
                    // create note
                    final note = NoteInsert(noteTitle: titleController.text,noteContent: contentController.text);
                    final result = await service.createNote(note);

                    final title = "Done";
                    final text = result.error ? (result.errorMessage?? "An Error Occoured"): "Your note was created";

                    setState(() {
                      _isLoading = false;
                    });

                    showDialog(
                      context: context,
                      builder: (_)=> AlertDialog(
                        title: Text(title),
                        content: Text(text),
                        actions: [
                          FlatButton(onPressed: ()=>Navigator.of(context).pop(), child: Text("OK"))
                        ],
                      )
                    ).then((value) => Navigator.of(context).pop());
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}