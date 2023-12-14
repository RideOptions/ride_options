import 'package:just_audio/just_audio.dart';

class ChatMessageModel{
String? id;
String? messageType;
String? senderID;
String? receiverID;
String? message;
dynamic timeStamp;
MediaItem? mediaItem;
AudioPlayer? audioPlayer;
bool playingThis;



ChatMessageModel({this.id,this.messageType, this.senderID, this.receiverID, this.message,
      this.timeStamp, this.mediaItem,this.audioPlayer,this.playingThis=false});

Map<String, dynamic> toMap() {
    return {
      'id': id,
      'messageType': messageType,
      'senderID': senderID,
      'receiverID': receiverID,
      'message': message,
      'timeStamp': timeStamp,
      'mediaItem': mediaItem?.toMap(),
    };
  }
  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    return ChatMessageModel(
      id: map['id']==null?"":map['id'] as String,
      messageType: map['messageType']==null?"":map['messageType'] as String,
      senderID: map['senderID']==null?"":map['senderID'] as String,
      receiverID:map['receiverID']==null?"":map['receiverID'] as String,
      message:map['message']==null?"":map['message'] as String,
      timeStamp: map['timeStamp']==null?0:map['timeStamp'] as int,
      mediaItem: map['mediaItem'] == null ? null : toConverty(map['mediaItem']),
    );
  }
static MediaItem toConverty(Map map) {
  return MediaItem(
    mediaUrl:  map['mediaUrl']==null?"":map['mediaUrl'] as String,
    thumbnail: map['thumbnail']==null?"":map['thumbnail'] as String,
    durationInSecond: map['durationInSecond']==null?0:map['durationInSecond'] as int,
  );
}
}

class MediaItem{
  String? mediaUrl;
  String? thumbnail;
  int? durationInSecond;
  MediaItem({this.mediaUrl, this.thumbnail,this.durationInSecond});

  Map<String, dynamic> toMap() {
    return {
      'mediaUrl': mediaUrl,
      'thumbnail': thumbnail,
      'durationInSecond': durationInSecond,
    };
  }

  factory MediaItem.fromMap(Map<String, dynamic> map) {
    return MediaItem(
      mediaUrl:  map['mediaUrl']==null?"":map['mediaUrl'] as String,
      thumbnail: map['thumbnail']==null?"":map['thumbnail'] as String,
      durationInSecond: map['durationInSecond']==null?0:map['durationInSecond'] as int,
    );
  }
}