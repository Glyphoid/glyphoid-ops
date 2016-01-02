function showTokenSet(tsFN)
%%
bndsStr = 'bounds = [';
recogWinnerStr = 'recogWinner = ';

fontSize = 20;

%%
lines = textread(tsFN, '%s', 'delimiter', '\n');

%%
rectBnds = zeros(0, 4);
recogWinners = {};
for i1 = 1 : length(lines)   
    tline = deblank(lines{i1});
    if isempty(tline) 
        continue;
    end
    if length(tline) > length(bndsStr) && ...
       strcmp(tline(1 : length(bndsStr)), bndsStr)
        numStrs = strsplit(strrep(strrep(tline, bndsStr, ''), ']', ''), ', ');
        rectBnds = [rectBnds; [str2double(numStrs{1}), ...
                               str2double(numStrs{2}), ...
                               str2double(numStrs{3}), ...
                               str2double(numStrs{4})]];
        recogWinners{end + 1} = strrep(lines{i1 + 1}, recogWinnerStr, '');
    end
end
recogWinners

%%
figure;
for i1 = 1 : size(rectBnds, 1)
    rectangle('Position', [rectBnds(i1, 1), -rectBnds(i1, 4), ...
                           rectBnds(i1, 3) - rectBnds(i1, 1), ...
                           rectBnds(i1, 4) - rectBnds(i1, 2)]);
	text(rectBnds(i1, 1), -0.5 * (rectBnds(i1, 2) + rectBnds(i1, 4)), recogWinners{i1}, 'FontSize', fontSize);
end

end