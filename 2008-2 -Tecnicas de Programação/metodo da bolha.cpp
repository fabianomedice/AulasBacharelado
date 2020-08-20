#include <iostream>
using namespace std;
int main (void)
{
    int C[10], aux, i, j, contador;
    C[0]=50;
    C[1]=3;
    C[2]=1;
    C[3]=150;
    C[4]=140;
    C[5]=30;
    C[6]=35;
    C[7]=40;
    C[8]=20;
    C[9]=10;
    contador=0;
    while (contador<9)
    {
          i=9;
          while (i>0)
          {
                j=i-1;
                aux=C[j];
                if (C[i]<aux)
                {
                      C[j]= C[i];
                      C[i]=aux;
                }
                i--;
          }
          contador++;
    }
    i=0;
    while (i<10)
    {
          cout<<C[i] <<"\t";
          i++;
    }
    system ("pause");
    return 0;
}
