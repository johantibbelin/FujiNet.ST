#include <Arduino.h>

void setup() {
  // put your setup code here, to run once:
  pinMode(GPIOR10,INPUT);
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  analogRead(A0);
  Serial.println(A0);
  delay(1000);
}