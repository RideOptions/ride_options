import 'dart:async';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Dialogue/application_alert_dialogue.dart';
import '../Model/Chat/chat_message_model.dart';
import '../Provider/audio_provider.dart';
import '../common_function.dart';
import '../theme/app_theme.dart';
import '../theme/text_style_theme.dart';

class MessageAudioTemplate extends StatefulWidget {
  ChatMessageModel message;
  String uid;

  MessageAudioTemplate({required this.message,required this.uid});


  @override
  _MessageAudioTemplateState createState() => _MessageAudioTemplateState();
}

class _MessageAudioTemplateState extends State<MessageAudioTemplate>   {

  bool display = true;
  int duration = 0;
  int currentDuration = 0;
  String? thumb = "";
  StreamSubscription? positionStream;
  AudioMessageController? audioMessageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setValues();
  }


  @override
  void dispose() {
    // TODO: implement dispose
   widget.message.audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioMessageController>(
        builder: (context,audioProvider, child) {
          print("call visible check ${audioProvider.callScreenVisible}");
      return Padding(
        padding: widget.message.senderID ==widget.uid
            ? EdgeInsets.only(
                top: 8.0,
                left: 55,
                right: 15.0,
              )
            : EdgeInsets.only(
                top: 8.0,
                left: 15.0,
                right: 55,
              ),
        child: Column(
          children: [
            Align(
              alignment: widget.message.senderID ==widget.uid
                  ? Alignment.bottomRight
                  : Alignment.bottomLeft,
              child: Container(
                decoration: widget.message.senderID ==widget.uid
                    ? BoxDecoration(
                        color: Colors.blue.withOpacity(0.5),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      )
                    : BoxDecoration(
                        color: redColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                child: Padding(
                    padding: EdgeInsets.only(
                            left: 10.0,
                            right: 20.0,
                            bottom: 5,
                            top: 13),
                    child:Column(
                      children: [
                        Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            // ProfileImage(size: 40,),
                            InkWell(
                              onTap: () async {

                                setState(() {
                                  display =false;
                                });
                                if(widget.message.audioPlayer==null){
                                  await loadAudio();
                                }

                                print("playing this: ${widget.message.audioPlayer}");



                                if (widget.message.playingThis == true) {
                                  setState(() {
                                    display=true;
                                  });
                                 await pauseAndStopThisAudioMessage(audioProvider);


                                } else {
                                  print(widget.message.id);
                                  audioProvider.setCurrentPlayedAudioId(widget.message.id!);
                                  if (currentDuration == duration) {
                                    await widget.message.audioPlayer?.seek(const Duration(seconds: 0));
                                  } else {
                                    await  widget.message.audioPlayer?.seek(Duration(seconds: currentDuration));
                                  }

                                  if(widget.message.audioPlayer == null){

                                    AudioPlayer player=AudioPlayer();
                                    await player.setUrl(widget.message.mediaItem!.mediaUrl!);
                                    widget.message.audioPlayer= player;
                                    widget.message.audioPlayer!.seek(Duration(seconds: currentDuration));

                                  }
                                  else{
                                    setState(() {
                                      widget.message.playingThis = true;
                                      display=true;
                                    });
                                    widget.message.audioPlayer?.play();

                                    positionStream =  widget.message.audioPlayer!.positionStream.listen((event) async {
                                      if (audioProvider.getCurrentPlayedAudioId != widget.message.id) {
                                       await pauseAndStopThisAudioMessage(audioProvider);
                                      }
                                      if (currentDuration != event.inSeconds) {
                                        currentDuration = event.inSeconds;
                                        if (currentDuration == duration) {
                                          widget.message.playingThis = false;
                                          await positionStream!.cancel();
                                        }
                                        if(mounted){
                                          setState(() {});
                                        }
                                      }

                                      // }
                                    });

                                    if(audioProvider.getCallScreenVisible){
                                      await pauseAndStopThisAudioMessage(audioProvider);
                                    }
                                  }

                                }
                              },
                              child: display == true
                                  ? Icon(
                                widget.message.playingThis == true
                                    ? Icons
                                    .pause
                                    : Icons
                                    .play_arrow,
                                color:  Colors.white,

                                size: 40,
                              )
                                  : Center(
                                child: Container(
                                  height: 25,
                                  width: 25,
                                  // color: Colors.green,
                                  padding:
                                  const EdgeInsets.all(
                                      2.0),
                                  child:
                                  CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 14.0),
                                child: ProgressBar(
                                  barHeight: 3,
                                  thumbColor:Colors.red.withOpacity(0.5),
                                  thumbRadius: 7,
                                  progressBarColor:Colors.white,
                                  baseBarColor: Colors.white
                                      .withOpacity(0.3),
                                  progress: Duration(
                                      seconds: currentDuration),
                                  // buffered: Duration(milliseconds: 2000),
                                  total:
                                  Duration(seconds: duration),
                                  onSeek: (duration) {
                                    currentDuration =
                                        duration.inSeconds;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
                child: Row(
                  mainAxisAlignment:(widget.message.senderID==widget.uid)? MainAxisAlignment.end:  MainAxisAlignment.start,
                  children: [
                    Text(
                      CommonFunctions().getDateTimeByTimeStamp(
                          widget.message.timeStamp, 'h:mm a'),
                      style: greyTextRegularIn14px(),
                    ),
                  ],
                )),

          ],
        ),
      );
    });
  }

  Future<void> setValues() async {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      audioMessageController=Provider.of<AudioMessageController>(context,listen: false);
    });
       if(widget.message.mediaItem?.durationInSecond != null){
         duration = widget.message.mediaItem!.durationInSecond!;
         setState(() {});
       }

    // await checkAndSetUser();
  }

  Future<void> loadAudio() async{
    print("audio loading");
    final provider = Provider.of<AudioMessageController>(context,listen: false);

    await Future.delayed(const Duration(seconds: 1), () async {

      if (widget.message.mediaItem?.mediaUrl != null || widget.message.mediaItem?.mediaUrl != "") {
        AudioPlayer player=AudioPlayer();
        await player.setUrl(widget.message.mediaItem!.mediaUrl!);
        widget.message.audioPlayer= player;
        duration = widget.message.audioPlayer!.duration!.inSeconds;

      }



      // }
    });
  }

  Future<void> pauseAndStopThisAudioMessage(AudioMessageController audioMessageController) async {
    await widget.message.audioPlayer!.pause();
    widget.message.playingThis = false;
    await positionStream!.cancel();
    if(mounted){
      setState(() {});
    }
  }

}

