import 'package:flutter/cupertino.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class mqttservice with ChangeNotifier {
  Future<MqttServerClient> connect(String Nome) async {
    MqttServerClient client =
        MqttServerClient.withPort('broker.emqx.io', 'flutter_client', 1883);
    print('entrou');
    final connMessage = MqttConnectMessage()
        .withWillTopic('willtopic')
        .withWillMessage('Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce)
        .withClientIdentifier('flutter_client');
    print('saiu conmessage');
    client.connectionMessage = connMessage;
    try {
      await client.connect();
      print('conectou');
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }
    print(client.connectionStatus);
    final builder = MqttClientPayloadBuilder();
    builder.addUTF8String('True');
    client.publishMessage(Nome, MqttQos.atLeastOnce, builder.payload!);

    print('publicou');
    client.disconnect();
    return client;
  }
}
