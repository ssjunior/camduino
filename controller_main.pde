// Inicia o sistema
void controller_main() {
  
  lcd_printTitle(LCD1_MESSAGE);
  lcd_printSubTitle(LCD2_MESSAGE);
  functions_beep(300);
  delay(1000);
  //functions_waitForKeyPress();
  controller_showMainMenu();

}

void controller_showMainMenu() {

  while (1) {

    lcd.clear();
    // Numero de ordem de execução
    itoa(eventoIndice+1,lcdMessage,10);
    lcd.print(lcdMessage);
    if (evento[eventoIndice][0] == 0)
      lcd.print(" - Nao Definido ");
    if (evento[eventoIndice][0] == 1)
      lcd.print(" - Device ");
    else
      lcd.print(" - Sensor ");
      
    // Número do pino
    itoa(evento[eventoIndice][1],lcdMessage,10);
    lcd.print(lcdMessage);
  
    lcd.setCursor(0, 1);

    if (evento[eventoIndice][0] == 2) {
      if (evento[eventoIndice][2] == 0)
         lcd.print("Ana");
       else
         lcd.print("Dig");

      lcd.print(" T");
      if (evento[eventoIndice][5] == 0)
        lcd.print("<");
      else
        lcd.print(">");

      itoa(evento[eventoIndice][4],lcdMessage,10);
      lcd.print(lcdMessage);
  

      lcd.print(" W");
      itoa(evento[eventoIndice][3],lcdMessage,10);
      lcd.print(lcdMessage);


    }
   
    if (evento[eventoIndice][0] == 1) {

      lcd.print("D");
      itoa(evento[eventoIndice][2],lcdMessage,10);
      lcd.print(lcdMessage);

      lcd.print(" W");
      itoa(evento[eventoIndice][3],lcdMessage,10);
      lcd.print(lcdMessage);

      lcd.print(" R");
      itoa(evento[eventoIndice][4],lcdMessage,10);
      lcd.print(lcdMessage);
  
      if (evento[eventoIndice][5] == 0)
        lcd.print(" Off");
      else
        lcd.print(" On");

    }

    if (evento[eventoIndice][0] == 1) {

      lcd.print("");

    }
      
    // Leio o teclado até achar uma tecla pressionada
    while (keyValue == NO_KEY)
      keyValue = readKey();
    
    if (keyValue == BUTTON_RIGHT) 
      eventoIndice = mod(eventoIndice+1,EVENTS_QTDE);
    if (keyValue == BUTTON_LEFT)
      eventoIndice = mod(eventoIndice-1,EVENTS_QTDE);
    if (keyValue == BUTTON_DOWN)
      typeMenu(eventoIndice);
    if (keyValue == BUTTON_SELECT)
      executaAcao();
    keyValue = NO_KEY;
  }
}


void typeMenu (int eventoNum) {

  while (TRUE) {

    lcd.clear();
    if (evento[eventoNum][0] == 0)
      lcd_printTitle(MSG_SUBMENU_INA);
    if (evento[eventoNum][0] == 1)
      lcd_printTitle(MSG_SUBMENU_DEV);
    if (evento[eventoNum][0] == 2)
      lcd_printTitle(MSG_SUBMENU_SEN);

    keyValue = NO_KEY;
    // Leio o teclado até achar uma tecla pressionada
    while (keyValue == NO_KEY)
      keyValue = readKey();
      
    if (keyValue == BUTTON_RIGHT) 
      evento[eventoNum][0] = mod(evento[eventoNum][0]+1,3);
    if (keyValue == BUTTON_LEFT)
      evento[eventoNum][0] = mod(evento[eventoNum][0]-1,3);
      
    if (keyValue == BUTTON_UP) {
           keyValue = NO_KEY;
           break;
    }
    if (keyValue == BUTTON_DOWN) {
      if (evento[eventoNum][0] == 1)
        deviceSubMenu(eventoNum);
      if (evento[eventoNum][0] == 2)
        sensorSubMenu(eventoNum);
      if (evento[eventoNum][0] == 0) {
        lcd_printTitle(MSG_SUBMENU_INA);
        functions_beep(300);
        delay(1500);
      }
    }
    if (keyValue == BUTTON_SELECT) {
      keyValue = NO_KEY;
      break;
    }
  }
  return;
}

