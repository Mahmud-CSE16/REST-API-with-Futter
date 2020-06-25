class NoteForListing{
  String noteID;
  String noteTitle;
  DateTime createDateTime;
  DateTime lastEditDateTime;

  NoteForListing({this.noteID,this.noteTitle,this.createDateTime,this.lastEditDateTime});

  factory NoteForListing.fromJson(dynamic item){ //map or dataSnapshot
    return NoteForListing(
      noteID: item['noteID'],
      noteTitle: item['noteTitle'],
      createDateTime: DateTime.parse(item['createDateTime']),
      lastEditDateTime: item['lastEditDateTime']!=null? DateTime.parse(item['lastEditDateTime']):null
    );
  }

}