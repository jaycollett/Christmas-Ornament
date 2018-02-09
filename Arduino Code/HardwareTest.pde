//*********************************************************************************//
//
// Name:     Christmas Orniment Hardware Test Sketch
// Author:   Jay Collett
// Date:     November 15, 2010
// Version:  1.0
//
// Notes:    This is a sketch to test the hardware of the Christmas Orniment boards
//           after assembly.
//
//*********************************************************************************//

// setup 595 pins
int latchPin = 8;
int clockPin = 10;
int dataPin = 11;

// setup led pins on neck of orniment
int whiteLedPin1 = 0;
int whiteLedPin2 = 2;
int blueLedPin1 = 1;
int blueLedPin2 = 3;

// holder for data that is going to be passed to the shifting function

byte dataArrayRed[10];
byte dataArrayGreen[10];


void setup(){

  Serial.begin(9600);

  pinMode(latchPin, OUTPUT);
  pinMode(clockPin, OUTPUT);
  pinMode(dataPin, OUTPUT);


  pinMode(whiteLedPin1, OUTPUT);
  pinMode(whiteLedPin2, OUTPUT);
  pinMode(blueLedPin1, OUTPUT);
  pinMode(blueLedPin2, OUTPUT);

  dataArrayRed[0] = 0x00; //00000000
  dataArrayRed[1] = 0xFF; //11111111
  dataArrayRed[2] = 0x80; //10000000
  dataArrayRed[3] = 0x40; //01000000
  dataArrayRed[4] = 0x20; //00100000
  dataArrayRed[5] = 0x10; //00010000
  dataArrayRed[6] = 0x08; //00001000
  dataArrayRed[7] = 0x04; //00000100
  dataArrayRed[8] = 0x02; //00000010
  dataArrayRed[9] = 0x01; //00000001
  

  dataArrayGreen[0] = 0x00; //00000000
  dataArrayGreen[1] = 0xFF; //11111111
  dataArrayGreen[2] = 0x80; //10000000
  dataArrayGreen[3] = 0x40; //01000000
  dataArrayGreen[4] = 0x20; //00100000
  dataArrayGreen[5] = 0x10; //00010000 
  dataArrayGreen[6] = 0x08; //00001000
  dataArrayGreen[7] = 0x04; //00000100
  dataArrayGreen[8] = 0x02; //00000010 
  dataArrayGreen[9] = 0x01; //00000001 

}

