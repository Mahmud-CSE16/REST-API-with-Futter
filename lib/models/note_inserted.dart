class NoteInsert{
  String noteTitle;
  String noteContent;

  NoteInsert({this.noteTitle,this.noteContent});

  Map<String,dynamic> toJson() {
    return {
      "noteTitle" : noteTitle,
      "noteContent" : noteContent
    };
  }

}