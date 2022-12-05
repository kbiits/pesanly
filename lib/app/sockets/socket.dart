import 'package:nylo_framework/nylo_framework.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketManager {
  late final String baseUrl;
  late Socket? socket;

  SocketManager() {
    this.baseUrl = getEnv("API_BASE_URL");
  }
  void connect() {
    if (socket != null) {
      return;
    }

    socket = io(this.baseUrl + "/ws/connect");
    socket!.onConnect((data) {
      print("connected");
    });
  }
}
