//*********************************************************************************//
//
// Name:     Christmas Ornament Blinky Sketch
// Author:   Jay Collett
// Date:     November 16, 2010
// Version:  1.0
//
// Notes:    This sketch will control the blinkyness of the Christmas ornament
//           a wee bit of focus was put on shaving memory.
//
//
//*********************************************************************************//

// Setup shift register pins 595
int latchPin = 8;
int clockPin = 10;
int dataPin = 11;

// Setup pins for blue and white LEDs on neck of ornament
int whiteLEDPin1 = A0;
int whiteLEDPin2 = A2;
int blueLEDPin1 = A1;
int blueLEDPin2 = A3;

// Byte arrays to hold data for different "animations" we'll be using
const byte dataArrayLED[10] = { 0x00, 0xFF, 0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01 };
const byte wheelRotateAnimation[2] = { 0x55, 0xAA };
const byte darkLEDChaser[8] = { 0x7F, 0xBF, 0xDF, 0xEF, 0xF7, 0xFB, 0xFD, 0xFE };
const byte oppLEDAnimation[8] = { 0x80, 0x08, 0x02, 0x20, 0x40, 0x04, 0x01, 0x10 };
const byte oppChaseLEDAnimation[4] = { 0x88, 0x44, 0x22, 0x11 };

// converted to const arrays to save some memory, ~5%
// opposite leds lit at the same time and rotate around circle
//oppChaseLEDAnimation[0] = 0x88; // 10001000
//oppChaseLEDAnimation[1] = 0x44; // 01000100
//oppChaseLEDAnimation[2] = 0x22; // 00100010
//oppChaseLEDAnimation[3] = 0x11; // 00010001

// Single on/off values for each led
//  dataArrayLED[0] = 0x00; //00000000
//  dataArrayLED[1] = 0xFF; //11111111
//  dataArrayLED[2] = 0x80; //10000000
//  dataArrayLED[3] = 0x40; //01000000
//  dataArrayLED[4] = 0x20; //00100000
//  dataArrayLED[5] = 0x10; //00010000
//  dataArrayLED[6] = 0x08; //00001000
//  dataArrayLED[7] = 0x04; //00000100
//  dataArrayLED[8] = 0x02; //00000010
//  dataArrayLED[9] = 0x01; //00000001

// Combo of 4 leds on, same for green and red two step animation, I called this WagonWheel....bleh
//  wheelRotateAnimation[0] = 0x55; //0101010 step 1
//  wheelRotateAnimation[1] = 0xAA; //1010101  step 2

// Lit LED chaser animation
//  darkLEDChaser[0] = 0x7F; // 01111111
//  darkLEDChaser[1] = 0xBF; // 10111111
//  darkLEDChaser[2] = 0xDF; // 11011111
//  darkLEDChaser[3] = 0xEF; // 11101111
//  darkLEDChaser[4] = 0xF7; // 11110111
//  darkLEDChaser[5] = 0xFB; // 11111011
//  darkLEDChaser[6] = 0xFD; // 11111101
//  darkLEDChaser[7] = 0xFE; // 11111110

// Opposite LEDs array animation
//  oppLEDAnimation[0] = 0x80; //10000000 top red led
//  oppLEDAnimation[1] = 0x08; //00001000 bottom red led
//  oppLEDAnimation[2] = 0x02; //00000010 left red led
//  oppLEDAnimation[3] = 0x20; //00100000 right red led 
//  oppLEDAnimation[4] = 0x40; //01000000 right top right corner red led 
//  oppLEDAnimation[5] = 0x04; //00000100 bottom left corner red led 
//  oppLEDAnimation[6] = 0x01; //00000001 top left corner red led 
//  oppLEDAnimation[7] = 0x10; //00010000 bottom right corner red led 



void setup(){

  // Setting pin modes for all the output pins, first 3 are for the 595, others are for Blue and White LEDs
  pinMode(latchPin, OUTPUT);
  pinMode(clockPin, OUTPUT);
  pinMode(dataPin, OUTPUT);

  pinMode(whiteLEDPin1, OUTPUT);
  pinMode(whiteLEDPin2, OUTPUT);
  pinMode(blueLEDPin1, OUTPUT);
  pinMode(blueLEDPin2, OUTPUT);

  // Do a little start-up sequence to let everyone know all is well
  
  // quickly flash the blue and white leds on the neck
  digitalWrite(whiteLEDPin1, HIGH);
  delay(150);
  digitalWrite(whiteLEDPin1, LOW);
  digitalWrite(blueLEDPin1, HIGH);
  delay(150);
  digitalWrite(blueLEDPin1, LOW);
  digitalWrite(whiteLEDPin2, HIGH);
  delay(150);
  digitalWrite(whiteLEDPin2, LOW);
  digitalWrite(blueLEDPin2, HIGH);
  delay(150);
  digitalWrite(blueLEDPin2, LOW);
  delay(150);
  
  // First, turn on all red LEDs
  sendData(dataArrayLED[0], dataArrayLED[1]); // green led byte then red led byte
  delay(675);

  // Now turn off all red LEDs and turn on all Green LEDs
  sendData(dataArrayLED[1], dataArrayLED[0]);
  delay(675);

  // And now turn on both red and green LEDs
  sendData(dataArrayLED[1], dataArrayLED[1]);
  delay(675);

  // Finally, turn all LEDs off
  sendData(dataArrayLED[0], dataArrayLED[0]);
}


