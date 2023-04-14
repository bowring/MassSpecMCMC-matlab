function oper = RandomOperMS_Preorder(x,oper_order)

% Randomly generate next model operation, with or without hierarchical step


% Find number of variables for each parameter type from model struct
Niso = length(x.lograt);
Nblock = length(x.I);
for ii=1:Nblock;
    Ncycle(ii) = length(x.I{ii});
end
Nfar = length(x.BL);
Ndf = 1;
Nsig = length(x.sig);


if oper_order <= Niso;
    oper = 'changer';
elseif oper_order <= Niso + sum(Ncycle);
    oper = 'changeI';
elseif oper_order <= Niso + sum(Ncycle) + Nfar
    oper = 'changebl';
elseif oper_order <= Niso + sum(Ncycle) + Nfar + randi(Ndf)
    oper = 'changedfg';
else
    oper = 'noise';
end


    


