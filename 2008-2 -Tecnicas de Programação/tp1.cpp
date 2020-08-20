#include <iostream.h>

struct celula 
       {
       int conteudo;
       celula *prox;
       };
//---------------------------------------------
typedef celula *cel;
   // funçao para inserir    
//---------------------------------------------
void insere (cel &ini, int x)
{
     cel atual;
     if(ini==NULL)
     {
                 ini=new celula;
                 ini->conteudo=x;
                 ini->prox=NULL;
     }
     else
     {
                 atual=ini;
                 insere(atual->prox,x);
     }
}
//funçao para mostrar
//---------------------------------------------
void lista (cel &ini)
{
     if(ini!=NULL)
     {
           cout<<ini->conteudo <<"\t";
           lista(ini->prox);
     }
}
//funçao pedida
//---------------------------------------------
celula *busca (int x, celula *ini)
{
       int achou;
       celula *p;
       achou=0;
/* temos que tirar esse comando porque se nao ele nao pega o primeiro termo
       p = ini -> prox; 
       assim o comando certo e' o de baixo*/
       p = ini;
       while (p!=NULL && !achou)
       {
             if (p->conteudo == x)
             {
                achou = 1;
// temos que ter um break porque se nao ele passa para o proximo termo
                break;
             }
             p=p->prox;
       }
       if (achou)
          return p;
       else
           return NULL;
}
//funcao principal
//---------------------------------------------
int main ()
{
    cel p,y;
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
    cout<<"\nDigite um numero para buscar ";
    cin>>num;
    y=busca(num,p);
    if(y!=NULL)
        cout<<"O elemento procurado "<<y->conteudo <<" esta no endereco " <<y <<"\n";
    else
        cout<<"O elemento nao se encontra na lista \n";
    system ("pause");
    return 0;
}
