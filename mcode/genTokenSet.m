function genTokenSet(tokenSetFN)
%% Constants
tokenSet = {'*', '+', '-', '.', ',', '/', 'x', ...
            '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ...
            'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'T', ...
            'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', ...
            'i', 'k', 'l', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', ...
            'gr_al', 'gr_be', 'gr_ga', 'gr_de', 'gr_pi', ...
            'gr_Pi', 'gr_Si', 'integ', ...
            '(', ')', '[', ']', 'X', 'root', ...
            '=', 'lt', 'gt', 'lte', 'gte'};

%% Check input arguments 
if exist(tokenSetFN, 'file')
    error('Token set file already exists: %s', tokenSetFN);
end

[tokenSetPath] = fileparts(tokenSetFN);

if ~isempty(tokenSetPath) && ~isdir(tokenSetPath)
    error('Directory of token set file path does not exist: %s', tokenSetPath);
end

%%
hf = figure;

bDone = false;
set(gca, 'XLim', [0, 1]);
set(gca, 'YLim', [0, 1]);

recogWinners = {};
bounds = {};
while ~bDone
    xs = get(gca, 'XLim');
    ys = get(gca, 'YLim');
    
    crd1 = ginput(1);
    if crd1(1) < 0 || crd1(1) > 1 || crd1(2) < 0 || crd1(2) > 1
        bDone = true;
        continue
    end
    
    crd2 = ginput(1);
    
    xBnds = sort([crd1(1), crd2(1)]);
    yBnds = sort([crd1(2), crd2(2)]);
    
    bounds{end + 1} = [xBnds(1), yBnds(1), xBnds(2), yBnds(2)];
    recogWinners{end + 1} = input('recogWinner = ', 's');
    
    if isempty(strmatch(recogWinners{end}, tokenSet, 'exact'))
        error('Token name not found in token set');
    end
    
    rectangle('Position', [xBnds(1), yBnds(1), ...
                           xBnds(2) - xBnds(1), yBnds(2) - yBnds(1)], ...
              'FaceColor', 'none', 'EdgeColor', 'k');
	text(mean(xBnds), mean(yBnds), recogWinners{end}, 'FontSize', 20);
    
end

%% 
writeTokenSetFile(tokenSetFN, tokenSet, recogWinners, bounds);

end

function writeTokenSetFile(tokenSetFN, tokenSet, recogWinners, bounds)
fp = fopen(tokenSetFN, 'wt');

fprintf(fp, 'Token set: [');
for n = 1 : length(tokenSet)
    fprintf(fp, '%s', tokenSet{n});
    if n < length(tokenSet)
        fprintf(fp, ', ');
    else
        fprintf(fp, ']\n');
    end
end

fprintf(fp, '\n');

for n = 1 : length(recogWinners)
    bnds = bounds{n};
    bnds = [bnds(1), 1.0 - bnds(4), bnds(3), 1.0 - bnds(2)];
    
    fprintf(fp, 'bounds = [%.5f, %.5f, %.5f, %.5f]\n', ...
            bnds(1), bnds(2), bnds(3), bnds(4));
    fprintf(fp, 'recogWinner = %s\n', recogWinners{n});
    fprintf(fp, 'recogPs = [');
    for n = 1 : length(tokenSet)
        fprintf(fp, '0.00');
        if n < length(tokenSet)
            fprintf(fp, ', ');
        else
            fprintf(fp, ']\n');
        end
    end
    
    fprintf(fp, '\n');
end

fclose(fp);
end
