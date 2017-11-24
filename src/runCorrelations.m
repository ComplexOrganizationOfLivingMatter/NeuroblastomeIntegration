
markersTable = PercentageOfFibre;

nonEmptyCases = cellfun(@(x) isempty(x) == 0, markersTable.Riskreal);
highRiskCases = cellfun(@(x) isequal(x, 'NoRisk') == 0, markersTable.Riskreal);
disp('High risk real')
correlatingMarkers( markersTable(highRiskCases & nonEmptyCases, :) )
disp('No risk real')
correlatingMarkers( markersTable(highRiskCases == 0 & nonEmptyCases, :) )

nonEmptyCases = cellfun(@(x) isempty(x) == 0, markersTable.Riskcalculated);
highRiskCases = cellfun(@(x) isequal(x, 'NoRisk') == 0, markersTable.Riskcalculated);
disp('High risk')
correlatingMarkers( markersTable(highRiskCases & nonEmptyCases, :) )
disp('No risk')
correlatingMarkers( markersTable(highRiskCases == 0 & nonEmptyCases, :) )

nonEmptyCases = cellfun(@(x) isempty(x) == 0, markersTable.Instability);
highRiskCases = cellfun(@(x) isequal(x, 'High'), markersTable.Instability);
disp('High instability')
correlatingMarkers( markersTable(highRiskCases & nonEmptyCases, :) )
disp('Rest Instability')
correlatingMarkers( markersTable(highRiskCases == 0 & nonEmptyCases, :) )



noNaNsFeatures=table2array(markersTable(:, 5:end));
nanRows = isnan(noNaNsFeatures);
totalFibreNoNaNs = totalFibre(any(nanRows, 2) == 0, :);
noNaNsFeatures = noNaNsFeatures(any(nanRows, 2) == 0, :);
X = noNaNsFeatures;
meanCCs=mean(X,2);

for i = 1:size(X,2)
    X(:,i) = X(:,i) - meanCCs;
end

L = X'*X;

%Calculate autovectors/eigenvalues
[eigenvectors,eigenvalues] = eig(L);
[sortedEigenvalues, ind]=sort(diag(eigenvalues),'descend');   % sort eigenvalues
V=eigenvectors(:,ind);

%Convert  eigenvalues of X'X in autovectors of X*X'
eigenvectors = X*V;

% Normalize autovectors to achieve an unitary length
for i=1:size(X,2)
    eigenvectors(:,i) = eigenvectors(:,i)/norm(eigenvectors(:,i));
end

V=eigenvectors(:,1:2);

figure;
title('Instability')
hold on;
for numRow = 1:size(V, 1)
    if isequal(totalFibreNoNaNs.Instability{numRow}, 'High')
        plot(V(numRow, 1), V(numRow, 2), '.r','MarkerSize',30)
    else
        plot(V(numRow, 1), V(numRow, 2), '.g','MarkerSize',30)
    end
end

figure;
title('Riskcalculated')
hold on;
for numRow = 1:size(V, 1)
    if isequal(totalFibreNoNaNs.Riskcalculated{numRow}, 'HighRisk')
        plot(V(numRow, 1), V(numRow, 2), '.r','MarkerSize',30)
    else
        plot(V(numRow, 1), V(numRow, 2), '.g','MarkerSize',30)
    end
end

figure;
title('RiskReal')
hold on;
for numRow = 1:size(V, 1)
    if isequal(totalFibreNoNaNs.Riskreal{numRow}, 'HighRisk')
        plot(V(numRow, 1), V(numRow, 2), '.r','MarkerSize',30)
    else
        plot(V(numRow, 1), V(numRow, 2), '.g','MarkerSize',30)
    end
end
