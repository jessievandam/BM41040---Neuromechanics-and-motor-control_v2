%% 3) Initialize Covariance and State Estimates

xPrioriArray(1,:) = A*x0+B*u0;
pPriori = A*P0*A.'+Q;
pPrioriArray(1,:,:) = pPriori;

%% 4) Run the Kalman Filter


for i = 1:(length(u)-1)
    M = pPriori*C.'/(C*pPriori*C.'+R);
    MArray(i,:,:) = M;
    xPosterioArray(i,:) = xPrioriArray(i,:)+(M*(Z(i,:).'-C*xPrioriArray(i,:).')).';
    pPosterio = pPriori-M*C*pPriori;
    pPosterioArray(i,:,:) = pPosterio;
    
    xPrioriArray(i+1,:) = (A*xPosterioArray(i,:).').'+B.'*u(i,:);
    pPriori = A*pPosterio*A.'+Q;
    pPrioriArray(i+1,:,:) = pPriori;
end