import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/chat_service.dart';
import 'chat_screen.dart';

class ChatRoomScreen
    extends StatefulWidget {

  final int vendorId;

  const ChatRoomScreen({
    super.key,
    required this.vendorId,
  });

  @override
  State<ChatRoomScreen>
      createState() =>
          _ChatRoomScreenState();
}

class _ChatRoomScreenState
    extends State<ChatRoomScreen> {

  List rooms = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadRooms();
  }

  Future<void> loadRooms() async {

    final data =
        await ChatService()
            .getRooms(
      widget.vendorId,
    );

    setState(() {

      rooms = data;

      loading = false;
    });
  }

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title:
            const Text("My Chats"),
      ),

      body: loading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : ListView.builder(

              itemCount:
                  rooms.length,

              itemBuilder:
                  (context, index) {

                final room =
                    rooms[index];

                return ListTile(

                  leading:
                      const CircleAvatar(
                    child: Icon(
                      Icons.support_agent,
                    ),
                  ),

                  title: Text(
                    room[
                        "department"],
                  ),

                  subtitle: Text(
                    room[
                            "last_message"] ??
                        "",
                  ),

                  trailing: room[
                              "unread_vendor"] >
                          0
                      ? CircleAvatar(
                          radius: 10,
                          child: Text(
                            room[
                                    "unread_vendor"]
                                .toString(),
                          ),
                        )
                      : null,

                  onTap: () {

                    Get.to(
                      () => ChatScreen(
                        title: room[
                            "department"],
                        roomId:
                            room["id"],
                        vendorId:
                            widget
                                .vendorId,
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
