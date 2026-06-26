import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'full_image_screen.dart';
import 'package:open_filex/open_filex.dart';
import '../../services/socket_service.dart';
import '../../services/api_service.dart';
import '../../config/server_config.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';

class ChatScreen extends StatefulWidget {
  final String title;
  final int roomId;
  final int vendorId;

  const ChatScreen({
    super.key,
    required this.title,
    required this.roomId,
    required this.vendorId,
  });

  @override
  State<ChatScreen> createState() =>
      _ChatScreenState();
}

class _ChatScreenState
    extends State<ChatScreen> {

  final TextEditingController controller =
      TextEditingController();

  final ScrollController scrollController =
      ScrollController();

  List<Map<String, dynamic>> messages =
      [];
  bool isOnline = false;
  bool isTyping = false;

  Future<void> uploadFile(
      String filePath,
    ) async {
      try {

    FormData formData =
        FormData.fromMap({

      "room_id": widget.roomId,

      "sender_type": "Vendor",

      "sender_id": widget.vendorId,

      "file":
          await MultipartFile.fromFile(
        filePath,
      ),
    });

    final response =
        await Dio().post(
      "${ServerConfig.baseUrl}/upload_file.php",
      data: formData,
    );

    debugPrint(
      response.data.toString(),
    );

    if (response.data != null &&
    response.data["status"] == true) {

  SocketService.instance.sendMessage({

    "room_id": widget.roomId,

    "sender_type": "Vendor",

    "sender_id": widget.vendorId,

    "message":
        response.data["file"],

    "message_type":
        response.data["message_type"] ??
        "file",
  });

  scrollBottom();
}

  } catch (e) {

    debugPrint(
      "UPLOAD ERROR : $e",
    );
  }
}

  @override
  void initState() {
    super.initState();

    loadMessages(); // ADD

    SocketService.instance.connect();

    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        SocketService.instance.joinRoom(widget.roomId);
      },
    );

    SocketService.instance.registerUser(widget.vendorId);

    SocketService.instance.onUserOnline((_) {
      if (!mounted) return;
      setState(() {
        isOnline = true;
      });
    });

    SocketService.instance.onUserOffline((_) {
      if (!mounted) return;
      setState(() {
        isOnline = false;
      });
    });

    SocketService.instance.onTyping((_) {

      if (!mounted) return;

      setState(() {
        isTyping = true;
      });

      Future.delayed(const Duration(seconds: 2), () {

        if (!mounted) return;

        setState(() {
          isTyping = false;
        });

      });

    });

    SocketService.instance.onNewMessage((data) {

      if (data["room_id"] != widget.roomId) {
        return;
      }

      if (!mounted) return;

      setState(() {

        messages.add({

          "text": data["message"] ?? "",

          "isMe": data["sender_type"] == "Vendor",

          "time": data["created_at"] ??
              DateTime.now().toString(),

          "type": data["message_type"] ?? "text",

        });

      });

      scrollBottom();

    });
  }

  void scrollBottom() {

    Future.delayed(
      const Duration(
          milliseconds: 100),
      () {

        if (scrollController
            .hasClients) {

          scrollController.animateTo(
            scrollController.position
                .maxScrollExtent,

            duration:
                const Duration(
              milliseconds: 300,
            ),

            curve: Curves.easeOut,
          );
        }
      },
    );
  }

  void sendMessage() {

  final text =
      controller.text.trim();

  if (text.isEmpty) return;

  SocketService.instance.sendMessage({
  "room_id": widget.roomId,
  "sender_type": "Vendor",
  "sender_id": widget.vendorId,
  "message": text,
  "message_type": "text",
});

  controller.clear();
}

  @override
  void dispose() {

    SocketService.instance
        .disconnect();

    controller.dispose();

    scrollController.dispose();

    super.dispose();
  }

  Widget attachmentItem(
  IconData icon,
  String title,
  VoidCallback onTap,
) {

  return InkWell(

    onTap: () {

      Navigator.pop(context);
      onTap();
    },

    child: SizedBox(

      width: 90,

      child: Column(

        mainAxisSize: MainAxisSize.min,

        children: [

          CircleAvatar(
            radius: 28,
            child: Icon(icon),
          ),

          const SizedBox(height: 8),

          Text(
            title,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(
        0xfff5f7fb,
      ),

      appBar: AppBar(

        elevation: 0,

        backgroundColor:
            Colors.white,

        foregroundColor:
            Colors.black,

        title: Column(

          crossAxisAlignment:
              CrossAxisAlignment
                  .start,

          children: [

            Text(
              widget.title,
              style:
                  const TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 2,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [

                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isOnline ? Colors.green : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 5),

                    Text(
                      isOnline ? "Online" : "Offline",
                      style: const TextStyle(
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),

                if (isTyping)
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Text(
                      "Typing...",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            )
          ],
        ),
      ),

      body: Column(

        children: [

          Expanded(

            child:
                ListView.builder(

              controller:
                  scrollController,

              padding:
                  const EdgeInsets
                      .all(16),

              itemCount:
                  messages.length,

              itemBuilder:
                  (context,
                      index) {

                final msg =
                    messages[
                        index];

                final isMe =
                    msg["isMe"];

                final isFile =
                    msg["type"] == "file";

                final fileName =
                    msg["text"]
                        .toString()
                        .toLowerCase();

                final isImage =
                    fileName.endsWith(".jpg") ||
                    fileName.endsWith(".jpeg") ||
                    fileName.endsWith(".png");

                return Align(

                  alignment: isMe
                      ? Alignment
                          .centerRight
                      : Alignment
                          .centerLeft,

                  child:
                      Container(

                    constraints:
                        const BoxConstraints(
                      maxWidth:
                          280,
                    ),

                    margin:
                        const EdgeInsets
                            .only(
                      bottom: 10,
                    ),

                    padding:
                        const EdgeInsets
                            .all(
                      12,
                    ),

                    decoration:
                        BoxDecoration(

                      color: isMe
                          ? const Color(
                              0xff2563eb)
                          : Colors
                              .white,

                      borderRadius:
                          BorderRadius
                              .circular(
                        18,
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: Colors
                              .black12,
                          blurRadius:
                              4,
                        ),
                      ],
                    ),

                    child:
                        Column(

                      crossAxisAlignment:
                          CrossAxisAlignment
                              .end,

                      children: [

                    isImage
                        ? ClipRRect(
                            borderRadius:
                                BorderRadius.circular(12),
                            child: GestureDetector(
                              onTap: () {

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        FullImageScreen(
                                      imageUrl:
                                          "${ServerConfig.baseUrl}/${msg["text"]}",
                                    ),
                                  ),
                                );
                              },

                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(12),

                                child: Image.network(
                                  "${ServerConfig.baseUrl}/${msg["text"]}",
                                  width: 180,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          )

                        : isFile
                            ? GestureDetector(
                                onTap: () {
                                  OpenFilex.open(
                                    msg["text"],
                                  );
                                },
                                child: Row(
                                  mainAxisSize:
                                      MainAxisSize.min,
                                  children: [

                                    Icon(
                                      Icons.attach_file,
                                      color: isMe
                                          ? Colors.white
                                          : Colors.black,
                                    ),

                                    const SizedBox(
                                      width: 5,
                                    ),

                                    Flexible(
                                      child: Text(
                                        p.basename(
                                          msg["text"],
                                        ),
                                        overflow:
                                            TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: isMe
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )

                            : Text(
                                msg["text"],
                                style: TextStyle(
                                  color: isMe
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),

                              const SizedBox(
                                height: 4,
                              ),

                              Text(
                                formatTime(
                                  msg["time"],
                                ),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isMe
                                      ? Colors.white70
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Container(

                  padding:
                      const EdgeInsets
                          .all(10),

                  color:
                      Colors.white,

                  child: Row(

                    children: [

                      IconButton(
                        onPressed: showAttachmentSheet,
                        icon: const Icon(Icons.attach_file),
                      ),

                      Expanded(

                        child:
                            TextField(

                          controller: controller,

                          minLines: 1,

                          maxLines: 4,

                          onChanged: (_) {
                            SocketService.instance.typing(widget.roomId);
                          },

                          decoration: InputDecoration(

                            hintText: "Type message...",

                            filled: true,

                            fillColor: Colors.grey.shade100,

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 8,
                      ),

                      CircleAvatar(

                        radius: 24,

                        backgroundColor:
                            const Color(
                          0xff2563eb,
                        ),

                        child:
                            IconButton(

                          onPressed:
                              sendMessage,

                          icon:
                              const Icon(
                            Icons.send,
                            color:
                                Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        
  void showAttachmentSheet() {

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25),
      ),
    ),
    builder: (context) {

      return Padding(
        padding: const EdgeInsets.all(20),

        child: Wrap(

          spacing: 20,
          runSpacing: 20,

          children: [

            attachmentItem(
              Icons.image,
              "Gallery",
              pickImage,
            ),

            attachmentItem(
              Icons.camera_alt,
              "Camera",
              openCamera,
            ),

            attachmentItem(
              Icons.picture_as_pdf,
              "PDF",
              pickFile,
            ),

            attachmentItem(
              Icons.description,
              "Document",
              pickFile,
            ),

            attachmentItem(
              Icons.video_file,
              "Video",
              pickFile,
            ),

            attachmentItem(
              Icons.location_on,
              "Location",
              () {},
            ),
          ],
        ),
      );
    },
  );
}

Future<void> pickImage() async {
  final picker = ImagePicker();

  final file = await picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 80,
  );

  if (file != null) {
    await uploadFile(file.path);
  }
}

Future<void> openCamera() async {
  final picker = ImagePicker();

  final file = await picker.pickImage(
    source: ImageSource.camera,
    imageQuality: 80,
  );

  if (file != null) {
    await uploadFile(file.path);
  }
}

  Future<void> pickFile() async {

    FilePickerResult? result =
        await FilePicker.platform.pickFiles();

    if (result == null) return;

    String filePath =
        result.files.single.path!;

    await uploadFile(filePath);
  }

  Future<void> loadMessages() async {
  try {

    final response = await ApiService.get(
      "get_messages.php?room_id=${widget.roomId}",
    );

    debugPrint(
      "CHAT RESPONSE = $response",
    );

    if (response != null &&
        response["status"] == true) {

      messages.clear();

      for (var msg in response["messages"]) {

        messages.add({
          "text": msg["message"] ?? "",
          "isMe": msg["sender_type"] == "Vendor",
          "time": msg["created_at"] ?? "",
          "type": msg["message_type"] ?? "text",
        });
      }

      setState(() {});

      scrollBottom();
    }

  } catch (e) {

    debugPrint(
      "LOAD CHAT ERROR : $e",
    );
  }
}
String formatTime(
  String? dateTime,
) {

  if (dateTime == null ||
      dateTime.isEmpty) {
    return "";
  }

  try {

    final dt =
        DateTime.parse(
      dateTime,
    );

    return DateFormat(
      "hh:mm a",
    ).format(dt);

  } catch (e) {

    return "";
  }
}
}
