#include <iostream>
using namespace std;
int main (void)
{
    int n,tamanho,contador;
    cout<<"Digite o numero de notas a ser computadas \n"
        <<"Lembre-se que o maximo de alunos possivel e' 20\n";
    cin>>tamanho;
    if (tamanho<=20 && tamanho>0)
    {
                    int nota[tamanho],freqa[11],pontos;
                    float freqr[11];
                    n=0;
                    while (n<tamanho)
                    {
                          cout<<"digite a nota do aluno \n"
                              <<"lembre-se que a nota minima e' 0 e a maxima e' 10\n";
                          cin>>nota[n];
                          n=n+1;
                    }
                    pontos=0;
                    while (pontos<=10)
                    {
                          freqa[pontos]= 0;
                          freqr[pontos]= 0;
                          pontos=pontos+1;
                    }
                    n=0;
                    while (n<tamanho)
                    {
                          cout<<"a nota do aluno " <<n+1 <<" foi " <<nota[n] <<"\n";
                          for(pontos=0;pontos<=10;pontos=pontos+1)
                          {
                                if(pontos==nota[n])
                                                   freqa[pontos]=freqa[pontos]+1;
                                freqr[pontos]=(freqa[pontos]*1.0)/tamanho;
                          }
                          n=n+1;
                    }
                    for (pontos=0;pontos<=10;pontos++)
                        cout<<"A frequencia absoluta da nota " <<pontos <<" foi "
                            <<freqa[pontos] <<" e a frequencia relativa foi " <<freqr[pontos] <<"\n";
    }
    else
                    cout<<"o numero de notas foi maior que 20 ou valor negativo\n";
    system("pause");
    return 0;
}
