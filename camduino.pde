#include <EEPROM.h>
#include <LiquidCrystal.h>

#define TRUE 1
#define FALSE 0

#define LCD1_MESSAGE "Camduino 0.1"
#define LCD2_MESSAGE "READY!"

// Definicao da quantidade de eventos a serem processados
#define EVENTS_QTDE 10

#define PINS_QTY 4

// Pino do Keypad Shield
#define KEYPAD_PIN    0

// Define o pino do buzzer
#define BUZZER_PIN 19

// Definicao das teclas pressionadas
#define NO_KEY       -1
#define BUTTON_RIGHT  0
#define BUTTON_UP     1
#define BUTTON_DOWN   2
#define BUTTON_LEFT   3
#define BUTTON_SELECT 4

// Definicao do valor de resistencia para deteccado de tecla digitada
// no Keypad Shield
//int adcKeyValue[5] ={60, 170, 370, 540, 760 };
int adcKeyValue[5] ={30, 150, 360, 535, 760 };

int numKeys = 5;

// 16 caracteres         "1234567890123456"
#define MSG_SUBMENU_PIN  "Porta:"
#define MSG_SUBMENU_DUR  "Duracao:"
#define MSG_SUBMENU_DEL  "Delay:"
#define MSG_SUBMENU_CYC  "Ciclos:"
#define MSG_SUBMENU_STA  "Estado Final:"
#define MSG_SUBMENU_ANA  "Analogico"
#define MSG_SUBMENU_DIG  "Digital  "
#define MSG_SUBMENU_QTY  "Quantidade:"
#define MSG_SUBMENU_TRI  "Trigger Value:"
#define MSG_SUBMENU_TYP  "Tipo:"
#define MSG_SUBMENU_ON   "Ligado"
#define MSG_SUBMENU_OFF  "Desligado"
#define MSG_SUBMENU_POS  "Logica Positiva"
#define MSG_SUBMENU_LOG  "Logica:"
#define MSG_SUBMENU_NEG  "Logica Negativa"
#define MSG_SUBMENU_SEN  "Sensor"
#define MSG_SUBMENU_DEV  "Device"
#define MSG_SUBMENU_INA  "Inativo"


// Definicao dos pinos e parametros iniciais
// tipo (0 = não definido)
// tipo (1 = device), pino, duracao, delay, qtde, estado final)
// tipo (2 = sensor), pino, tipo (0 = analogico, 1 = digital), delay, trigger value, estado (acima ou abaixo do valor de referencia)
int evento[EVENTS_QTDE][6] = {{0,15,0,0,25,1},{1,16,10,0,1,1},{1,17,60,30,1,0},{1,17,50,100,1,0},{1,18,10,0,1,0},{1,16,10,0,1,0},{0,0,0,0,0,0},{0,0,0,0,0,0},{0,0,0,0,0,0},{0,0,0,0,0,0}};

#define OPTION_PIN

int availablePins[PINS_QTY]={16,17,18};

char lcdMessage[16];

// Definicao do valor de leitura do keypad
int keyValue = -1;
int tmp_keyValue = -1;
int tmp_keyValue1 = -1;
int tmp_newKeyValue = 0;
int fast = 0;
long lastDebounceTime = 0;  // the last time the output pin was toggled
long debounceDelay = 300;    // the debounce time; increase if the output flickers

int adc_key_in;
int key=-1;
int oldkey=-1;

int eventoIndice = 0; 
int sensorValue = 0;

#define LCD_PIN_RS 8
#define LCD_PIN_ENABLE 9
#define LCD_PIN_DB4 4
#define LCD_PIN_DB5 5
#define LCD_PIN_DB6 6
#define LCD_PIN_DB7 7

// Inicio o LCD com os pinos corretos
LiquidCrystal lcd(LCD_PIN_RS, LCD_PIN_ENABLE, LCD_PIN_DB4, LCD_PIN_DB5, LCD_PIN_DB6, LCD_PIN_DB7); 
    
void setup() 
{
  config_main();
}

void loop() 
{
  controller_main();
}


