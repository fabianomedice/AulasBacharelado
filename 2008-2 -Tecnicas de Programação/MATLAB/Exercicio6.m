%Ler a media do lado de um quadrado, expressa em metros. Calcular a area do quadrado externa ao circulo inscrito nele
LADO = input('Digite o lado do quadrado : ');
QUADRADO= LADO^2;
RAIO=LADO/2;
CIRCULO=pi*RAIO;
AREA=QUADRADO-CIRCULO;
fprintf('A area do quadrado externa ao circulo inscrito nele = %f',AREA);