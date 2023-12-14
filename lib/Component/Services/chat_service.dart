import 'package:firebase_database/firebase_database.dart';
import 'package:collection/collection.dart';
import '../Model/Chat/chat_message_model.dart';
import '../Provider/chat_provider.dart';

class ChatService {
  listenIncomingMessages(
      ChatProvider? chatProvider, String? chatId, String? receiverUid) async {
    // AudioPlayer player;

    DatabaseReference ref =
        FirebaseDatabase.instance.ref("SaTtAaYz").child('messages');
    ref.child(chatId ?? "").onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      List<ChatMessageModel> dummyMessagesList = [];
      int length = chatProvider?.messagesList.length ?? 0;
      chatProvider?.messagesList.clear();
      if (snapshot.exists) {
        Map<dynamic, dynamic> mapData =
            Map<dynamic, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
        mapData.forEach((key, value) {
          Map<String, dynamic> messageItemMap =
              Map<String, dynamic>.from(value);
          ChatMessageModel messageItem =
              ChatMessageModel.fromMap(messageItemMap);
          if (messageItem.messageType == "audio") {
            if (chatProvider!.messagesList.isNotEmpty) {
              ChatMessageModel? model = chatProvider.messagesList
                  .firstWhereOrNull((element) => element.id == messageItem.id);
              if (model != null) {
                print("local list data is: ${model.toMap()}");
                messageItem.playingThis = model.playingThis;
              }
            }
          }

          dummyMessagesList.add(messageItem);
        });
        if (dummyMessagesList.isNotEmpty) {
          dummyMessagesList
              .sort((a, b) => a.timeStamp!.compareTo(b.timeStamp!));
          print("chat list len: $length");
          print("dummy list len: ${dummyMessagesList.length}");
          if (dummyMessagesList.length > length) {
            chatProvider?.setReceivedNewMessages(true);
          }

          chatProvider?.notifyListeners();
        }
      }
      print("======Message list count:===== ${dummyMessagesList.length}");
      if (dummyMessagesList.isEmpty) {
        chatProvider?.setMessagesListEmpty(true);
      }
      chatProvider?.setMessagesList(dummyMessagesList);
    });
  }
}
