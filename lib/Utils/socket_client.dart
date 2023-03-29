import "package:socket_io_client/socket_io_client.dart" as IO;

class SocketClient {
  IO.Socket? socket;

  static SocketClient? _instance;

  SocketClient.internal() {
    print("Initializing Socket Client");
    socket = IO.io("http://192.168.1.36:4000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": true,
    });

    socket!.connect();
  }

  static SocketClient get instance {
    _instance ??= SocketClient.internal();
    return _instance!;
  }
}