import "package:socket_io_client/socket_io_client.dart" as IO;

class SocketClient {
  IO.Socket? socket;

  static SocketClient? _instance;

  SocketClient.internal(String tokenId, String accessToken) {
    print("Initializing Socket Client");
    socket = IO.io("http://192.168.1.37:4000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": true,
      "query": "fcmToken=$tokenId&accessToken=$accessToken"
    });

    print(socket!.id);

    socket!.connect();
  }

  static SocketClient instance(String tokenId, String accessToken) {
    _instance ??= SocketClient.internal(tokenId, accessToken);
    return _instance!;
  }

  static SocketClient get staticInstance {
    return _instance!;
  }
}
