function [ marker, pacient, iteration, algorithm, boolPositive, core] = splitNameFile( nameFile )
%SPLITNAMEFILE Summary of this function goes here
%   Detailed explanation goes here
    nameFile;
    nameIteration = strsplit(nameFile, 'It');
    iteration = 0;
    if size(nameIteration, 2) > 1
        iteration = str2num(nameIteration{2});
    else
        nameIteration = strsplit(nameFile, 'Mask');
        if size(nameIteration, 2) > 1
            start = strfind(nameIteration{2}, 'Diamet');
            iteration = str2num(nameIteration{2}(1:start-1));
        end
    end

    nameWithDirectories = strsplit(nameIteration{1}, '/');
    nameAlgorithm = 0;
    for i = 1:size(nameWithDirectories, 2)
        if strcmp(nameWithDirectories{i}, 'Casos')
            pacient = nameWithDirectories{i+1};
        elseif i == size(nameWithDirectories, 2)
            nameAlgorithm = strsplit(nameWithDirectories{i}, '_');
        end
    end
    
    [start,finish] = regexp(nameAlgorithm{1}, '[0-9][0-5]?');
    marker = str2num(nameAlgorithm{1}(start:finish));
    [start,finish] = regexp(nameAlgorithm{1}, '[a-zA-Z]+');
    algorithm = nameAlgorithm{1}(start:finish);
    if algorithm(1) == 'a'
        secondPartAlgorithm = nameAlgorithm{size(nameAlgorithm, 2)};
        [start, finish] = regexp(secondPartAlgorithm, '[a-zA-Z][a-oq-z]{3}[a-oq-zA-OQ-Z]{8,}');
        algorithm = strcat(algorithm, '_', secondPartAlgorithm(start:finish));
    end
    
    boolPositive = 1;
    for i = 2:size(nameAlgorithm, 2)
        if (regexp(upper(nameAlgorithm{i}),'[0-9][0-9][B]?[0-9]{4,}[A-B]'))
           core = nameAlgorithm{i}(end); 
        end
        if size(strfind(lower(nameAlgorithm{i}), 'negat'), 1)
            boolPositive = 0;
        end
    end
    

end