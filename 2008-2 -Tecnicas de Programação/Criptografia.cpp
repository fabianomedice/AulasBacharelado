#include<iostream.h>
#include<math.h>
int main (void)
{
    int i;
    char a[49],v[49];
    for (i=0;i<48;i++)
        a[i]=' ';
    a[48]='\0';
    cout<<"Digite a frase\n";
    gets(a);
    for(i=0;i<48;i++)
        if(a[i]=='\0')
             a[i]=' ';
    cout<<"A frase e'\n";
    for(i=0;i<48;i++)
        cout<<a[i];
    for(i=0;i<4;i++)
    {
        v[0+i*12]=a[9+i*12];
        v[1+i*12]=a[10+i*12];
        v[2+i*12]=a[5+i*12];
        v[3+i*12]=a[1+i*12];
        v[4+i*12]=a[11+i*12];
        v[5+i*12]=a[0+i*12];
        v[6+i*12]=a[2+i*12];
        v[7+i*12]=a[6+i*12];
        v[8+i*12]=a[8+i*12];
        v[9+i*12]=a[3+i*12];
        v[10+i*12]=a[4+i*12];
        v[11+i*12]=a[7+i*12];
    }
    v[48]=a[48];
    cout<<"\nA frase criptografada e'\n";
    for(i=0;i<48;i++)
    {
        cout<<v[i];
    }
    cout<<"\n";
    system ("pause");
    return 0;
}