void loop(){
  // Yep, this is it...all the magic happens in a single very simple method.
  // actually this whole sketch is rather simplistic....
 PerformRandomAnimation();
}


void PerformRandomAnimation(){
  // setting up a good random seed isn't easy, we'll use the Analog 6 reading, it's not connected to anything
  randomSeed(analogRead(A6)+analogRead(A5));

  // give us a random value between 1 and 900
  int randomNum = random(1, 950);

  // based on the number perform the given animation
  if((randomNum >= 1) && (randomNum <= 100))
    OppositeLEDs(2);
  else if((randomNum >= 101) && (randomNum <= 200))
    RandomLEDs(40);
  else if((randomNum >= 201) && (randomNum <= 300))
    LEDChaseClockwise(6);    
  else if((randomNum >= 301) && (randomNum <= 400))
    LEDChaseCounterClockwise(6);    
  else if((randomNum >= 401) && (randomNum <= 500))
    RotateWheelClockwise(8);
  else if((randomNum >= 501) && (randomNum <= 600))
    RotateWheelCounterClockwise(8);
  else if((randomNum >= 601) && (randomNum <= 700))
    OppositeAroundTheCircleCounterClockwise(4);
  else if((randomNum >= 701) && (randomNum <= 800))
    OppositeAroundTheCircleClockwise(4);
  else if((randomNum >= 801) && (randomNum <= 850))
      DarkLedChaseClockwise(2);
  else if((randomNum >= 851) && (randomNum <= 900))
      DarkLedChaseCounterClockwise(2);
  else{
      LEDChaseClockwiseSuperFast(10);
  }
}

void LEDChaseClockwiseSuperFast(int rotations){
  for(int i=0; i<rotations;i++){
    for(int j=2;j<10;j++){
      sendData(dataArrayLED[j], dataArrayLED[0]);
      delay(10);

      sendData(dataArrayLED[0], dataArrayLED[j]);
      delay(10);
    }
  }
}

void OppositeAroundTheCircleClockwise(int rotations){
  for(int i=0;i<rotations;i++){
    for(int j=0;j<4;j++){
      sendData(oppChaseLEDAnimation[j], dataArrayLED[0]);      
      delay(200);

       if((i % 2) == 0){
        if(j==0){
          digitalWrite(whiteLEDPin1, HIGH);
        }else if(j == 1){
          digitalWrite(blueLEDPin1, HIGH);
        }else if(j == 2){
          digitalWrite(whiteLEDPin2, HIGH);          
        }else{
          digitalWrite(blueLEDPin2, HIGH);          
        }
      }else{
        if(j==0){
          digitalWrite(whiteLEDPin1, LOW);
        }else if(j == 1){
          digitalWrite(blueLEDPin1, LOW);
        }else if(j == 2){
          digitalWrite(whiteLEDPin2, LOW);          
        }else{
          digitalWrite(blueLEDPin2, LOW);          
        }
      }
      
      sendData(dataArrayLED[0], oppChaseLEDAnimation[j]);
      delay(200);
    }
  }
  digitalWrite(blueLEDPin1, LOW);
  digitalWrite(blueLEDPin2, LOW);
  digitalWrite(whiteLEDPin1, LOW);
  digitalWrite(whiteLEDPin2, LOW);
}

void OppositeAroundTheCircleCounterClockwise(int rotations){
  for(int i=0;i<rotations;i++){
    for(int j=3;j>=0;j--){
      sendData(dataArrayLED[0], oppChaseLEDAnimation[j]);      
      delay(200);

	if((i % 2) == 0){
		if(j==0){
		  digitalWrite(whiteLEDPin1, HIGH);
		}else if(j == 1){
		  digitalWrite(blueLEDPin1, HIGH);
		}else if(j == 2){
		  digitalWrite(whiteLEDPin2, HIGH);          
		}else{
		  digitalWrite(blueLEDPin2, HIGH);          
		}
	}else{
		if(j==0){
		  digitalWrite(whiteLEDPin1, LOW);
		}else if(j == 1){
		  digitalWrite(blueLEDPin1, LOW);
		}else if(j == 2){
		  digitalWrite(whiteLEDPin2, LOW);          
		}else{
		  digitalWrite(blueLEDPin2, LOW);          
		}
	}

      sendData(oppChaseLEDAnimation[j], dataArrayLED[0]);      
      delay(200);
    }
  }
  digitalWrite(blueLEDPin1, LOW);
  digitalWrite(blueLEDPin2, LOW);
  digitalWrite(whiteLEDPin1, LOW);
  digitalWrite(whiteLEDPin2, LOW); 
}

