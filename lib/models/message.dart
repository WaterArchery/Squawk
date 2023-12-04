class Message {
  Message(this.author, this.receiver, this.message, this.id);

  String author;
  String receiver;
  String message;
  int id;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'author': author,
      'message': message,
      'receiver': receiver,
    };
  }

}