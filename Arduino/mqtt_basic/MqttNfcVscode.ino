#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <SPI.h>
#include <PN532_SPI.h>
#include "PN532.h"
#include "emulatetag.h"
#include "NdefMessage.h"
#include <ESP8266Firebase.h>

PN532_SPI pn532spi(SPI, 4);
EmulateTag nfc(pn532spi);
int flag = 0;
int count =0;


// WiFi
const char *ssid = "CLARO_2G6BFDAB"; // Enter your WiFi name
const char *password = "546BFDAB";  // Enter WiFi password

const char *mqtt_broker = "broker.emqx.io";
const char *topic = "JB1";
//const char *mqtt_username = "emqx";
//const char *mqtt_password = "public";
const int mqtt_port = 1883;

WiFiClient espClient;
PubSubClient client(espClient);

void reconnect() {
  // Loop until we're reconnected
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    // Attempt to connect
    if (client.connect("arduinoClient")) {
      Serial.println("connected");
      // Once connected, publish an announcement...
      client.subscribe(topic);
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      // Wait 5 seconds before retrying
      delay(5000);
    }
  }
}


void callback(char *topic, byte *payload, unsigned int length) {
  Serial.print("Message arrived in topic: ");
  Serial.println(topic);
  Serial.print("Message:");
  
  String S;
  for (int i = 0; i < length; i++) {
      S+= (char) payload[i]; // convertendo payload em string para manipular
  }
  Serial.println(S);
  if(S=="True"){
    flag += 1;
    turn_Led();
  }
  Serial.println("-----------------------");
}


void turn_Led(){
  Serial.println("-----Ligando Led-------");
  digitalWrite(LED_BUILTIN, LOW);   // turn the LED on (HIGH is the voltage level)
  delay(3000);                       // wait for a second
  digitalWrite(LED_BUILTIN, HIGH);
  }


void setup() {
  // Set software serial baud to 115200;
  Serial.begin(115200);
  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, HIGH);
  // connecting to a WiFi network
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
      delay(500);
      Serial.println("Connecting to WiFi..");
  }
  Serial.println("Connected to the WiFi network");
  //connecting to a mqtt broker
  client.setServer(mqtt_broker, mqtt_port);
  client.setCallback(callback);
  while (!client.connected()) {
      String client_id = "esp8266-client-";
      client_id += String(WiFi.macAddress());
      Serial.printf("The client %s connects to the public mqtt broker\n", client_id.c_str());
      if (client.connect(client_id.c_str(), "", "")) {
          Serial.println("Public emqx mqtt broker connected");
      } else {
          Serial.print("failed with state ");
          Serial.print(client.state());
          delay(2000);
      }
  }
  // subscribe
  client.subscribe(topic);

}



void loop() {
  Serial.println("-----Entrou MQTT Loop-------");
  if (!client.connected()) {
    reconnect();
  }
  client.loop();
  loopnfc();
}

void loopnfc() {
  Serial.println("-----Entrou Loop NFC-------");
  Serial.println(flag);
  if(flag==1){
      uint8_t uid[3] = { 0x33, 0x33, 0x33 };
      nfc.setUid(uid);
      nfc.init();
      count++;
    }else if (flag>2)
    {
      uint8_t uid[3] = { 0x77, 0x77, 0x77 };
      nfc.setUid(uid);
      nfc.init();
    }
    else{
      uint8_t uid[3] = { 0x34, 0x34, 0x56 };
      nfc.setUid(uid);
      nfc.init();
    }  
  if(!nfc.emulate(1000)){
      Serial.println("timed out");
     }
  
     
}