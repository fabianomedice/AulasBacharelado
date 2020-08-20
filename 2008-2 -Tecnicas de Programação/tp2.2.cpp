//escrever uma funcao que faça uma busca em uma lista crescente
//recursiva

#include <iostream>

using namespace std;
struct celula{
int x;
celula *prox;
};

typedef celula *cel;
//-------------------------------------------------
void insere (cel &ini, int x)
{
     cel atual;
     int aux;
     if(ini==NULL)
     {
                 ini=new celula;
                 ini->x=x;
                 ini->prox=NULL;                 
     }
     else
     {
                 atual=ini;
                 if (atual -> x <=x)
                 {
                           insere (atual->prox,x);
                 }
                 if (atual -> x > x)
                 {
                           insere (atual ->prox, x);
                           aux=atual->x;
                           atual->x=atual->prox->x;
                           atual->prox->x=aux;
                 }
     }
}
//---------------------------------------------
void lista (cel &ini)
{
     if(ini!=NULL)
     {
           cout<<ini->x <<"\t";
           lista(ini->prox);
     }
}
//---------------------------------------------
cel busca (int x, cel &ini)
{
       int achou;
       cel p;
       achou=0;
       p = ini;
       while (p!=NULL && !achou)
       {
             if (p->x == x)
             {
                achou = 1;
                break;
             }
             p=p->prox;
       }
       if (achou)
          return p;
       else
           return NULL;
}
//---------------------------------------------
int main(void)
{
cel p,y;
p=NULL;
int valor;
do{
cout<<"\nDigite um valor:";
cin>>valor;
if(valor<0) break;
insere(p,valor);
}
while(1);
cout<<"\nOs elementos da lista => ";
lista(p);
cout<<"\n";
    cout<<"\nDigite um numero para buscar ";
    cin>>valor;
    y=busca(valor,p);
    if(y!=NULL)
        cout<<"O elemento procurado "<<y->x <<" existe na lista "<<"\n";
    else
        cout<<"O elemento " <<valor <<" nao se encontra na lista \n";
system("PAUSE");
return 0;
}
