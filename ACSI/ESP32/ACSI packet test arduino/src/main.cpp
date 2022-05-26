#include <Arduino.h>

//** PIN defines

//* Signal PINs
#define IRQ 35
#define CS 34
#define HDRQ 33
#define ACK 27
#define ST_RESET 22
#define RW 25
#define A1 26

//* Data PINs
#define D0 13
#define D1 14
#define D2 15
#define D3 16
#define D4 17
#define D5 18
#define D6 19
#define D7 21

//* Non ACSI PINs
#define LED 23


void setup() {
  // Setup serial
  Serial.begin(9600);
  
  //** Setup pins
  pinMode(LED, OUTPUT);
  pinMode(ST_RESET, INPUT);  
  pinMode(IRQ, OUTPUT);
  
  pinMode(D0, INPUT);
  pinMode(D1, INPUT);
  pinMode(D2, INPUT);
  pinMode(D3, INPUT);
  pinMode(D4, INPUT);
  pinMode(D5, INPUT);
  pinMode(D6, INPUT);
  pinMode(D7, INPUT);
  pinMode(RW, INPUT);
  pinMode(12, OUTPUT);

  digitalWrite(LED, LOW);
  digitalWrite(IRQ, HIGH); 
}

void loop() {
  // put your main code here, to run repeatedly:
}