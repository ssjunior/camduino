void config_main()
{
  
  pinMode(BUZZER_PIN, OUTPUT);
  digitalWrite(BUZZER_PIN, LOW);
        
  // Inicializo o estado dos pinos
  for (int k = 0;  k < EVENTS_QTDE; k++)
  {
    // Se tem pino definido, inicializo o estado do mesmo
    if (evento[k][1] > 0)
      // Se é 1 (um) é porque é um dispositivo definido
      if (evento[k][0] == 1)
      {
        pinMode(evento[k][1], OUTPUT);
        digitalWrite(evento[k][1], LOW);
      }
      // Senão é um sensor
      if (evento[k][0] == 2)
        pinMode(evento[k][1], INPUT);
  }
  

  // Inicializo o LCD com o número de colunas e linhas
  lcd.begin(16, 2); 

  Serial.begin(9600);
}
