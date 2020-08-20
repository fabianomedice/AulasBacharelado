#include <iostream>
using namespace std;
int main(void)
{
    int matriz[50][60],vetor[60],i,j;
    for(i=0;i<50;i++)
                    for(j=0;j<60;j++)
                    {
                                    cout<<"Digite o elemento [" <<i+1 <<"][" <<j+1 <<"] \n";
                                    cin>>matriz[i][j];
                    }
    for(j=0;j<60;j++)
                    vetor[j]=0;
    for(j=0;j<60;j++)
                    for(i=0;i<50;i++)
                                    vetor[j]=vetor[j] + matriz[i][j];
    cout<<"A matriz e'\n";
    for(i=0;i<50;i++)
    {
                    for(j=0;j<60;j++)
                                    cout<<matriz[i][j] <<"\t";
                    cout<<"\n";
    }
    cout<<"O vetor e'\n";
    for(j=0;j<60;j++)
                    cout<<vetor[j] <<"\t";
    cout<<"\n";
    system("pause");
    return 0;
}
