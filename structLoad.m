load('BaseLoadData.mat', 'BaseLoadData');



parameters(10).ActiveLoad=BaseLoadData(:,1);
parameters(10).ReactiveLoad=BaseLoadData(:,2);
parameters(10).ub=[flip(BaseLoadData(2:33,1))' 0.99*ones(1,32)];
parameters(10).lb=[zeros(1,32) 0.8*ones(1,32)]; 
parameters(10).iteration=120;
parameters(10).dim=64;
parameters(10).agents=80;
parameters(10).obj=@NRLFA;

j=1:9
j=flip(j);


for i=j
    
    parameters(i).ActiveLoad=parameters(i+1).ActiveLoad*1.1
    parameters(i).ReactiveLoad= parameters(i+1).ReactiveLoad*1.1
    parameters(i).ub= [parameters(i+1).ub(1:32)*1.1 parameters(i+1).ub(33:64)]
    parameters(i).lb=parameters(i+1).lb
    parameters(i).iteration=120;
    parameters(i).dim=64;
    parameters(i).agents=80;
    parameters(i).obj=@NRLFA;
    
end

parameters=flip(parameters)