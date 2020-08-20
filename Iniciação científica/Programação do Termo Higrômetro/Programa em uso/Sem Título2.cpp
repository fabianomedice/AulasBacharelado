#include <vcl.h>
#include <vcl\registry.hpp> //Para TRegistry.
#pragma hdrstop
#include "UnitSerial.h"
#include "Dialogo.h"
__fastcall TForm1::TForm1(TComponent* Owner): TForm(Owner)
{
    ComboBoxPorta->ItemIndex = 0; //Seleciona a porta COM1. 1=COM2; 2=COM3;
    dcb.BaudRate = CBR_9600;      //bps (Velocidade).
    dcb.ByteSize = 8;             //8 Bits de dados.
    dcb.Parity = NOPARITY;        //Sem paridade.
    dcb.StopBits = ONESTOPBIT;    //1 stop bit.
}
//------------------------------------------------------------------------------
