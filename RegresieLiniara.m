close all
clear all
clc

%%proiect
load('proj_fit_17.mat');

% se preiau datele de identificare cu care ne antrenam modelul matematic
yid= id.Y;     
xid1= id.X{1};  
xid2= id.X{2};  

% se reprezentare grafic datele de identificare (3D)
subplot(211)
mesh(xid1, xid2, yid) 
title("Date de Identificare");
xlabel('X1');
ylabel('X2');
zlabel('Y');

% se preiau datele cu care ne validam modelul matematic
yval= val.Y;     
xval1= val.X{1};  
xval2= val.X{2}; 

% se alege gradul maxim al polinomului 
m=11; 
%se calculeaza numarul de coloane
f= factorial(m+2)/(factorial(m)*factorial(m+2-m));
c=int32(f);% se converteste 'f' din double in int si se stocheaza in 'c'

%construim matricea de regresie pentru datele de identificare
phi= ones(length(xid1)*length(xid2), c);
philinie=1;% indexul liniilor 
for i=1:length(xid1)
    for j=1:length(xid2)
        phicoloana=1;% indexul coloanelor 
        for p1=0:m
            for p2=0:m
                % condiție pentru ca gradul maxim să fie `m`
                if p1+p2<=m
                     phi(philinie, phicoloana)= xid1(i).^p1*xid2(j).^p2;
                     phicoloana= phicoloana+1;
                end
            end
        end
        philinie= philinie+1;
    end
end

yid= reshape(yid,1, length(xid1)*length(xid2));% se transforma 'yid', care era matrice in vector linie
thetaid= phi\yid'; % se construieste matricea coeficientilor

yprimid= phi*thetaid;% se construieste aproximatorul polinmial
yprimid= reshape(yprimid,length(xid1),length(xid2));% se transforma 'yprim', care era vector linie in matrice

% se face graficul rezultat din aproximator pentru datle de identificare
subplot(212)
mesh(xid1, xid2, yprimid)
title("Functie aproximata dupa datele de identificare");
xlabel('X1');
ylabel('X2');
zlabel('Y');

% se face graficul pentru datele de validare pentru a putea compara functia
% aproximata si functia de la care s-a pornit
figure
subplot(211)
mesh(xval1, xval2, yval)
title("Date de Validare");
xlabel('X1');
ylabel('X2');
zlabel('Y');

%construim matricea de regresie pentru validare
phival= ones(length(xval1)*length(xval2), c);

philinie=1;% indexul liniilor 
for i=1:length(xval1)
    for j=1:length(xval2)
        phicoloana=1;% indexul coloanelor 
        for p1=0:m
            for p2=0:m
                % condiție pentru ca gradul maxim să fie `m`
                if p1+p2<=m
                     phival(philinie, phicoloana)= xval1(i).^p1*xval2(j).^p2;
                     phicoloana= phicoloana+1;
                end
            end
        end
        philinie= philinie+1;
    end
end

yval=reshape(yval, 1, length(xval1)*length(xval2));% se transforma 'yval', care era matrice in vector linie
thetaval= phival\yval';% se construieste matricea coeficientilor

yprimval= phival*thetaval;% se construieste aproximatorul polinomial pentru datele de validare
yprimval= reshape(yprimval, length(xval1), length(xval2));% se transforma 'yprimval', care era vector linie in matrice 

% reprezentare grafică a funcției aproximative pentru validare 
subplot(212)
mesh(xval1, xval2, yprimval)
title("Functie aproximata dupa datele de validare");
xlabel('X1');
ylabel('X2');
zlabel('Y');


%%Calculul erorii pătratice medii (MSE) pentru identificare și validare
m= 11;

MSEid= zeros(1, m);
MSEval= zeros(1, m);

for l=1:m
    f = factorial(l+2) / (factorial(l) * factorial(l+2 - l));
    c=int32(f);
    phi= ones(length(xid1)*length(xid2), c);

philinie=1;
for i=1:length(xid1)
    for j=1:length(xid2)
        phicoloana=1;
        for p1=0:l
            for p2=0:l
                if p1+p2<=l
                     phi(philinie, phicoloana)= xid1(i).^p1*xid2(j).^p2;
                     phicoloana= phicoloana+1;
                end
            end
        end
        philinie= philinie+1;
    end
end

yid= reshape(yid, 1, length(xid1)*length(xid2));
thetaid= phi\yid';

yprimid= phi*thetaid;
yprimid= reshape(yprimid, length(xid1), length(xid2));

phival= ones(length(xval1)*length(xval2), c);

philinie=1;
for i=1:length(xval1)
    for j=1:length(xval2)
        phicoloana=1;
        for p1=0:l
            for p2=0:l
                if p1+p2<=l
                     phival(philinie, phicoloana)= xval1(i).^p1*xval2(j).^p2;
                     phicoloana= phicoloana+1;
                end
            end
        end
        philinie= philinie+1;
    end
end
yval= reshape(yval, 1, length(xval1)*length(xval2));
thetaval= phival\yval';

yprimval= phival*thetaval;
yprimval= reshape(yprimval, length(xval1), length(xval2));

%se calculeaza MSE-ul pentru datele de identificare
eror= yid-yprimid(:)';
sumerori=0;
for i=1:length(xid1)*length(xid2)
    sumerori= sumerori+eror(i).^2;
end
MSEid(l)=(1/(length(xid1)*length(xid2)))*sumerori;

%se calculeaza MSE-ul pentru datele de validare
eror1= yval-yprimval(:)';
sumerori1=0;
for i=1:length(xval1)*length(xval2)
    sumerori1= sumerori1+eror1(i).^2;
end
MSEval(l)=(1/(length(xval1)*length(xval2)))*sumerori1; 
end

figure;
plot(MSEid);
grid on;
hold on;
plot(MSEval);

[MinMseVal, MseVal]=min(MSEval);%gaseste cea mai mica valoare a MSE-ului
plot(MseVal, MinMseVal,'r*');
title("Grafic MSE");
legend('MseVal', 'Mseid', 'Valoarea optima');
ylabel('Valoarea MSE');
xlabel('Gradul polinomului');
