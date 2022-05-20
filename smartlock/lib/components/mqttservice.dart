import 'package:flutter/cupertino.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class mqttservice with ChangeNotifier {
  void connect() async {
    MqttServerClient client =
        MqttServerClient.withPort('broker.emqx.io', 'flutter_client', 1883);

    final connMessage = MqttConnectMessage()
        .authenticateAs('username', 'password')
        .withWillTopic('willtopic')
        .withWillMessage('Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    client.connectionMessage = connMessage;
    try {
      await client.connect();
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }

    const pubTopic = 'topic/open/#';
    final builder = MqttClientPayloadBuilder();
    builder.addString('True');
    client.publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload!);
    client.disconnect();
  }
}
