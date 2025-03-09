int redLed = 12;
int greenLed = 11;
int buzzer = 10;
int smokeA0 = A5;
int sensorThres = 400;
int bluetoothTx = 9;  // Conectează TX modul Bluetooth la pinul 9 al Arduino
int bluetoothRx = 8;  // Conectează RX modul Bluetooth la pinul 8 al Arduino

void setup() {
  pinMode(redLed, OUTPUT);
  pinMode(greenLed, OUTPUT);
  pinMode(buzzer, OUTPUT);
  pinMode(smokeA0, INPUT);
  Serial.begin(9600);
  Serial1.begin(9600);  // Inițializează comunicarea serială pentru modulul Bluetooth
}

void loop() {
  int analogSensor = analogRead(smokeA0);

  Serial.print("Pin A0: ");
  Serial.println(analogSensor);

  if (Serial1.available() > 0) {
    char command = Serial1.read();
    handleBluetoothCommand(command);
  }

  if (analogSensor > sensorThres) {
    digitalWrite(redLed, HIGH);
    digitalWrite(greenLed, LOW);
    tone(buzzer, 1000, 200);
  } else {
    digitalWrite(redLed, LOW);
    digitalWrite(greenLed, HIGH);
    noTone(buzzer);
  }

  delay(100);
}

void handleBluetoothCommand(char command) {
  switch (command) {
    case 'H':
      // Increase threshold or perform other actions
      sensorThres += 10;
      Serial.println("Increased threshold");
      break;
    case 'L':
      // Decrease threshold or perform other actions
      sensorThres -= 10;
      Serial.println("Decreased threshold");
      break;
    // Add more cases as needed for other commands
  }
}
