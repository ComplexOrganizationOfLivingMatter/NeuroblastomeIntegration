function [m] = RandSimRepeticao(imin,imax,K)
% Retorna um arreglo de K valores entre imin e imax

if (imax-imin < K)
    fprintf(' Error:excede el rango\n');
    m = NaN;
    return
end

n = 0; %contador de # aleatorios
m = imin-1;
while (n < K)
    a = randi([imin,imax],1);
    if ((a == m) == 0)
        m = [m, a];
        n = n+1;
    end
end
m = m(:,2:end);