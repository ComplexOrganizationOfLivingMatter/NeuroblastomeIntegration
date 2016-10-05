function [m] = Chose_seeds_positions(xMin,xMax,yMax,numPoints,minDistanceBetweenPoints)

% Resolve K random values between imin and imax
if ((xMax-(xMin-1))*(yMax-(xMin-1)) < numPoints)
    fprintf(' Error: Excede el rango\n');
    m = NaN;
    return
end

m(1,1) = randi([xMin,xMax],1);
m(1,2) = randi([xMin,yMax],1);

n=1;

while (n<=numPoints-1)

    a = randi([xMin,xMax],1);
    b = randi([xMin,yMax],1);
    dato=[a,b];

    for i=1:size(m,1)
        distance=sqrt(((m(i,1)-a)^2)+((m(i,2)-b)^2));
    
        if distance<=minDistanceBetweenPoints
            ind(i)=1;
        else
            ind(i)=0;
        end
    end

    if sum(ind)==0
        dato=[a,b];
        m = [m; dato];
        n=n+1;
    end

end

m = m(1:end,:);