void sensorSubMenu(int eventoNum) {

  int subMenuOption = 1;

  while (TRUE) {

    //Serial.println(subMenuOption);
    
    lcd.clear();
    
     switch (subMenuOption) {
       case 1:
         lcd_printTitle(MSG_SUBMENU_PIN);
         break;
       case 2:
         lcd_printTitle(MSG_SUBMENU_TYP);
         if (evento[eventoNum][subMenuOption] == 0) 
            lcd_printSubTitle(MSG_SUBMENU_ANA);
          else
            lcd_printSubTitle(MSG_SUBMENU_DIG);
         break;
       case 3:
         lcd_printTitle(MSG_SUBMENU_DEL);
         break;
       case 4:
         lcd_printTitle(MSG_SUBMENU_TRI);
         sensorValue = analogRead(evento[eventoNum][1]);
         itoa(sensorValue,lcdMessage,10);
         lcd.setCursor(10,1);
         lcd.print(lcdMessage);
         break;
       case 5:
         lcd_printTitle(MSG_SUBMENU_LOG);
         if (evento[eventoNum][subMenuOption] == 0)
             lcd_printSubTitle(MSG_SUBMENU_NEG);
           else
             lcd_printSubTitle(MSG_SUBMENU_POS);
         break;
     }

    if ((subMenuOption != 2) and (subMenuOption != 5)) {
      itoa(evento[eventoNum][subMenuOption],lcdMessage,10);
      lcd.setCursor(0,1);
      lcd.print(lcdMessage);
    }

    keyValue = readKey();

    if (keyValue == BUTTON_UP and subMenuOption == 1)
      break;
      
    if (keyValue == BUTTON_RIGHT)
      // Se for estado final as unicas opcoes sao 0 e 1  
      if (subMenuOption == 2 or subMenuOption == 5)
        evento[eventoNum][subMenuOption] = mod(evento[eventoNum][subMenuOption]+1,2);
      else
        evento[eventoNum][subMenuOption] = constrain(evento[eventoNum][subMenuOption]+1,0,1024);
      
    if (keyValue == BUTTON_LEFT)      
      // Se for estado final as unicas opcoes sao 0 e 1  
      if (subMenuOption == 2 or subMenuOption == 5)
        evento[eventoNum][subMenuOption] = mod(evento[eventoNum][subMenuOption]-1,2);
      else
        evento[eventoNum][subMenuOption] = constrain(evento[eventoNum][subMenuOption]-1,0,1024);

    if (keyValue == BUTTON_UP)
       subMenuOption = constrain(subMenuOption-1,1,5);
    if (keyValue == BUTTON_DOWN)
       subMenuOption = constrain(subMenuOption+1,1,5);

    pinMode(evento[eventoNum][1], INPUT);

    if (keyValue == BUTTON_SELECT)
       break;      

  }
}


void deviceSubMenu(int eventoNum) {

  byte subMenuOption = 1;

  while (TRUE) {

    lcd.clear();
    
     switch (subMenuOption) {
       case 1:
         lcd_printTitle(MSG_SUBMENU_PIN);
         break;
       case 2:
         lcd_printTitle(MSG_SUBMENU_DUR);
         break;
       case 3:
         lcd_printTitle(MSG_SUBMENU_DEL);
         break;
       case 4:
         lcd_printTitle(MSG_SUBMENU_CYC);
         break;
       case 5:
         lcd_printTitle(MSG_SUBMENU_STA);
         break;
     }
      
    if (subMenuOption == 5) {
      switch (evento[eventoNum][subMenuOption]) {
        case 0:
         lcd_printSubTitle(MSG_SUBMENU_OFF);
          break;
        case 1:
         lcd_printSubTitle(MSG_SUBMENU_ON);
          break;
      }
    }
    else
    {
      itoa(evento[eventoNum][subMenuOption],lcdMessage,10);
      lcd.print(lcdMessage);
    }

    // Leio o teclado até achar uma tecla pressionada
    //while (keyValue == NO_KEY)
      keyValue = readKey();

    if (keyValue == BUTTON_UP and subMenuOption == 1)
      break;
      
    if (keyValue == BUTTON_RIGHT) 
      // Se for estado final as unicas opcoes sao 0 e 1  
      if (subMenuOption == 5)
        evento[eventoNum][subMenuOption] = mod(evento[eventoNum][subMenuOption]+1,2);
      else
        evento[eventoNum][subMenuOption] = constrain(evento[eventoNum][subMenuOption]+1,0,1024);
    if (keyValue == BUTTON_LEFT)      
      // Se for estado final as unicas opcoes sao 0 e 1  
      if (subMenuOption == 5)
        evento[eventoNum][subMenuOption] = mod(evento[eventoNum][subMenuOption]-1,2);
      else
        evento[eventoNum][subMenuOption] = constrain(evento[eventoNum][subMenuOption]-1,0,1024);

    if (keyValue == BUTTON_UP)
       subMenuOption = constrain(subMenuOption-1,1,5);
    if (keyValue == BUTTON_DOWN)
       subMenuOption = constrain(subMenuOption+1,1,5);
        
     // Se é um Device inicializo ele como saida
     pinMode(evento[eventoNum][1], OUTPUT);
     // Inicializa o estado dos pinos para Off
     digitalWrite(evento[eventoNum][1], LOW);

    if (keyValue == BUTTON_SELECT)
       break;      

  }
}




