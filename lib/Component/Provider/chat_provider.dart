import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import '../Function/send_notification.dart';
import '../Model/Authentication/user_model.dart';
import '../Model/Chat/chat_message_model.dart';
import '../Services/global_service.dart';
import '../Services/local_service.dart';
import '../constant.dart';

class ChatProvider with ChangeNotifier {
  List<ChatMessageModel> messagesList = [];
  bool receivedNewMessages = false;
  bool messagesListEmpty = false;

  List<ChatMessageModel> get getMessagesList => messagesList;
  void setMessagesList(List<ChatMessageModel> value) {
    messagesList = value;
    notifyListeners();
  }

  bool get getReceivedNewMessages => receivedNewMessages;
  void setReceivedNewMessages(bool value) {
    receivedNewMessages = value;
    // notifyListeners();
  }

  bool get getMessagesListEmpty => messagesListEmpty;
  void setMessagesListEmpty(bool value) {
    messagesListEmpty = value;
    notifyListeners();
  }

  sendMessageToUserMethod(
      BuildContext context,
      String message,
      String messageType,
      MediaItem? mediaItem,
      String senderID,
      String receiverID,
      List<String> deviceToken) async {
    try {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("SaTtAaYz").child('messages');
      String? nodeKey = ref.push().key;

      print(
          "--------ServerValue.timestamp---------: ${deviceToken.toString()}");
      print(ServerValue.timestamp.toString());
      String? chatRoomId =
          await GlobalService().getChatId(senderID, receiverID);
      int timeStamp = await GlobalService().getCurrentTime();
      ChatMessageModel chatMessageModel = ChatMessageModel(
        messageType: messageType,
        id: nodeKey,
        senderID: senderID,
        receiverID: receiverID,
        message: message,
        mediaItem: mediaItem,
        timeStamp: timeStamp,
      );
      print("send Message To User Model: ${chatMessageModel.toMap()}");
      UserModel? signupData = await LocalStorageService.getSignUpModel();

      await ref.child(chatRoomId).child(nodeKey!).set(chatMessageModel.toMap());
      await sendNotificationPostRequest(
          "New Unread Message",
          (signupData!.userType == Constant.customerRole)
              ? "you have new message by customer!"
              : "you have new message by driver!",
          deviceToken);

      // await sendNotification(context:context,notificationType: Constant.userChat, title: "${userDetail?.profileName} ", m:(messageType=="text")?(message.length>15)?"${message.substring(0,15)}...": message:messageType, userID: receiverID, uid: userDetail!.uid!, data:chatMessageModel.toMap());
    } catch (ex, st) {
      print("Exception sendMessageToUserMethod:$ex |StackTrace: $st");
    }
  }

  pauseAllAudiosMethod() {
    print("pauseAllAudiosMethod call");
    var list = messagesList
        .where((element) => element.messageType == "audio")
        .toList();
    list.forEach((element) {
      if (element.audioPlayer?.playing == true) {
        element.audioPlayer?.pause();
        element.playingThis = false;
        // element.audioPlayer?.stop();
      }
    });
  }
}
