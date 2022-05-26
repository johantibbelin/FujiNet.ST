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

//*** Variables
uint8_t data = 0;


//** Functions
uint8_t read_dataport() {
  uint8_t dport[] = {D0, D1, D2, D3 ,D4 ,D5, D6, D7};  
  uint8_t d=0;
  for (int i=0;i<8;i++) {
    d = d | (digitalRead(dport[i]) << i);
  }

  return d;
}
void setup() {
  // Setup serial
  Serial.begin(9600);
  
  //** Setup pins

  //* PINs always in input mode
  pinMode(ST_RESET, INPUT);  
  pinMode(RW, INPUT);
  pinMode(CS, INPUT);
  pinMode(A1, INPUT);
  pinMode(ACK, INPUT);

//* PINs always in output mode
  pinMode(LED, OUTPUT);
  pinMode(IRQ, OUTPUT);
  pinMode(HDRQ,OUTPUT);
  
  //* Data PINs (Starts as input)
  pinMode(D0, INPUT);
  pinMode(D1, INPUT);
  pinMode(D2, INPUT);
  pinMode(D3, INPUT);
  pinMode(D4, INPUT);
  pinMode(D5, INPUT);
  pinMode(D6, INPUT);
  pinMode(D7, INPUT);


  // Turn off LED
  digitalWrite(LED, LOW);
  
  //Set IRQ high (active low)
  digitalWrite(IRQ, HIGH); 
}

void loop() {
  // put your main code here, to run repeatedly:
 data = read_dataport();
 Serial.println(data);
 delay(250); 
}