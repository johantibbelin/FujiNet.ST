#include <Arduino.h>

//** PIN defines

//* Signal PINs
#define IRQ 5
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
#define D3 12
#define D4 32
#define D5 18
#define D6 19
#define D7 21

//* Non ACSI PINs
#define LED 23

/**
 * IRQ delay
 * Delay between IRQ going low and then high again (in microseconds).
 */
#define IRQ_DELAY 15000

//*** Variables
uint8_t data = 0;
uint8_t last_data = 0;
int8_t last_a1 = -1;
//** Dataport
uint8_t dport[] = {D0, D1, D2, D3 ,D4 ,D5, D6, D7};  
uint8_t command;
//** Inquery response
static unsigned char inquiry_bytes[] =
{
	0,                /* device type 0 = direct access device */
	0,                /* device type qualifier (nonremovable) */
	1,                /* ACSI/SCSI version */
	0,                /* reserved */
	31,               /* length of the following data */
	0, 0, 0,          /* Vendor specific data */
	'A','C','S','I','2','E','S','P',    /* Vendor ID */
	'3','2',' ','h','a','r','d','d',    /* Product ID 1 */
	'r','i','v','e',' ','1','.','2',    /* Product ID 2 */
	'M','B',' ',' ',                    /* Revision */
}; 
//** Functions

/**
 * @brief reads the ACSI data bus
 * 
 * @return uint8_t 
 */
uint8_t read_dataport() {
  uint8_t d=0;
  for (int i=0;i<8;i++) {
    d = d | (digitalRead(dport[i]) << i);
  }

  return d;
}
void send_irq() {
  digitalWrite(IRQ, LOW);
  
}
/**
 * @brief Interrupt routine, activates when CS goes low.
 * 
 */
void IRAM_ATTR cs_interrupt() {
  last_data = read_dataport();
  last_a1 = digitalRead(A1);
  if (last_a1 == LOW) {}
  digitalWrite(IRQ, LOW);
  delayMicroseconds(IRQ_DELAY);
  digitalWrite(IRQ, HIGH);
}

void IRAM_ATTR rw_interrupt_read() {
  pinMode(D0, OUTPUT);
  pinMode(D1, OUTPUT);
  pinMode(D2, OUTPUT);
  pinMode(D3, OUTPUT);
  pinMode(D4, OUTPUT);
  pinMode(D5, OUTPUT);
  pinMode(D6, OUTPUT);
  pinMode(D7, OUTPUT);
 
}
void IRAM_ATTR rw_interrupt_write() {
  pinMode(D0, INPUT);
  pinMode(D1, INPUT);
  pinMode(D2, INPUT);
  pinMode(D3, INPUT);
  pinMode(D4, INPUT);
  pinMode(D5, INPUT);
  pinMode(D6, INPUT);
  pinMode(D7, INPUT);
 
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
  // Set low in order to not rearange board.
  pinMode(35,OUTPUT);
  digitalWrite(35, LOW);
  
  //* Data PINs (Starts as input)
  pinMode(D0, INPUT);
  pinMode(D1, INPUT);
  pinMode(D2, INPUT);
  pinMode(D3, INPUT);
  pinMode(D4, INPUT);
  pinMode(D5, INPUT);
  pinMode(D6, INPUT);
  pinMode(D7, INPUT);
  pinMode(IRQ, OUTPUT);

  // Turn off LED
  digitalWrite(LED, LOW);
  
  //Set IRQ high (active low)
  digitalWrite(IRQ, HIGH); 
// setup interrupt
attachInterrupt(CS, cs_interrupt, FALLING);

attachInterrupt(RW, rw_interrupt_read, RISING);
attachInterrupt(RW, rw_interrupt_write, FALLING);
}

void loop() {
 // Recive packet
 Serial.print("Last byte:");
 Serial.println(last_data);
 if (last_a1 != -1) {
   Serial.print("Last A1:");
   Serial.println(last_a1);
 }
 delay(1000);
}