int executaAcao() {

  int actionTriggered;
  
  lcd.clear();
  lcd.print("Executando ");

  // Executo todos os eventos definidos
  for (int k = 0;  k < EVENTS_QTDE-1; k++) {


    if (evento[k][0] == 0)
    {
      // Se não tem pino definido, pulo para o próximo
      continue;
    }

    Serial.println("Inicio");

    // Se o evento é do tipo Device, executo
    if (evento[k][0] == 1)
    {

      
      Serial.println(evento[k][4]);
      // Executo o número de repetições definido
      for (int j = 1; j <= evento[k][4]; j++) {

        Serial.println("Executei k");
        Serial.println(k);
        Serial.println("Executei j");
        Serial.println(j);
        digitalWrite(evento[k][1],HIGH);
        // Duração do evento
        delay(evento[k][2]);
        // Se o estado final é Off, aguardo o tempo de execução 
        // e desativo o pino
        if (evento[k][5] == 0)
          digitalWrite(evento[k][1],LOW);
        delay(evento[k][3]);
      }
      // Senao é do tipo sensor e tenho que aguardar a leitura
      } else {
        
        actionTriggered = FALSE;
        lcd.clear();
        itoa(k,lcdMessage,10);
        lcd.print("Aguardando Sensor");
        lcd.print(lcdMessage);
        
        do {
          if (evento[k][2] == 1) {
            // O sensor é do tipo digital
            sensorValue = digitalRead(evento[k][1]);
            if (sensorValue == evento[k][4])
              actionTriggered = TRUE;
          } else {
            // O sensor é do tipo analógico
            sensorValue = analogRead(evento[k][1]);
            if (sensorValue == evento[k][4])
              actionTriggered = TRUE;
          }
        } while (!actionTriggered);

      // Aguardo para iniciar o próximo evento
      delay(evento[k][3]);

      }

  }
  
  lcd.clear();
  lcd.print("Finalizado");
  functions_beep(300);
  delay(2000);

}
