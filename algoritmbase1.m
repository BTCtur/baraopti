
clear all; 
clc
tic
structLoad;
% SearchAgents_no=80; % Number of search agents
%                     %
% Function_name='NRFA'; % Name of the test function that can be from F1 to F23 (Table 1,2,3 in the paper)

% Max_iteration=120; % Maximum numbef of iterations
% 
% % Load details of the selected benchmark function
% lb=[zeros(1,32) 0.8*ones(1,32)];  %Lower boundy
% ub=[0.100000000000000 0.0900000000000000 0.120000000000000 0.0600000000000000 0.0600000000000000 0.200000000000000 0.200000000000000 0.0600000000000000 0.0600000000000000 0.0450000000000000 0.0600000000000000 0.0600000000000000 0.120000000000000 0.0600000000000000 0.0600000000000000 0.0600000000000000 0.0900000000000000 0.0900000000000000 0.0900000000000000 0.0900000000000000 0.0900000000000000 0.0900000000000000 0.420000000000000 0.420000000000000 0.0600000000000000 0.0600000000000000 0.0600000000000000 0.120000000000000 0.200000000000000 0.150000000000000 0.210000000000000 0.0600000000000000];  %Upper boundy
% ub=flip(ub);
% ub=[ub 0.99*ones(1,32)];
% %ilk 32 deðer sondan baþlayarak maximum bara güçleri ,son 32 deðer ise soondan baþlayarak maximum güç faktörü  
% dim=64;      %Sondaki üç baraya güç ekleniyor;
% fobj=@NRLFA;        %objektif fonksiyonu olarak Newton Raphson Yük analizi fonksiyonu ekleniyor
for i=1:10
    [Best_score,Best_pos,GWO_cg_curve]=GWO1(parameters(i));

    %[GBest_score,GBest_pos,PSO_cg_curve]=PSO1(SearchAgents_no,Max_iteration,lb,ub,dim,fobj); % run PSO to compare to results

    %figure('Position',[500 500 660 290])
    %Draw search space
    %subplot(1,2,1);
    %func_plot(Function_name);
    % title('Parameter space')
    % xlabel('x_1');
    % ylabel('x_2');
    % zlabel([Function_name,'( x_1 , x_2 )'])

    %Draw objective space
    %subplot(1,2,2);
    %figure=semilogy(GWO_cg_curve,'Color','r')
    %hold on
    %semilogy(PSO_cg_curve,'Color','b')
%     title('Objective space')
%     xlabel('Iteration');
%     ylabel('Best score obtained so far');
% 
%     axis tight
%     grid on
%     box on
%     %legend('GWO','PSO')
%     legend('GWO')
    display(['The best solution obtained by GWO is : ', num2str(Best_pos)]);
    display(['The best optimal value of the objective funciton found by GWO is : ', num2str(Best_score)]);
    fprintf('\n');
    Best_pos1=[Best_pos(1:32) 0 Best_pos(33:64) 0 ];
    [Flow, Flowlose]=NRLFA1(Best_pos1);
    powers=flip(Best_pos1(1:33));
    powerfactors=flip(Best_pos1(34:66));
    powersQ=powers.*tan(acos(powerfactors));
    display(['REAL POWERS (MW) : ', num2str(powers)]);
    display(['REACTÝVE POWERS (MVAR) : ', num2str(powersQ)]);
    display(['POWER FACTORS : ', num2str(powerfactors)]);
    
    Results(i).BestPositions=Best_pos1;
    Results(i).BestScore=Best_score;
    Results(i).Curve=GWO_cg_curve;
    Results(i).Powers= powers;
    Results(i).PF= powerfactors;
    Results(i).PowersQ= powersQ;
    Results(i).Flow= Flow;
    Results(i).FlowLose=Flowlose;
end
toc
% display(['The best solution obtained by PSO is : ', num2str(GBest_pos)]);
% display(['The best optimal value of the objective funciton found by PSO is : ', num2str(GBest_score)]);
