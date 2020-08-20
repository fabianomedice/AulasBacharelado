// inverte a ordem das celulas de uma lista encadeada

#include <iostream.h>

struct celula{
int x;
celula *prox;
};

typedef celula *cel;
//-------------------------------------------------
void insere(cel &ini,int n)
{
 cel nova,atual;
 if(ini==NULL)
 {
  ini=new celula;
  (ini)->x=n;
  (ini)->prox=NULL;
 }
 
 else 
  if((ini)->x>=n)
  {
   nova=new celula;
   nova->x=n;
   nova->prox=ini;
   ini=nova;
  }
  else
  {
   atual=ini;
   while(atual->prox!=NULL&&atual->prox->x<n)
   {
    atual=atual->prox;
   }
   nova=new celula;
   nova->x=n;
   nova->prox=atual->prox;
   atual->prox=nova;
  }
 }
//---------------------------------------------
void lista(cel &ini)
{
cel p;
p=ini;
while(p!= NULL){
cout<<p->x<<"\t";
p=p->prox;
}
}
//---------------------------------------------
void inverte(cel &ini)
{
     cel aux;
     int i,contador;
     aux = ini;
     contador=0;
     while (aux != NULL)
     {
           contador=contador+1;
           aux = aux ->prox;
           }
     int V[contador];
     aux=ini;
     i=0;
     while (aux!= NULL)
     {     
           V[i]=aux->x;
           aux = aux ->prox;
           i=i+1;
           }
     i=contador-1;
     aux=ini;
     while (aux != NULL)
     {
           aux->x=V[i];
           aux=aux->prox;
           i=i-1;
           }
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
cout << "\n";
inverte(p);
cout<<"\nOs elementos da lista => ";
lista(p);
cout << "\n";
system("PAUSE");
return 0;
}
