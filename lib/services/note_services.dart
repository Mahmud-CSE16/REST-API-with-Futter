
import 'dart:convert';

import 'package:restapi/models/api_response.dart';
import 'package:restapi/models/note.dart';
import 'package:restapi/models/note_for_listing.dart';
import 'package:http/http.dart' as http;
import 'package:restapi/models/note_inserted.dart';

class NoteService{

  static const API = 'http://api.notes.programmingaddict.com';
  static const headers = {
    'apiKey': '828566f4-0bed-40eb-bc7c-8bca27d5ef52',
    'Content-Type': 'application/json'
  };

  // getNoteList
  Future<APIResponse<List<NoteForListing>>> getNoteList(){
    return http.get(API+'/notes',headers:headers)
    .then((data){
      if(data.statusCode == 200){
        final jsonData = json.decode(data.body);
        final notes = <NoteForListing>[];

        for(var item in jsonData){
          notes.add(NoteForListing.fromJson(item));
        }

        return APIResponse<List<NoteForListing>>(data: notes);
      }
      return APIResponse<List<NoteForListing>>(error: true,errorMessage: 'An Error Occured.');
    }).catchError((onError)=>APIResponse<List<NoteForListing>>(error: true,errorMessage: 'An Error Occured.'));
  }

  // getNote
  Future<APIResponse<Note>> getNote(String noteID){
    return http.get(API+'/notes/'+noteID,headers:headers)
    .then((data){
      if(data.statusCode == 200){
        final jsonData = json.decode(data.body);
        return APIResponse<Note>(data: Note.fromJson(jsonData));
      }
      return APIResponse<Note>(error: true,errorMessage: 'An Error Occured.');
    }).catchError((onError)=>APIResponse<Note>(error: true,errorMessage: 'An Error Occured.'));
  }

  // createNote
  Future<APIResponse<bool>> createNote(NoteInsert item){
    return http.post(API+'/notes',headers:headers,body: json.encode(item.toJson()))
    .then((data){
      if(data.statusCode == 201){
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true,errorMessage: 'An Error Occured.');
    }).catchError((onError)=>APIResponse<bool>(error: true,errorMessage: 'An Error Occured.'));
  }

  // update note
  Future<APIResponse<bool>> updateNote(String noteID,NoteInsert item){
    return http.put(API+'/notes/'+noteID,headers:headers,body: json.encode(item.toJson()))
    .then((data){
      if(data.statusCode == 204){
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true,errorMessage: 'An Error Occured.');
    }).catchError((onError)=>APIResponse<bool>(error: true,errorMessage: 'An Error Occured.'));
  }

  // delete note
  Future<APIResponse<bool>> deleteNote(String noteID){
    return http.delete(API+'/notes/'+noteID,headers:headers)
    .then((data){
      if(data.statusCode == 204){
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true,errorMessage: 'An Error Occured.');
    }).catchError((onError)=>APIResponse<bool>(error: true,errorMessage: 'An Error Occured.'));
  }
}