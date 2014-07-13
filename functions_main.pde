// prints screen title
void lcd_printTitle(char *msg){
    lcd.clear();
    lcd.print(msg);
    lcd.setCursor(0,1);
}

void lcd_printSubTitle(char *msg){
    lcd.setCursor(0,1);
    lcd.print(msg);
}

// Waits until any key is pressed
void functions_waitForKeyPress()
{
   do
   {
     //Serial.println("Waiting");
     //Serial.println(NO_KEY);
   } while (readKey() == NO_KEY);
}

int check_pinAvailable(int pin) {
  int k;
  for (k = 0; k < PINS_QTY; k++) {
    if (pin == availablePins[k]) 
      return TRUE;
  }
  return FALSE;
}

void functions_beep(int duration)
{
  digitalWrite(BUZZER_PIN, HIGH);
//  analogWrite(BUZZER_PIN, 150);
  delay(duration);
//  analogWrite(BUZZER_PIN, 0);
  digitalWrite(BUZZER_PIN, LOW);
}

int readKey() 
{

  while (1) {

    adc_key_in = analogRead(KEYPAD_PIN);
    key = getKey(adc_key_in);
     
    if (key != oldkey) {

          // Serial.println(key);
           //Serial.println(oldkey);
           //Serial.println(tmp_keyValue);
           //Serial.println("-----------");
           
      delay(50); // wait for debounce time
      adc_key_in = analogRead(0);    // read the value from the sensor  
      key = getKey(adc_key_in);		        // convert into key press
      if (key != oldkey) {			
        oldkey = key;
        if (key >=0){
          lastDebounceTime = millis();
  	  return key;
        }
      }
    } else {
  
      adc_key_in = analogRead(0);    // read the value from the sensor  
      tmp_keyValue = getKey(adc_key_in);		        // convert into key press

      if (tmp_keyValue == key and ((millis() - lastDebounceTime) > debounceDelay)) {
        fast++;
        if (key != -1){
          if (fast < 20) delay(100);
          if (fast < 15) delay(200);      
          return key;
        } else {
          fast = 0;
          tmp_keyValue = -1;
        }
      }
    }
  }
}

// Converte o valor ADC da tecla pressionada para o numero da tecla
int getKey(unsigned int input)
{ 
  int k;
  for (k = 0; k < numKeys; k++)
  {
    if (input < adcKeyValue[k])
    {
      return k;
    }
  }  
  if (k >= numKeys)
      k = -1;     // Nenhuma tecla pressionada
  return k;
}

int mod(int valor, int modulo)
{
  if (valor > (modulo-1))
    valor = 0;
  if (valor < 0 )
    valor = (modulo-1);
  return valor;
}

// Writes an integer to eeprom
void eepromWriteInt(int addr, int val)
{
  addr *= 2;  // int is 2 bytes
  EEPROM.write(addr+1, val&0xFF);
  val /= 256;
  EEPROM.write(addr+0, val&0xFF);
}

// Reads an integer from eeprom
int eepromReadInt(int addr, int minVal, int maxVal)
{
  int val;

  addr *= 2;  // int is 2 bytes
  val = EEPROM.read(addr+0);
  val *= 256;
  val |= EEPROM.read(addr+1);
  val = constrain(val, minVal, maxVal);
  return val;
}
  
