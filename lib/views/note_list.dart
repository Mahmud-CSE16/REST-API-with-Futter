import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:restapi/models/api_response.dart';
import 'package:restapi/models/note_for_listing.dart';
import 'package:restapi/services/note_services.dart';
import 'package:restapi/views/delete_note.dart';

import 'note_modify.dart';

class NoteList extends StatefulWidget {
  NoteList({Key key}) : super(key: key);

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {

  // get NoteService
  NoteService get service => GetIt.I<NoteService>();

  APIResponse<List<NoteForListing>> _apiResponse;
  bool _isLoading = false;


  // formatedatetime
  String formateDateTime(DateTime dateTime){
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  void initState() {
    _fetchNotes();
    super.initState();
  }

  _fetchNotes() async{
    setState(() {
      _isLoading = true;
    });

    _apiResponse = await service.getNoteList();

    setState(() {
      _isLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of notes'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          Navigator.of(context).push(MaterialPageRoute(builder: (_)=> NoteModify())).then((value) => _fetchNotes());
        },
        child: Icon(Icons.add),
      ),
      body: Builder(
        builder: (_){
          if(_isLoading){
            return Center(child: CircularProgressIndicator());
          }

          if(_apiResponse.error){
            return Center(child: Text(_apiResponse.errorMessage));
          }

          return ListView.separated(
            itemCount: _apiResponse.data.length,
            separatorBuilder: (_,__)=> Divider(height: 1,color: Colors.green,),
            itemBuilder: (_, index){
              return Dismissible(
                key: ValueKey(_apiResponse.data[index].noteID),
                direction: DismissDirection.startToEnd,
                onDismissed: (direction){

                },
                confirmDismiss: (direction) async {
                  final result = await showDialog(
                    context: context,
                    builder: (_)=>DeleteNote()
                  );

                  if(result){
                    final deleteResult = await service.deleteNote(_apiResponse.data[index].noteID);
                    String message;

                    if(deleteResult!=null && deleteResult.error!=true){
                      message = "The note was deleted successfully";
                    }else{
                      message = deleteResult?.errorMessage?? 'An Error Occured';
                    }

                    showDialog(
                      context: context,
                      builder: (_)=> AlertDialog(
                        title: Text("Done"),
                        content: Text(message),
                        actions: [
                          FlatButton(
                            child: Text('Ok'),
                            onPressed: ()=>Navigator.of(context).pop(),
                          )
                        ],
                      )
                    );

                    return deleteResult?.data?? false;
                  }
                  return false;
                },
                background: Container(
                  color: Colors.red,
                  padding: EdgeInsets.only(left: 16.0),
                  child: Align(child: Icon(Icons.delete,color:Colors.white),alignment: Alignment.centerLeft,),
                ),
                child: ListTile(
                  onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (_)=> NoteModify(noteId: _apiResponse.data[index].noteID,))).then((value) => _fetchNotes()),
                  title: Text(_apiResponse.data[index].noteTitle,style: TextStyle(color:Theme.of(context).primaryColor,fontSize: 18),),
                  subtitle: Text('Last Edited on ${formateDateTime(_apiResponse.data[index].lastEditDateTime ?? _apiResponse.data[index].createDateTime)}'),
                ),
              );
            },
          );
        }
      )
    );
  }
}