void loop(){

  // first test the blue and white leds....
//  delay(1000);
//  Serial.println("White LED 1 ON");
//  digitalWrite(whiteLedPin1, HIGH);
//  delay(1000);
//  Serial.println("White LED 1 OFF");
//  digitalWrite(whiteLedPin1, LOW);
//  Serial.println("Blue LED 1 ON");
//  digitalWrite(blueLedPin1, HIGH);
//  delay(1000);
//  Serial.println("Blue LED 1 OFF");
//  digitalWrite(blueLedPin1, LOW);
//  Serial.println("White LED 2 ON");
//  digitalWrite(whiteLedPin2, HIGH);
//  delay(1000);
//  Serial.print("White LED 2 OFF");
//  digitalWrite(whiteLedPin2, LOW);
//  Serial.println("Blue LED 2 ON");
//  digitalWrite(blueLedPin2, HIGH);
//  delay(1000);
//  Serial.println("Blue LED 2 OFF");
//  digitalWrite(blueLedPin2, LOW);
//  delay(1000);

  // now test the red and green leds, turn on all red, wait, then turn on all green
  Serial.println("Red LED Array ON");
  digitalWrite(latchPin, LOW);
  shiftOut(dataPin, clockPin, dataArrayGreen[0]);
  shiftOut(dataPin, clockPin, dataArrayRed[1]);
  digitalWrite(latchPin, HIGH);
  delay(2000);
  Serial.println("Red LED Array OFF");

  Serial.println("Green LED Array ON");
  digitalWrite(latchPin, LOW);
  shiftOut(dataPin, clockPin, dataArrayGreen[1]);
  shiftOut(dataPin, clockPin, dataArrayRed[0]);
  digitalWrite(latchPin, HIGH);
  delay(2000);

  Serial.println("Green LED Array OFF");
  digitalWrite(latchPin, LOW);
  shiftOut(dataPin, clockPin, dataArrayGreen[0]);
  shiftOut(dataPin, clockPin, dataArrayRed[0]);
  digitalWrite(latchPin, HIGH);

  // now red one at a time followed by green one at a time
  for(int j=2;j<10;j++){
    digitalWrite(latchPin, LOW);
    shiftOut(dataPin, clockPin, dataArrayGreen[0]);
    shiftOut(dataPin, clockPin, dataArrayRed[j]);
    digitalWrite(latchPin, HIGH);
    delay(500);
  }
  for(int j=2;j<10;j++){
    digitalWrite(latchPin, LOW);
    shiftOut(dataPin, clockPin, dataArrayGreen[j]);
    shiftOut(dataPin, clockPin, dataArrayRed[0]);
    digitalWrite(latchPin, HIGH);
    delay(500);
  }
  
  
  // now some green then red leds
  for(int j=2;j<10;j++){
    digitalWrite(latchPin, LOW);
    shiftOut(dataPin, clockPin, dataArrayGreen[j]);
    shiftOut(dataPin, clockPin, dataArrayRed[0]);
    digitalWrite(latchPin, HIGH);
    delay(250);

    digitalWrite(latchPin, LOW);
    shiftOut(dataPin, clockPin, dataArrayGreen[0]);
    shiftOut(dataPin, clockPin, dataArrayRed[j]);
    digitalWrite(latchPin, HIGH);
    delay(250);
  }
    // now some green then red leds
  for(int j=2;j<10;j++){
    digitalWrite(latchPin, LOW);
    shiftOut(dataPin, clockPin, dataArrayGreen[j]);
    shiftOut(dataPin, clockPin, dataArrayRed[0]);
    digitalWrite(latchPin, HIGH);
    delay(175);

    digitalWrite(latchPin, LOW);
    shiftOut(dataPin, clockPin, dataArrayGreen[0]);
    shiftOut(dataPin, clockPin, dataArrayRed[j]);
    digitalWrite(latchPin, HIGH);
    delay(175);
  }
    // now some green then red leds
  for(int j=2;j<10;j++){
    digitalWrite(latchPin, LOW);
    shiftOut(dataPin, clockPin, dataArrayGreen[j]);
    shiftOut(dataPin, clockPin, dataArrayRed[0]);
    digitalWrite(latchPin, HIGH);
    delay(50);

    digitalWrite(latchPin, LOW);
    shiftOut(dataPin, clockPin, dataArrayGreen[0]);
    shiftOut(dataPin, clockPin, dataArrayRed[j]);
    digitalWrite(latchPin, HIGH);
    delay(50);
  }
  
  
}

// the heart of the program
void shiftOut(int myDataPin, int myClockPin, byte myDataOut) {
  // This shifts 8 bits out MSB first, 
  //on the rising edge of the clock,
  //clock idles low

  //internal function setup
  int i=0;
  int pinState;
  pinMode(myClockPin, OUTPUT);
  pinMode(myDataPin, OUTPUT);

  //clear everything out just in case to
  //prepare shift register for bit shifting
  digitalWrite(myDataPin, 0);
  digitalWrite(myClockPin, 0);

  //for each bit in the byte myDataOut�
  //NOTICE THAT WE ARE COUNTING DOWN in our for loop
  //This means that %00000001 or "1" will go through such
  //that it will be pin Q0 that lights. 
  for (i=7; i>=0; i--)  {
    digitalWrite(myClockPin, 0);

    //if the value passed to myDataOut and a bitmask result 
    // true then... so if we are at i=6 and our value is
    // %11010100 it would the code compares it to %01000000 
    // and proceeds to set pinState to 1.
    if ( myDataOut & (1<<i) ) {
      pinState= 1;
    }
    else {	
      pinState= 0;
    }

    //Sets the pin to HIGH or LOW depending on pinState
    digitalWrite(myDataPin, pinState);
    //register shifts bits on upstroke of clock pin  
    digitalWrite(myClockPin, 1);
    //zero the data pin after shift to prevent bleed through
    digitalWrite(myDataPin, 0);
  }

  //stop shifting
  digitalWrite(myClockPin, 0);
}



