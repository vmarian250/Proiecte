clc
clear all
close all

load('iddata-05.mat');


% Datele de identificare și validare
uid=id.InputData;
yid=id.OutputData;

uval=val.InputData;
yval=val.OutputData;

figure
subplot(211);
plot(uid); grid on;
title('u de identificare');
subplot(212);
plot(yid); grid on;
title('y de identificare');

figure
subplot(211);
plot(uval); grid on;
title('u de validare');
subplot(212);
plot(yval); grid on;
title('y de validare');

%%
disp(['Interval uid:[', num2str(min(uid)),',',num2str(max(uid)),']']); 
disp(['Interval yid:[', num2str(min(yid)),',',num2str(max(yid)),']']);

% uid_norm=detrend(uid);
% uval_norm=detrend(uval);
% yid_norm=detrend(yid);
% yval_norm=detrend(yval);

uid_norm=(uid-mean(uid))/std(uid);
yid_norm=(yid-mean(yid))/std(yid);
uval_norm=(uval-mean(uval))/std(uval);
yval_norm=(yval-mean(yval))/std(yval);

disp(['Interval uid_norm:[',num2str(min(uid_norm)),',',num2str(max(uid_norm)),']']); ... se verificare intervale după detrend
disp(['Interval yid_norm:[',num2str(min(yid_norm)),',',num2str(max(yid_norm)),']']);
%%
% Parametrii modelului
na=5; % valoarea maximă pentru na
nb=5;
m=2;

MSEid=zeros(1,na);
MSEval=zeros(1,na);
MSEsimid=zeros(1,na);
MSEsimval=zeros(1,na);

for na=1:na
    phiId=MatriceaPHI(yid_norm,uid_norm,na,nb,m);
    thetaid=phiId\yid_norm;
    ypredictieId=phiId*thetaid;

    phiVal=MatriceaPHI(yval_norm,uval_norm,na,nb,m);
    ypredictieVal=phiVal*thetaid;

    % Generăm simularea pentru identificare
    ysimulareId=zeros(length(uid_norm),1);
    for k=1:length(uid_norm)
        ysimulareId(k) = 0;
        for i=1:na
            if k>i
                ysimulareId(k)=ysimulareId(k)-thetaid(i)*ysimulareId(k-i);
            end
        end
        for j=1:nb
            if k>j
                ysimulareId(k)=ysimulareId(k)+thetaid(na+j)*uid_norm(k-j);
            end
        end
        if m>1
            coloana=na+nb+1;
            for gr=2:m
                if k>gr-1
                    ysimulareId(k)=ysimulareId(k)+thetaid(coloana)*ysimulareId(k-1)^gr;
                    coloana=coloana+1;
                    ysimulareId(k)=ysimulareId(k)+thetaid(coloana)*uid_norm(k-1)^gr;
                    coloana=coloana+1;
                    ysimulareId(k)=ysimulareId(k)+thetaid(coloana)*(ysimulareId(k-1)*uid_norm(k-1))^(gr-1);
                    coloana=coloana+1;
                end
                if k>gr
                    ysimulareId(k)=ysimulareId(k)+thetaid(coloana)*ysimulareId(k-gr)*uid_norm(k-gr);
                    coloana=coloana+1;
                    ysimulareId(k)=ysimulareId(k)+thetaid(coloana)*ysimulareId(k-gr)*uid_norm(k-1);
                    coloana=coloana+1;
                end
            end
        end
    end
    
    %Facem simularea pentru validare
    ysimulareVal=zeros(length(uval_norm),1);
    for k=1:length(uval_norm)
        ysimulareVal(k)=0;
        for i=1:na
            if k>i
               ysimulareVal(k)=ysimulareVal(k)-thetaid(i)*ysimulareVal(k-i);
            end
        end
        for j=1:nb
            if k>j
               ysimulareVal(k)=ysimulareVal(k)+thetaid(na+j)*uval_norm(k-j);
            end
        end
        if m>1
           coloana=na+nb+1;
            for gr=2:m
                if k>gr-1
                    ysimulareVal(k)=ysimulareVal(k)+thetaid(coloana)*ysimulareVal(k-1)^gr;
                    coloana=coloana+1;
                    ysimulareVal(k)=ysimulareVal(k)+thetaid(coloana)*uval_norm(k-1)^gr;
                    coloana=coloana+1;
                    ysimulareVal(k)=ysimulareVal(k)+thetaid(coloana)*(ysimulareVal(k-1)*uval_norm(k-1))^(gr-1);
                    coloana=coloana+1;
                end
                if k>gr
                    ysimulareVal(k)=ysimulareVal(k)+thetaid(coloana)*ysimulareVal(k-gr)*uval_norm(k-gr);
                    coloana=coloana+1;
                    ysimulareVal(k)=ysimulareVal(k)+thetaid(coloana)*ysimulareVal(k-gr)*uval_norm(k-1);
                    coloana = coloana+1;
                end
            end
        end
   end


    % Calcularea MSE-urilor
    MSEid(na)=calculeaza_mse(yid, ypredictieId*std(yid)+mean(yid));
    MSEval(na)=calculeaza_mse(yval, ypredictieVal*std(yval)+mean(yval));
    MSEsimid(na)=calculeaza_mse(yid_norm, ysimulareId);
    MSEsimval(na)=calculeaza_mse(yval_norm, ysimulareVal);