void RotateWheelCounterClockwise(int rotations){
  for(int i=0;i<rotations;i++){
    sendData(dataArrayLED[0], wheelRotateAnimation[0]); // red step 1, green off
    delay(350);

    sendData(wheelRotateAnimation[0], dataArrayLED[0]); // green step 1, red off
    delay(350);

    sendData(dataArrayLED[0], wheelRotateAnimation[1]); // red step 2, green off
    delay(350);

    sendData(wheelRotateAnimation[1], dataArrayLED[0]); // green step 2, red off
    delay(350);
  } 
}

void RotateWheelClockwise(int rotations){
  for(int i=0;i<rotations;i++){
    sendData(wheelRotateAnimation[1], dataArrayLED[0]); // green step 2, red off
    delay(350);

    sendData(dataArrayLED[0], wheelRotateAnimation[1]); // red step 2, green off
    delay(350);

    sendData(wheelRotateAnimation[0], dataArrayLED[0]); // green step 1, red off
    delay(350);

    sendData(dataArrayLED[0], wheelRotateAnimation[0]); // red step 1, green off
    delay(350);
  } 
}

void DarkLedChaseClockwise(int rotations){
  for(int i=0; i<rotations;i++){
    for(int j=0;j<8;j++){
      sendData(darkLEDChaser[j], dataArrayLED[1]);
      delay(150);

      sendData(dataArrayLED[1], darkLEDChaser[j]);
      delay(150);
    }
  } 
}

void DarkLedChaseCounterClockwise(int rotations){
  for(int i=0; i<rotations;i++){
    for(int j=7;j>=0;j--){
      sendData(dataArrayLED[1], darkLEDChaser[j]);
      delay(150);

      sendData(darkLEDChaser[j], dataArrayLED[1]);
      delay(150);
    }
  } 
}

void LEDChaseClockwise(int rotations){
  for(int i=0; i<rotations;i++){
    for(int j=2;j<10;j++){
      sendData(dataArrayLED[j], dataArrayLED[0]);
      delay(50);

      sendData(dataArrayLED[0], dataArrayLED[j]);
      delay(50);
    }
  }
}

void LEDChaseCounterClockwise(int rotations){
  for(int i=0; i<rotations;i++){
    for(int j=9;j>1;j--){
      sendData(dataArrayLED[0], dataArrayLED[j]);
      delay(50);

      sendData(dataArrayLED[j], dataArrayLED[0]);
      delay(50);
    }
  }
}

void RandomLEDs(int rotations){
  for(int i=0; i<rotations;i++){
    byte randomGreen = random(0,255);
    byte randomRed = random(0,255);

    if((randomGreen > 245) && (randomRed > 245)){
      digitalWrite(whiteLEDPin1, HIGH);
      digitalWrite(whiteLEDPin2, HIGH);
      digitalWrite(blueLEDPin1, HIGH);
      digitalWrite(blueLEDPin2, HIGH);
    }else if ((randomGreen < 50) && (randomRed > 200)){
      digitalWrite(whiteLEDPin2, HIGH);
      digitalWrite(blueLEDPin1, HIGH);
    }else if ((randomGreen < 50) && (randomRed < 50)){
      digitalWrite(whiteLEDPin1, HIGH);
      digitalWrite(blueLEDPin2, HIGH);
    }
    sendData(randomGreen, randomRed);
    delay(125);  
    
    digitalWrite(whiteLEDPin1, LOW);
    digitalWrite(whiteLEDPin2, LOW);
    digitalWrite(blueLEDPin1, LOW);
    digitalWrite(blueLEDPin2, LOW);
  }
}

void OppositeLEDs(int iterations){
  for(int i=0; i<iterations;i++){
    for(int j=0;j<8;j++){
      sendData(dataArrayLED[0], oppLEDAnimation[j]);
      delay(250);
    }
    for(int j=0;j<8;j++){
      sendData(oppLEDAnimation[j], dataArrayLED[0]);
      delay(250);
    }
  }
}

void AllOff(){
  sendData(dataArrayLED[0], dataArrayLED[0]);
}

// method to take care of actually shifting data out through the shiftout method...saves lots of retyping...
void sendData(byte greenDataOut, byte redDataOut){
  digitalWrite(latchPin, LOW);
  shiftOut(dataPin, clockPin, greenDataOut);
  shiftOut(dataPin, clockPin, redDataOut);
  digitalWrite(latchPin, HIGH);
}

// Shiftout method taken from Arduino.cc website
// http://www.arduino.cc/en/Tutorial/ShiftOut
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



