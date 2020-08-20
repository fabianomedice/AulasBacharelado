#include<iostream>
using namespace std;
struct celula{
       float N;
       celula *dir, *esq;
       };
typedef celula *arvore;
void insere(float x, arvore &raiz)
{
     if(raiz==NULL)
     {
      raiz = new celula;
      raiz->N = x;
      raiz->esq=NULL;
      raiz->dir=NULL;
      return;             
     }       
     else
     {
      if(x<raiz->N)
        insere(x,raiz->esq);
      else
        insere(x,raiz->dir);
     }
}
void inordem(arvore &raiz)
{
 if(raiz == NULL)
   return;
 else
 {
  inordem(raiz->esq);
  cout << raiz->N << "\t" ;
  inordem(raiz->dir);
 }
}
void preordem(arvore &raiz)
{
     
     if(raiz==NULL)
        return;
     else
     {
         cout<<raiz->N<<"\t";
         preordem(raiz->esq);
         preordem(raiz->dir);
     }
}
void posordem(arvore &raiz)
{
     if(raiz==NULL)
         return;
     else
     {
         posordem(raiz->esq);
         posordem(raiz->dir);
         cout<<raiz->N<<"\t";
     }
}
void antecessor(arvore &p,arvore &raiz)
{
     arvore aux;
     if(raiz->dir!=NULL)
     {
      antecessor(p,raiz->dir);
      return;            
     }
     p->N = raiz->N;
     aux=raiz;                   
     raiz = raiz->esq;
     delete aux;                   
}
void retira(float x,arvore &raiz)
{
     if(raiz==NULL)
     {
        cout<<"\nRegisto inexistente.";
        return;
     }
     if(x<raiz->N)
     {
        retira(x,raiz->esq);
        return;
     }
     if(x>raiz->N)
     {
        retira(x,raiz->dir);
        return;
     }
     if(raiz->dir==NULL)
     {
      arvore aux = raiz;
      raiz = raiz->esq;
      delete aux;
      return;                   
     }
     if(raiz->esq!=NULL)
     {
      antecessor(raiz,raiz->esq);
      return;                  
     }
     arvore aux = raiz;
     raiz = raiz->dir;
     delete aux;
}     
int main(void)
{
 float x, N;
 arvore p;
 p = NULL;
 cout << "Insira os elemesto na arvore:\n\n";
 do{
    cin >> N;
    cout << "\n";
    if(N >= 0)
    {
     insere(N,p);
    }
    else
     break;
  }
  while(1);
  cout << endl;
  cout<<"Inordem\n";
  inordem(p);
  cout << endl;
  cout<<"preordem\n";
  preordem(p);
  cout << endl;
  cout<<"posordem\n";
  posordem(p);
  cout << endl;  
  cout << "Digite um elemento a ser excluido da lista:\n ";
  cin >> x; 
  retira(x,p);
  cout << endl;
  inordem(p);
  cout << endl << endl;
  system("pause");
  return 0;
}     
                                
