//escrever uma funcao que faça uma busca em uma lista crescente
//iterativa

#include <iostream>

using namespace std;
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
void lista(cel &ini){
cel p;
p=ini;
while(p!= NULL){
cout<<p->x<<"\t";
p=p->prox;
}}
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
