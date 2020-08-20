//Fabiano Viana Oliveira da Cunha Médice
//Gilberto Castro de Rezende Zschaber
//Maira Ferreira Chaves de Oliveira
//Pedro Henrique Alves Martins


#include <iostream.h>
struct celula{
       int N;
       celula *prox;
};
typedef celula *cel;
void insere (cel &ini, int x)
{
     cel atual;
//   cel nova, atual;
     if(ini==NULL)
     {
                 ini=new celula;
                 ini->N=x;
                 ini->prox=NULL;
     }
     else
     {
                 atual=ini;
                 insere(atual->prox,x);
/*                 atual=ini;
                 while(atual->prox!=NULL)
                        atual=atual->prox;
                 nova=new celula;
                 nova->N=x;
                 nova->prox=atual->prox;
                 atual->prox=nova;
*/
     }
}

void lista (cel &ini)
{
     if(ini!=NULL)
     {
           cout<<ini->N <<"\t";
           lista(ini->prox);
     }
/*   while (ini!=NULL)
     {
           cout<<ini->N<<"\t";
           ini=ini->prox;
     }
*/
}

void consulta(cel &ini,int x)
{
     cel atual;
     atual = ini;
/*     while (x!= atual->N)
     {
           if(atual->prox != NULL)
                atual=atual->prox;
           else
                break;
     }
     if(x==atual->N)
           cout<<"existe o " <<x <<"\n";
     else
           cout<<"nao existe o " <<x <<"\n";*/
     if(x==atual->N)
         cout<<"existe o " <<x <<"\n";
     else
     {
         if(atual->prox==NULL)
             cout<<"nao existe o " <<x <<"\n";
         else
             consulta(atual->prox,x);
     }
}

void excluir (cel & ini, int x)
{
/*     cel atual, ant, prim ;
     if(ini->N==x)
     {
           prim=ini;
           ini=ini->prox;
           delete prim;
     }
     ant=ini;     
     while (ant->prox!=NULL&&ant->prox->N!=x)
           ant=ant->prox;
     if(ant->prox!=NULL)
           if(ant->prox->N==x)
           {
                  
                  atual=ant->prox;
                  ant->prox=atual->prox;
                  delete atual;
           }*/
     cel atual;
     if (ini->N==x)
     {
         atual=ini;
         ini=ini->prox;
         delete atual;
     }
     else
         excluir(ini->prox,x);
}

int main ()
{
    cel p;
    p=NULL;
    int num;
    do
    {
        cout<<"Digite um numero ";
        cin>>num;
        if(num<0)
                 break;
        insere(p,num);
    }
    while(1);
    lista(p);
    cout<<"\nDigite um numero para ser procurado ";
    cin>>num;
    consulta(p,num);
    cout<<"Digite um numero para ser deletado ";
    cin>>num;
    excluir(p,num);
    lista(p);
    cout<<"\n";
    system("pause");
    return 0;
}
