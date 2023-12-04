import 'package:squawk/models/message.dart';
import 'package:squawk/models/storage.dart';
import 'package:squawk/models/user_account.dart';

class MessageHandler {
  static final MessageHandler _instance = MessageHandler();
  final List<Message> messages = [];

  static MessageHandler getInstance() {
    return _instance;
  }

  Future<void> loadMessages() async {
    Storage storage = Storage.getStorage();
    Message message;
    await storage.getMessages().then((value) => {
      if (value != null)
        {
          for (Map<String, dynamic> map in value)
            {
              message = Message(
                  map['author'],
                  map['receiver'],
                  map['message'],
                  map['id'],),
              messages.add(message),
            },
        }
    });
    messages.sort((a, b) => a.id.compareTo(b.id));
    print("${messages.length} total message loaded");
  }

  List<Message> getConversation(UserAccount author, UserAccount receiver) {
    List<Message> conversation = [];
    for (Message message in messages) {
      if ((message.author == author.mail && message.receiver == receiver.mail) || (message.author == receiver.mail && message.receiver == author.mail)) {
        conversation.add(message);
      }
    }
    return conversation;
  }

  List<Message> getAuthorMessages(UserAccount author) {
    List<Message> conversation = [];
    for (Message message in messages) {
      if (message.author == author.mail || message.receiver == author.mail) {
        conversation.add(message);
      }
    }
    return conversation;
  }

}