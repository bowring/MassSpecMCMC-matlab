%% AdaptMC_test.m
% A quick script to test out the adaptive monte carlo method at the
% beginning of Roberts and Rosenthal, 2008.


N = 20; % Number of parameter

% Create true posterior multivariate normal distribution
% Add diagonal term to prevent too much covariance
tmp = randn(N);
Sigma0 = tmp'*tmp+1*eye(N); 

% Create true posterior means
Mu0 = zeros(1,N);

%% Create initial model and covariance matrix

x0 = ones(1,N); % Initial model guess

% Do line search to determine best diagonal variance terms for "water
% level" part of proposal matrix

% Line search range/values - may need to extend based on target posterior
Nsearch = 201;
xtry = linspace(-50,50,Nsearch);

for jj = 1:N % Loop over model parameters
    
    for ii = 1:Nsearch; % Loop over line search terms
        xx=x0; % Set input model to initial
        xx(jj) = xtry(ii); % Change one model value at a time
        ptry(ii) = mvnpdf(xx,Mu0,Sigma0); % Calculate posterior 
    end
    
    % Mean model from line search
    xmtry(jj) = sum(ptry.*xtry)/sum(ptry); 
    
    % Model variance from line search
    xvtry(jj) = sum(ptry.*(xtry-xmtry(jj)).^2)/sum(ptry);      
    
    % Plot line search pdf with mean and standard deviation
    %figure(1);clf;
    %plot(xtry,ptry);hold on;plot(xmtry(jj)*[1 1],[0 max(ptry)],'k');
    %plot((xmtry(jj)+3*sqrt(xvtry(jj)))*[1 1],[0 max(ptry)],'k--');
    %plot((xmtry(jj)-3*sqrt(xvtry(jj)))*[1 1],[0 max(ptry)],'k--');
    %drawnow;pause;
 
end

if false
    % Initial covariance taken from diagonal of true covariance
    C0 = (0.1)^2*N^-1*diag(diag(Sigma0)); 
else
    % Initial covariance based on line search
    C0 = (0.1)^2*N^-1*diag(xvtry);
end

% Beta value from R&R
beta = 0.05; 

%% Initialize and run Adaptive MC

M = 100000; % Number of iterations
Msample = 1; % Save every mth iteration

cnt = 0; % Initialize counter

x = x0; % Initialize model
xmean = x0; % Initialize mean model
xcov = zeros(N,N); % Initialize covariance model

xall = zeros(M/Msample,N); % Initialize ensemble
proball = zeros(M/Msample,1); % Initialize likelihood
kept = zeros(M/Msample,1); % Initialize vector to track acceptance

tic
for ii = 1:M % Loop over AMC iterations
    
    if ii<=2*N  % Use initial covariance until 2*N
        
        C = C0; 
    else  % After that begin updating based on model covariance 
        % Covariance recalculated each step
        %C = beta*C0 + (1-beta)*2.38^2*N^-1*cov(xall);
        
        % Covariance calculated iteratively
        C = beta*C0 + (1-beta)*2.38^2*N^-1*xcov;
    end
    
    % Propose model update based on covariance
    dx = mvnrnd(zeros(1,N),C,1);
    
    % Proposed model
    x2 = x+dx;
    
    % Calculate likelihood in current and proposed models
    prob = mvnpdf(x,Mu0,Sigma0);
    prob2 = mvnpdf(x2,Mu0,Sigma0);
    
    % Acceptance ratio
    accept = prob2/prob;
    
    % If model accepted
    if accept>=rand
        kept(ii) = 1;
        
        % Retain new model and likelihood
        x=x2;
        prob = prob2;
    end
    
    % If saving model
    if mod(M,Msample) == 0;
        cnt = cnt+1; % Iterate counter
        xall(cnt,:) = x; % Save model to ensemble
        proball(cnt,1) = prob; % Save likelihood to ensemble
        
        % Calculate model mean and covariance
        xmeantmp = xmean;
        xmean = xmeantmp + (x-xmeantmp)/(cnt);
        xcov = xcov*(cnt)/(cnt+1) + (cnt)/(cnt+1)^2*(x-xmean)'*(x-xmeantmp);
    end
    
    
    
    
end
  
disp(sprintf('%.1f%% of %d iterations kept, runtime = %.1f s',sum(kept)/M*100,M,toc));

% Percent difference between true and model covariance
xoff = 100*abs((xcov-Sigma0)./Sigma0);

% Running tally of proportion of models kept
keptiter = cumsum(kept')./(1:(M));
