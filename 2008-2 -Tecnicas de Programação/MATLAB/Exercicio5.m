%ler as medidas das duas dimensoes de um retangulo, expressas em em "cm", e calcular e escrever as medidas do perimetro, da diagonal e da area dele
LADO = input ('Digite o lado do retangulo : ');
ALTURA = input ('Digite a altura do retangulo : ');
PERIMETRO = 2*LADO + 2*ALTURA;
AREA = LADO * ALTURA;
DIAGONAL = sqrt(LADO^2 + ALTURA^2);
fprintf('O perimetro do retangulo = %f, a area do retangulo = %f, diagonal do retangulo = %f',PERIMETRO,AREA,DIAGONAL);