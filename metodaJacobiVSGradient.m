clc; clear; close all;
global tipex
tipex='ex1';
[A,b]=DataSistem;
max_iterations_jacobi=1000;
tolerance_jacobi=1e-6;
x_jacobi=jacobi(A,b,max_iterations_jacobi,tolerance_jacobi);
max_iterations_cg=1000;
tolerance_cg=1e-6;
x_conjugate_gradient= conjugate_gradient(A,b,max_iterations_cg,tolerance_cg);
disp('Solutia prin metoda Jacobi:'); disp(x_jacobi');disp('Solutia prin metoda Gradientului Conjugat:'); disp(x_conjugate_gradient');

function x=conjugate_gradient(A,b,max_iterations,tolerance)
    n=length(b);
    x=zeros(n, 1);
    r=b-A*x;
    p=r;
    for k=1:max_iterations
        alpha=(r'*r)/(p'*A*p);
        x=x+alpha*p;
        r_new=r-alpha*A*p;
        if norm(r_new,inf)<tolerance ...Verificare condiție de convergență
            break;
        end
        beta=(r_new'*r_new)/(r'*r);
        p=r_new+beta*p;
        r=r_new;
    end
end
function x=jacobi(A,b,max_iterations,tolerance)
    n=length(b);
    x=zeros(n,1);
    for k=1:max_iterations
        x_old=x;
        for i=1:n
            sigma=A(i,:)*x_old-A(i,i)*x_old(i);
            x(i)=(b(i)-sigma)/A(i,i);
        end
        if norm(x-x_old,inf)<tolerance
            break;
        end
    end
end
function [A,b]=DataSistem
global tipex
switch tipex 
    case 'ex1'
         A=[4,-1,0;-1,4,-1;0,-1,4];
         b = [15;10;10];
    case 'ex2'
        A = [3,1,1;1,-3,2;1,0,3];
        b = [9;7;14];
end
end