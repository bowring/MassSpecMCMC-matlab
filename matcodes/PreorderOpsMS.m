function oper_order = PreorderOpsMS(x,cnt)

% Inputs:
% x - struct containing model variables
% cnt - Number of random walk iterations to perform before adaptive MC
% Outputs:
% oper_order

% Find number of variables for each parameter type from model struct
Niso = length(x.lograt);
Nblock = length(x.I);
for ii=1:Nblock;
    Ncycle(ii) = length(x.I{ii});
end
Nfar = length(x.BL);
Ndf = 1;
Nsig = length(x.sig);

% Total number of variables
N = Niso+sum(Ncycle)+Nfar+Ndf+Nsig;

% How many permutations needed?
Npermutes = ceil(cnt/N);

oper_order= zeros(N*Npermutes,1);

for ii = 1:Npermutes
    oper_order((1+(ii-1)*N):ii*N,1) = randperm(N)';
end
















