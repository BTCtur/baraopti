figure
%     Draw search space
%     subplot(1,2,1);
%     func_plot(Function_name);
   
   xlabel('x_1');
   ylabel('x_2');
%     zlabel([Function_name,'( x_1 , x_2 )'])
% 
%     Draw objective space
%     subplot(1,2,2);

for i=1:10
    gr(i)=semilogy(Results(i).Curve)
    hold on
%     semilogy(PSO_cg_curve,'Color','b')
    title('Iteration vs Loses for 10 Years')
    xlabel('Iteration');
    ylabel('Best score obtained so far');
    lab(i)=num2str(i)+". year";

    axis tight
    grid on
    box on
end
legend(gr,lab);
hold off

