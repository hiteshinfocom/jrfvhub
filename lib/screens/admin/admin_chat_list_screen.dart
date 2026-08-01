import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/chat_service.dart';
import 'admin_chat_screen.dart';

class AdminChatListScreen extends StatefulWidget {
  const AdminChatListScreen({super.key});

  @override
  State<AdminChatListScreen> createState() =>
      _AdminChatListScreenState();
}

class _AdminChatListScreenState
    extends State<AdminChatListScreen> {

  List rooms = [];
  List filteredRooms = [];

  bool loading = true;

  final TextEditingController searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    loadRooms();
  }

  Future<void> loadRooms() async {

    try {

      final data =
          await ChatService().getAdminRooms();

      rooms = data;
      filteredRooms = data;

    } catch (e) {

      debugPrint(e.toString());

    }

    setState(() {
      loading = false;
    });
  }

  void search(String value) {

    setState(() {

      filteredRooms = rooms.where((e) {

        final vendor =
            (e["vendor_name"] ?? "")
                .toString()
                .toLowerCase();

        final department =
            (e["department"] ?? "")
                .toString()
                .toLowerCase();

        return vendor.contains(
                  value.toLowerCase(),
                ) ||
            department.contains(
              value.toLowerCase(),
            );

      }).toList();

    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Support Tickets",
        ),
        centerTitle: true,
      ),

      body: Column(

        children: [

          Padding(

            padding:
                const EdgeInsets.all(15),

            child: TextField(

              controller: searchController,

              onChanged: search,

              decoration: InputDecoration(

                hintText:
                    "Search Vendor...",

                prefixIcon:
                    const Icon(Icons.search),

                filled: true,

                fillColor:
                    Colors.grey.shade100,

                border:
                    OutlineInputBorder(

                  borderRadius:
                      BorderRadius.circular(
                    30,
                  ),

                  borderSide:
                      BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(

            child: loading

                ? const Center(
                    child:
                        CircularProgressIndicator(),
                  )

                : filteredRooms.isEmpty

                    ? const Center(
                        child: Text(
                          "No Tickets Found",
                        ),
                      )

                    : RefreshIndicator(

                        onRefresh: loadRooms,

                        child: ListView.builder(

                          itemCount:
                              filteredRooms.length,

                          itemBuilder:
                              (context, index) {

                            final room =
                                filteredRooms[index];

                            return Card(

                              margin:
                                  const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),

                              child: ListTile(

                                leading:
                                    CircleAvatar(

                                  backgroundColor:
                                      Colors.blue.shade100,

                                  child: const Icon(
                                    Icons.support_agent,
                                  ),
                                ),

                                title: Text(

                                  room["vendor_name"] ??
                                      "",

                                  style:
                                      const TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                subtitle: Column(

                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,

                                  children: [

                                    Text(
                                      room["department"] ??
                                          "",
                                    ),

                                    const SizedBox(
                                      height: 4,
                                    ),

                                    Text(
                                      room["last_message"] ??
                                          "",
                                      maxLines: 1,
                                      overflow:
                                          TextOverflow.ellipsis,
                                    ),

                                  ],
                                ),

                                trailing: Column(

                                  mainAxisAlignment:
                                      MainAxisAlignment.center,

                                  children: [

                                    if ((room["unread_admin"] ??
                                            0) >
                                        0)

                                      CircleAvatar(

                                        radius: 10,

                                        backgroundColor:
                                            Colors.red,

                                        child: Text(

                                          room["unread_admin"]
                                              .toString(),

                                          style:
                                              const TextStyle(
                                            color:
                                                Colors.white,
                                            fontSize:
                                                11,
                                          ),
                                        ),
                                      ),

                                    const SizedBox(
                                      height: 5,
                                    ),

                                    Text(

                                      room["status"] ??
                                          "Open",

                                      style:
                                          const TextStyle(
                                        fontSize: 10,
                                      ),
                                    ),

                                  ],
                                ),

                                onTap: () {

                                  Get.to(

                                    () =>
                                        AdminChatScreen(

                                      roomId:
                                          room["id"],

                                      adminId:
                                          room["vendor_id"],

                                      title:
                                          room["vendor_name"],

                                    ),

                                  );

                                },
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}