end
 disp(['Mse identificare:', num2str(MSEid)]);
 disp(['Mse validare:', num2str(MSEval)]);
 disp(['Mse pe simulare identificare:', num2str(MSEsimid)]);
 disp(['Mse pe simulare validare:', num2str(MSEsimval)]);
%%
figure
plot(yid,'r','LineWidth',1.5); hold on; grid on;
plot(ypredictieId*std(yid)+mean(yid),'k--');
title('Identificare: Ieșire reală vs Ieșire de identificare prezisă');
xlabel('Timp');
ylabel('Amplitudine');
legend('Ieșire reală', 'Ieșire prezisă')

figure
plot(yval,'c','LineWidth',1.5); hold on; grid on;
plot(ypredictieVal*std(yval)+mean(yval),'k--');
title('Ieșire reală vs Ieșire prezisă pe datele de validare');
xlabel('Timp');
ylabel('Amplitudine');
legend('Ieșire reală', 'Ieșire prezisă');

figure
plot(yid_norm,'k','LineWidth',1.5); hold on; grid on;
plot(ysimulareId, 'g--', 'LineWidth', 1.5);
title('Ieșire reală vs Ieșire simulată pe datele de identificare');
xlabel('Timp');
ylabel('Amplitudine');
legend('Ieșire reală','Ieșire simulată');

figure
plot(yval_norm,'r','LineWidth',1.5); hold on; grid on;
plot(ysimulareVal, 'g--', 'LineWidth', 1.5);
title('Validare: Ieșire reală vs Ieșire simulată');
xlabel('Timp');
ylabel('Amplitudine');
legend('Ieșire reală', 'Ieșire simulată');

%% Plotare rezultate mse
figure;
subplot(211);
plot(1:na,MSEid,'-o'); grid on;
title('MSE pentru identificare');
xlabel('na'); 
ylabel('MSE');

subplot(212);
plot(1:na, MSEval, '-o'); grid on;
title('MSE pentru validare');
xlabel('na'); ylabel('MSE');

figure;
subplot(211);
plot(1:na, MSEsimid, '-o'); grid on;
title('MSE pentru simulare identificare');
xlabel('na'); ylabel('MSE');

subplot(212);
plot(1:na, MSEsimval, '-o'); grid on;
title('MSE pentru simulare validare');
xlabel('na');
ylabel('MSE');
%%
% Funcție pentru construirea matricei phi cu termeni liniari și neliniari
function phi=MatriceaPHI(y,u,na,nb,m)
    if m>1
        termeni_neliniari=m*(m+1)/2+(m-1)*2; % calculăm toate posibilitățile
    else
        termeni_neliniari=0;
    end
    phi=zeros(length(y),na+nb+termeni_neliniari);

    for k=1:length(y)
        % Termeni liniari
        for nA=1:na
            if k>nA
                phi(k,nA)=-y(k-nA);
            end
        end
        for nB=1:nb
            if k>nB
                phi(k,na+nB)=u(k-nB);
            end
        end
        % Termeni neliniari
        if m>1
            coloana=na+nb+1;
            for gr=2:m
                if k>gr-1
                    phi(k,coloana)=y(k-1)^gr;
                    coloana=coloana+1;
                    phi(k,coloana)=u(k-1)^gr;
                    coloana=coloana+1;
                    phi(k,coloana)=(y(k-1)*u(k-1))^(gr-1);
                    coloana=coloana+1;
                end
                if k>gr
                    phi(k,coloana)=y(k-gr)*u(k-gr);
                    coloana=coloana+1;
                    phi(k,coloana)=y(k-gr)*u(k-1);
                    coloana=coloana+1;
                end
            end
        end
    end
end
%%
function MSE=calculeaza_mse(real,predictie)
    e=real-predictie;
    MSE=mean(e.^2);
end