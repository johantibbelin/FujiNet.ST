#include <Arduino.h>

#define LED 23
#define ST_RESET 22
int i = 0;
int reset=0;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(LED, OUTPUT);
  pinMode(ST_RESET, INPUT);  
  digitalWrite(LED, LOW);
  
}

void loop() {
  
  if (digitalRead(ST_RESET) == LOW && reset == 0) {
    Serial.println("ST was reseted!");
    i++;
    Serial.print("Number of resets: ");Serial.println(i);
    reset =1;
    digitalWrite(LED,HIGH);
    delay(2000);
    while (ST_RESET == LOW) {
      delay(100);
    }
    reset = 0;
    digitalWrite(LED, LOW);
  }
  /*digitalWrite(LED, HIGH);
  delay(1000);
  digitalWrite(LED, LOW);
  delay(1000);*/
}