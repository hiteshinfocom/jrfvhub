import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService instance = SocketService._internal();

  factory SocketService() => instance;

  SocketService._internal();

  IO.Socket? socket;

  int? currentRoomId;

  bool get isConnected =>
      socket != null && socket!.connected;

  void connect() {
    if (socket != null && socket!.connected) {
      return;
    }

    socket = IO.io(
      "http://103.81.116.172:3000",
      IO.OptionBuilder()
          .setTransports(["websocket"])
          .enableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(999999)
          .setReconnectionDelay(1000)
          .build(),
    );

    socket!.connect();

    socket!.onConnect((_) {
      print("✅ Socket Connected");

      if (currentRoomId != null) {
        joinRoom(currentRoomId!);
      }
    });

    socket!.onDisconnect((_) {
      print("❌ Socket Disconnected");
    });

    socket!.onConnectError((data) {
      print("Connect Error : $data");
    });

    socket!.onError((data) {
      print("Socket Error : $data");
    });
  }

  void joinRoom(int roomId) {
    currentRoomId = roomId;

    if (socket != null && socket!.connected) {
      socket!.emit("joinRoom", roomId);
      print("Joined Room : $roomId");
    }
  }

    void registerUser(int userId) {
    socket?.emit("register", {
      "userId": userId,
    });
  }

  void onUserOnline(Function(dynamic) callback) {
    socket?.off("userOnline");
    socket?.on("userOnline", callback);
  }

  void onUserOffline(Function(dynamic) callback) {
    socket?.off("userOffline");
    socket?.on("userOffline", callback);
  }

  void typing(int roomId) {
    socket?.emit("typing", {
      "room_id": roomId,
    });
  }

  void onTyping(Function(dynamic) callback) {
    socket?.off("typing");
    socket?.on("typing", callback);
  }

  void sendMessage(Map<String, dynamic> data) {
    if (socket != null && socket!.connected) {
      socket!.emit("sendMessage", data);
    }
  }

  void onNewMessage(Function(dynamic) callback) {
    socket?.off("newMessage");
    socket?.on("newMessage", callback);
  }

  void disconnect() {
    socket?.disconnect();
    socket?.dispose();
    socket = null;
  }
}