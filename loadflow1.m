% Program for Bus Power Injections, Line & Power flows (p.u)...
% Updated on Jan-6-2018, Praviraj PG

function [LSij V Flow Flowlose Pi Qi Pg Qg Pl Ql ] = loadflow1(nb,V,del,BMva,BKv,BC,PVGEN,PVGENQ)

Y = ybusppg(nb);                % Calling Ybus program..
lined = linedatas(nb);          % Get linedats..
busd = busdatas1(nb,PVGEN,PVGENQ);            % Get busdatas..
Vm = pol2rect(V,del);           % Converting polar to rectangular..
Del = 180/pi*del;               % Bus Voltage Angles in Degree...
fb = lined(:,1);                % From bus number...
tb = lined(:,2);                % To bus number...
nl = length(fb);                % No. of Branches..
Pl = busd(:,7);                 % PLi..
Ql = busd(:,8);                 % QLi..

Iij = zeros(nb,nb);
Sij = zeros(nb,nb);
Si = zeros(nb,1);

% Bus Current Injections..
 I = Y*Vm;
 Im = abs(I);
 Ia = angle(I);
 
%Line Current Flows..
for m = 1:nl
    p = fb(m); q = tb(m);
    Iij(p,q) = -(Vm(p) - Vm(q))*Y(p,q); % Y(m,n) = -y(m,n)..
    Iij(q,p) = -Iij(p,q);
end
%Iij = sparse(Iij);     % Commented out..
Iijm = abs(Iij);
Iija = angle(Iij);

% Line Power Flows..
for m = 1:nb
    for n = 1:nb
        if m ~= n
            Sij(m,n) = Vm(m)*conj(Iij(m,n))*BMva;
        end
    end
end
%Sij = sparse(Sij);     % Commented out..
Pij = real(Sij);
Qij = imag(Sij);
 
% Line Losses..
Lij = zeros(nl,1);
for m = 1:nl
    p = fb(m); q = tb(m);
    Lij(m) = Sij(p,q) + Sij(q,p);
end
Lpij = real(Lij);
Lqij = imag(Lij);
LSij = abs(Lij);  %Kayýbýn görünür kýsmý  (MVA)

% Bus Power Injections..
for i = 1:nb
    for k = 1:nb
        Si(i) = Si(i) + conj(Vm(i))* Vm(k)*Y(i,k)*BMva;
    end
end
Pi = real(Si);
Qi = -imag(Si);
Pg = Pi+Pl;
Qg = Qi+Ql;

Flow=zeros(nb+1,9);
Flowlose=zeros(nl+1,11);
disp('#########################################################################################');
disp('-----------------------------------------------------------------------------------------');
disp('                              Newton Raphson Loadflow Analysis ');
%disp('-----------------------------------------------------------------------------------------');
disp('| Bus |    V   |  Angle  |     Injection      |     Generation     |          Load      |');
disp('| No  |   pu   |  Degree |    MW   |   MVar   |    MW   |  Mvar    |     MW     |  MVar |');
for m = 1:nb
    %disp('-----------------------------------------------------------------------------------------');
    fprintf('%3g', m); fprintf('  %8.4f', V(m)); fprintf('   %8.4f', Del(m));
    fprintf('  %8.3f', Pi(m)); fprintf('   %8.3f', Qi(m)); 
    fprintf('  %8.3f', Pg(m)); fprintf('   %8.3f', Qg(m)); 
    fprintf('  %8.3f', Pl(m)); fprintf('   %8.3f', Ql(m)) ; fprintf('\n');
    Flow(m,1)=m;
    Flow(m,2)=V(m);
    Flow(m,3)=Del(m);
    Flow(m,4)=Pi(m);
    Flow(m,5)=Qi(m);
    Flow(m,6)=Pg(m);
    Flow(m,7)=Qg(m);
    Flow(m,8)=Pl(m);
    Flow(m,9)=Ql(m);
end
%disp('-----------------------------------------------------------------------------------------');
fprintf(' Total                  ');fprintf('  %8.3f', sum(Pi)); fprintf('   %8.3f', sum(Qi)); 
fprintf('  %8.3f', sum(Pi+Pl)); fprintf('   %8.3f', sum(Qi+Ql));
fprintf('  %8.3f', sum(Pl)); fprintf('   %8.3f', sum(Ql)); fprintf('\n');
Flow(nb+1,4)=sum(Pi);
Flow(nb+1,5)=sum(Qi);
Flow(nb+1,6)=sum(Pi+Pl);
Flow(nb+1,7)=sum(Qi+Ql);
Flow(nb+1,8)=sum(Pl);
Flow(nb+1,9)=sum(Ql);

disp('-----------------------------------------------------------------------------------------');
disp('#########################################################################################');

disp('-------------------------------------------------------------------------------------');
disp('                              Line FLow and Losses ');
disp('-------------------------------------------------------------------------------------');
disp('|From|To |    P    |    Q     | From| To |    P     |   Q     |      Line Loss      |  Line Currents|');
disp('|Bus |Bus|   MW    |   MVar   | Bus | Bus|    MW    |  MVar   |     MW   |    MVar  |        A      |');
for m = 1:nl
    p = fb(m); q = tb(m);
 %   disp('-------------------------------------------------------------------------------------');
    fprintf('%4g', p); fprintf('%4g', q); fprintf('  %8.3f', Pij(p,q)); fprintf('   %8.3f', Qij(p,q)); 
    fprintf('   %4g', q); fprintf('%4g', p); fprintf('   %8.3f', Pij(q,p)); fprintf('   %8.3f', Qij(q,p));
    fprintf('  %8.3f', Lpij(m)); fprintf('   %8.3f', Lqij(m)); fprintf('   %8.3f',Iijm(p,q)*BC);
    fprintf('\n');
    Flowlose(m,1)=p;
    Flowlose(m,2)=q;
    Flowlose(m,3)=Pij(p,q);
    Flowlose(m,4)=Qij(p,q);
    Flowlose(m,5)=q;
    Flowlose(m,6)=p;
    Flowlose(m,7)=Pij(q,p);
    Flowlose(m,8)=Qij(q,p);
    Flowlose(m,9)=Lpij(m);
    Flowlose(m,10)=Lqij(m);
    Flowlose(m,11)=Iijm(p,q)*BC;
    
end
disp('-------------------------------------------------------------------------------------');
fprintf('   Total Loss                                       ');
fprintf('   %8.3f',sum(LSij)); fprintf('  %8.3f', sum(Lpij)); fprintf('   %8.3f', sum(Lqij));  fprintf('\n');
disp('-------------------------------------------------------------------------------------');
disp('#####################################################################################');
Flowlose(nl+1,8)=sum(LSij);
Flowlose(nl+1,9)=sum(Lpij);
Flowlose(nl+1,10)=sum(Lqij);