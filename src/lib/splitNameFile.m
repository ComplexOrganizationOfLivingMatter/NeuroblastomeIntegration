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

    relevantInfo = strsplit(nameWithDirectories{end}, '_');
    
    [start,finish] = regexp(relevantInfo{1}, '[a-z][a-zA-Z]{9,}');
    algorithm = relevantInfo{1}(start:finish);
    pacientInit = relevantInfo{1}(finish+1:end);
    relevantInfo{1} = '';
    boolPositive = 1;
    core = '';
    pacient = '';
    for i = 1:size(relevantInfo, 2)
        [start,finish] = regexp(relevantInfo{i}, '[A-Z]{2,}[0-9]*');
        if isempty(start) == 0
            marker = relevantInfo{i}(start:finish);
        end
        [start, finish] = regexp(relevantInfo{i}, '[Y][0-9]+');
        if start == 1
            %pacient = strcat(pacientInit, relevantInfo{i}(start:finish));
            if relevantInfo{i}(end) == 'A' || relevantInfo{i}(end) == 'B'
                core = relevantInfo{i}(end);
            end
        end
        if size(strfind(lower(relevantInfo{i}), 'negat'), 1)
            boolPositive = 0;
        end
        
        if size(relevantInfo{i}, 2) == 1
            core = relevantInfo{i};
        end
    end
    
    if isempty(pacient)
        pacient = pacientInit;
    end
    
    if pacientInit(end) == 'A' || pacientInit(end) == 'B'
        core = pacientInit(end);
        pacient = pacientInit(1:end-1);
    end
    
%     [start,finish] = regexp(nameAlgorithm{1}, '[0-9][0-5]?');
%     marker = str2num(nameAlgorithm{1}(start:finish));
%     [start,finish] = regexp(nameAlgorithm{1}, '[a-zA-Z]+');
%     algorithm = nameAlgorithm{1}(start:finish);
%     if algorithm(1) == 'a'
%         secondPartAlgorithm = nameAlgorithm{size(nameAlgorithm, 2)};
%         [start, finish] = regexp(secondPartAlgorithm, '[a-zA-Z][a-oq-z]{3}[a-oq-zA-OQ-Z]{8,}');
%         algorithm = strcat(algorithm, '_', secondPartAlgorithm(start:finish));
%     end
%     
    

end