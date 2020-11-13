k = [500 750 1000];
nK = numel(k);
Sigma = {'full'};
nSigma = numel(Sigma);
SharedCovariance = {true};
SCtext = {'true'};
RegularizationValue = 0.01;
nSC = numel(SharedCovariance);
options = statset('MaxIter',1000, 'Display', 'iter');

formatted_protein_base_file_location = '../../../protein_base/formatted_protein_base.txt';
distance_matrix = importdata(formatted_protein_base_file_location);
distance_matrix = distance_matrix(:, 2:67);

% Preallocation
gm = cell(nK,nSigma,nSC);
aic = zeros(nK,nSigma,nSC);
bic = zeros(nK,nSigma,nSC);
converged = false(nK,nSigma,nSC);

% Fit all models
% for m = 1:nSC
%     for j = 1:nSigma
%         for i = 1:nK
%             gm{i,j,m} = fitgmdist(distance_matrix,k(i),...
%                 'CovarianceType',Sigma{j},...
%                 'SharedCovariance',SharedCovariance{m},...
%                 'RegularizationValue',RegularizationValue,...
%                 'Options',options);
%             aic(i,j,m) = gm{i,j,m}.AIC;
%             bic(i,j,m) = gm{i,j,m}.BIC;
%             converged(i,j,m) = gm{i,j,m}.Converged;
%         end
%     end
% end
% 
% allConverge = (sum(converged(:)) == nK*nSigma*nSC);

figure;
bar(reshape(aic,nK,nSigma*nSC));
title('AIC para os valores de $k$ do trabalho e escolhas de $\Sigma$ avaliadas','Interpreter','latex');
xlabel('$k$','Interpreter','Latex');
ylabel('AIC');
legend('Completa-compartilhada');

figure;
bar(reshape(bic,nK,nSigma*nSC));
title('BIC para os valores de $k$ do trabalho e escolhas de $\Sigma$ avaliadas','Interpreter','latex');
xlabel('$k$','Interpreter','Latex');
ylabel('BIC');
legend('Completa-compartilhada');

