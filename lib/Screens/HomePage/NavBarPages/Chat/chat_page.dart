import 'dart:async';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../../Component/Bottom_Sheet/image_frame.dart';
import '../../../../Component/Common_Widget/circular_network_Image.dart';
import '../../../../Component/Common_Widget/seprator_line_wiget.dart';
import '../../../../Component/Dialogue/application_alert_dialogue.dart';
import '../../../../Component/ItemTemplate/message_audio_template.dart';
import '../../../../Component/ItemTemplate/message_template.dart';
import '../../../../Component/Model/Authentication/user_model.dart';
import '../../../../Component/Model/Chat/chat_message_model.dart';
import '../../../../Component/Provider/chat_provider.dart';
import '../../../../Component/Services/chat_service.dart';
import '../../../../Component/Services/global_service.dart';
import '../../../../Component/Services/local_service.dart';
import '../../../../Component/common_function.dart';
import '../../../../Component/theme/app_theme.dart';
import '../../../../Component/theme/text_style_theme.dart';

class ChatPage extends StatefulWidget {
  UserModel userModel;

  ChatPage({required this.userModel});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  bool startRecording = false;
  TextEditingController messageTextController = TextEditingController();
  bool sendBtnVisible = false;
  final ScrollController _controller = ScrollController();
  bool shouldAutoscroll = false;
  Timer? _timer;
  ChatProvider? chatProvider;
  UserModel? userDetail;
  String? chatId;
  String? recordFilePath;
  int _start = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      initializeComponent();
    });
    messageTextController.addListener(() {
      setState(() {
        if (messageTextController.text.isNotEmpty) {
          sendBtnVisible = true;
        } else {
          sendBtnVisible = false;
        }
      });
    });
    _controller.addListener(scrollListener);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    CommonFunctions.chatScreen=false;

  }

  @override
  Widget build(BuildContext context) {
    bool newMessage = Provider.of<ChatProvider>(context, listen: true).getReceivedNewMessages;
    if(newMessage==true){
      Future.delayed(Duration(seconds: 1),(){
        _scrollDown();
      });

    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Consumer<ChatProvider>(
            builder: (context, consumerChatProvider, child) {
          return Column(
            children: [
              Container(
                color: Colors.white,
                height: 65,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          size: 30,
                          color: primaryColor,
                        )),
                    Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      ),
                      child: CircleNetworkImageFrame(
                          widget.userModel.profilePicture ??
                              "https://www.webxcreation.com/event-recruitment/images/profile-1.jpg",
                          45,
                          45,
                          null),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.userModel.name ?? "",
                      style: blackTextBoldIn18px(),
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: () async {
                          await CommonFunctions().makePhoneCall('tel:${widget.userModel.phoneNumber}');

                        },
                        icon: Icon(
                          Icons.phone,
                          size: 30,
                          color: primaryColor,
                        )),
                    SizedBox(
                      width: 20,
                    )
                  ],
                ),
              ),
              SepratorLine(
                horizontalMargin: 0,
                verticalMargin: 0,
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Stack(
                    children: [
                      ListView.builder(
                        controller: _controller,
                        itemCount: consumerChatProvider.messagesList.length,
                        cacheExtent: double.infinity,
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        itemBuilder: (context, index) {
                          return () {
                            if (consumerChatProvider
                                    .messagesList[index].messageType ==
                                "text") {
                              return MessageTemplate(
                                  chatMessageModel:
                                      consumerChatProvider.messagesList[index],
                                  Mine: consumerChatProvider
                                              .messagesList[index].senderID ==
                                          userDetail?.uid
                                      ? true
                                      : false);
                            } else {
                              return MessageAudioTemplate(message:consumerChatProvider.messagesList[index],uid: userDetail!.uid!,);
                            }
                          }();
                        },
                      ),
                      Positioned(
                          right: 8,
                          bottom: 8,
                          child: (shouldAutoscroll)
                              ? GestureDetector(
                              onTap: _scrollDown,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(15),
                                  color: primaryColor,
                                ),
                                width: 30,
                                height: 30,
                                child: const Icon(
                                  Icons.keyboard_arrow_down_sharp,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ))
                              : Container()),
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                height: 65,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade500,
                              offset: const Offset(
                                0.0,
                                1.0,
                              ),
                              blurRadius: 1.0,
                              spreadRadius: 1.0,
                            ), //BoxShadow
                            BoxShadow(
                              color: Colors.white,
                              offset: const Offset(0.0, 0.0),
                              blurRadius: 0.0,
                              spreadRadius: 0.0,
                            ), //BoxShadow
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        margin: EdgeInsets.only(left: 10),
                        height: 50,
                        child: (startRecording)
                            ? Row(
                                children: [
                                  Image.asset(
                                    "assets/images/recorder.gif",
                                    width: 40,
                                    height: 40,
                                    color: primaryColor,
                                  ),
                                  // const Icon(
                                  //   Icons.mic_rounded,
                                  //   size: 25,
                                  //   color: Colors.grey,
                                  // ),
                                  Text(
                                    "${formatTime(_start)} recording.....",
                                    style: greyTextRegularIn16px(),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                      onTap: () {
                                        sendBtnVisible = false;
                                        startRecording = false;
                                        stopTimer();
                                        stopRecord();
                                      },
                                      child: Icon(
                                        Icons.delete_rounded,
                                        size: 30,
                                        color: redColor,
                                      )),
                                ],
                              )
                            : TextField(
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                controller: messageTextController,
                                decoration: InputDecoration(
                                  hintText: "Message",
                                  hintStyle: greyTextRegularIn14px(),
                                  border: InputBorder.none,
                                ),
                                style: blackTextRegularIn14px(),
                              ),
                      ),
                    ),
                    GestureDetector(
                      onLongPressStart: (val) async {
                        print("long press start.....$val");
                        await chatProvider?.pauseAllAudiosMethod();
                        startRecord();
                      },
                      onLongPressEnd: (val) async {
                        sendBtnVisible = true;
                        // _timer?.cancel();
                        // stopRecord();
                        setState(() {});
                      },
                      onTap: () async {
                        if (startRecording) {
                          await sendRecordingAsync();
                        } else {
                          String str = messageTextController.text.trim();
                          if (str.isNotEmpty) {
                            chatProvider?.sendMessageToUserMethod(
                              context,
                              str,
                              "text",
                              null,
                              userDetail!.uid!,
                              widget.userModel.uid!,
                              widget.userModel.deviceToken!,
                            );
                            print("text message sent");
                            messageTextController.text = "";
                            setState(() {});
                            Future.delayed(Duration(seconds: 1), () {
                              _scrollDown();
                            });
                          }
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: ImageFrame(
                          imageUrl: (sendBtnVisible)
                              ? "assets/images/send.png"
                              : "assets/images/microphone.png",
                          width: 50,
                          height: 50,
                          hasShadow: true,
                          bgColor: primaryColor,
                          framePadding: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  initializeComponent() async {
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    userDetail = await LocalStorageService.getSignUpModel();
    chatId = await GlobalService().getChatId(userDetail!.uid!, widget.userModel.uid!);
    CommonFunctions.chatScreen=true;
    print("chat id: $chatId");
    await ChatService().listenIncomingMessages(
        chatProvider, chatId, widget.userModel.uid);
    Future.delayed(Duration(seconds: 1),(){
      _scrollDown();
    });

    setState(() {});
  }

  void scrollListener() {
    print("=======scrollListener=======");
    if (_controller.hasClients &&
        _controller.position.pixels == _controller.position.maxScrollExtent) {
      shouldAutoscroll = false;
    } else {
      shouldAutoscroll = true;
    }
    setState(() {});
  }

  void _scrollDown() {
    _controller.jumpTo(_controller.position.maxScrollExtent);
    chatProvider?.setReceivedNewMessages(false);
    setState(() {});
  }

  void startRecord() async {
    startRecording = true;
    bool hasPermission = await checkPermission();
    print("hasPermission: $hasPermission");
    if (hasPermission) {
      recordFilePath = await getFilePath();
      print("start recording....");
      // RecordMp3.instance.start(recordFilePath!, (type) {
      //   setState(() {});
      // });
      startTimer();
    } else {
      bool? result = await showDialog(
          context: context,
          // barrierDismissible: false,

          builder: (BuildContext context) {
            return ApplicationAlertDialogue(
              dialogueHeight: 340,
              imageWidth: 100,
              imageHeight: 100,
              buttonText: "Got It!",
              imagePath: "assets/images/alert_icon.png",
              title: "Alert!",
              titleStyle: blackTextRegularIn16px(),
              description: "App need microphone permission to record audio.",
              descriptionStyle: greyTextRegularIn14px(),
              richTextFlag: false,
              cancelBtnVisible: true,
              pngPath: true,
              onTap: () async {
                Navigator.pop(context, true);
              },
            );
          });
      if (result == true) {
        await openAppSettings();
      }

      print("Exception: No microphone permission");
    }
    // setState(() {});
  }

  stopRecord() async {
    print("stop recording....");
    // RecordMp3.instance.stop();
    if (mounted) {
      setState(() {});
    }
  }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = "${storageDirectory.path}/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return "$sdPath/test-${Uuid().v4()}.mp3";
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (mounted) {
          setState(() {
            _start++;
          });
        }
      },
    );
  }

  stopTimer() {
    _start = 0;
    _timer?.cancel();
  }

  String formatTime(int seconds) {
    return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(6, '0');
  }

  sendRecordingAsync()async{
    bool netConnected= await GlobalService().checkInternetConnection();
    if(netConnected){
      try {
        startRecording = false;
        sendBtnVisible=false;
        int audioDuration=_start;
        stopTimer();
        stopRecord();
        if (recordFilePath != null) {
          File file = File(recordFilePath!);
          print("audio file is: $file");
          print("audio file length is: ${file.lengthSync()}");
          var uuid= const Uuid();
          String audioName="audio-${uuid.v4()}";
          print("audio name: $audioName");
          String url= await CommonFunctions().uploadMp3(file);

          MediaItem? media = MediaItem(
            mediaUrl: url,
            durationInSecond: audioDuration,
          );
          print("audio url is: $url");
          print("media type model: ${media.toMap()}");
          await chatProvider?.sendMessageToUserMethod(
              context,
              messageTextController.text,
              "audio",
              media,
              userDetail?.uid??"",
              widget.userModel.uid??"",
            widget.userModel.deviceToken!
          );

          _scrollDown();

        }

        setState(() {});
      } catch (ex) {
        print("Exception send recording........");
        stopTimer();
        stopRecord();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "something went wrong, please try again"),
        ));
      }
    }else{
      startRecording = false;
      _start = 0;
      _timer?.cancel();
      stopRecord();
      showDialog(
          context: context,
          //barrierDismissible: false,

          builder: (BuildContext context) {
            return ApplicationAlertDialogue(
              dialogueHeight: 250,
              imageWidth: 100,
              imageHeight: 100,
              buttonText: "Try Again",
              imagePath: "assets/images/error_icon.png",
              title: "Internet Connection!",
              titleStyle: blackTextBoldIn25px(),
              description: "please check your internet connection.",
              descriptionStyle: greyTextRegularIn16px(),
              richTextFlag: false,
              cancelBtnVisible: false,
              crossBtnVisible: false,
              onTap: () async {
                Navigator.pop(context, true);
              },
            );
          });
    }
  }
}
