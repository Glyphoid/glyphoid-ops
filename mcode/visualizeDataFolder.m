function visualizeDataFolder(folderPath)
if ~isdir(folderPath)
    error('Folder does not exist');
end

%% Determine the dump (vault) directory
[dataRootDir, dirName] = fileparts(folderPath);
[rootDir, dataRootDir0] = fileparts(dataRootDir);
dumpRootDir = fullfile(rootDir, [dataRootDir0, '_dump']);
if ~isdir(dumpRootDir)
    error('Dump root directory has not been created');
end

dumpDir = fullfile(dumpRootDir, dirName);
if isdir(dumpDir)
    fprintf('Dump directory already exists: %s\n', dumpDir);
else
    if mkdir(dumpDir);
        fprintf('Created dump directory: %s\n', dumpDir);
    else
        error('Failed to create dump directory: %s\n', dumpDir);
    end
end


%%

% List all the wt files
dwt = dir(fullfile(folderPath, '*.wt'));
fprintf('Found %d .wt files\n', length(dwt));

%%
letters = {};
strokes = {};
filePaths = {};

for n = 1 : length(dwt)
    fullPath = fullfile(folderPath, dwt(n).name);
    
    try
        strokeData = readWrittenToken(fullPath);
        %         fprintf('Read data from file: %s\n', fullPath);
    catch MException
        warning(sprintf('Failed to read data from file: %s', fullPath));
    end
    
    idx = strmatch(strokeData.tokenName, letters, 'exact');
    if isempty(idx)
        letters{end + 1} = strokeData.tokenName;
        strokes{end + 1} = {strokeData.strokes};
        filePaths{end + 1} = {fullPath};
    else
        strokes{idx}{end + 1} = strokeData.strokes;
        filePaths{idx}{end + 1} = fullPath;
    end
    
end

%% Sort the data
[letters, sortIdx] = sort(letters);
strokes = strokes(sortIdx);
filePaths = filePaths(sortIdx);

uiData.letters = letters;
uiData.strokes = strokes;
uiData.filePaths = filePaths;

uiData.dumpDir = dumpDir;

%% UI creation
hFig = figure('Units', 'Normalized', 'Position', [0.1, 0.2, 0.8, 0.6]);

uiCtrls.tokenListBox = uicontrol('Parent', hFig, 'Units', 'Normalized', ...
    'Position', [0.05, 0.05, 0.10, 0.9], ...
    'Style', 'listbox', ...
    'String', letters);

uiCtrls.fileListBox = uicontrol('Parent', hFig, 'Units', 'Normalized', ...
    'Position', [0.16, 0.05, 0.25, 0.9], ...
    'Style', 'listbox', ...
    'String', {});

uiCtrls.tokenAxes = axes('Parent', hFig, 'Units', 'Normalized', ...
    'Position', [0.45, 0.05, 0.52, 0.8]);

uiCtrls.moveToDump = uicontrol('Parent', hFig, 'Units', 'Normalized', ...
    'Style', 'pushbutton', 'String', 'Move to dump', ...
    'Position', [0.45, 0.9, 0.1, 0.05]);


uiCtrls.tokenListBox.Callback = {@tokenListBoxCallback, uiData, uiCtrls};
uiCtrls.fileListBox.Callback  = {@fileListBoxCallback, uiData, uiCtrls};
uiCtrls.moveToDump.Callback   = {@moveToDumpCallback, uiData, uiCtrls};

uiCtrls.fileListBox.KeyPressFcn = {@fileListBoxKeyPressFcn, uiData, uiCtrls};
end

function fileListBoxKeyPressFcn(src, event, uiData, uiCtrls)
if uiCtrls.fileListBox.Value == length(uiCtrls.fileListBox.String) && ...
        isequal(event.Key, 'downarrow')
    %     disp('Paging!');
    
    if uiCtrls.tokenListBox.Value < length(uiCtrls.tokenListBox.String)
        uiCtrls.fileListBox.Value = 1;
        uiCtrls.tokenListBox.Value = uiCtrls.tokenListBox.Value + 1;
        
        tokenListBoxCallback(src, event, uiData, uiCtrls);
        fileListBoxCallback(src, event, uiData, uiCtrls);
    end
end

end

function drawStrokeData(strokeData)
%% Constants
lineStyles = {'bo-', 'bs-', 'b^-'};
%%

cla;
hold on;

if ~iscell(strokeData)
    error('Unexpected stroke data type (not cell)');
end

nStrokes = length(strokeData);
legendTexts = {};
for n = 1 : nStrokes
    plot(strokeData{n}.xs, -strokeData{n}.ys, lineStyles{mod(n, 3) + 1});
    legendTexts{end + 1} = sprintf('Stroke %d', n);
end

for n = 1 : nStrokes
    plot(strokeData{n}.xs(1), -strokeData{n}.ys(1), 'x', 'MarkerSize', 13);
end

axis equal;

legend(legendTexts);

end

function moveToDumpCallback(src, event, uiData, uiCtrls)
value = uiCtrls.fileListBox.Value;
fileNames = uiCtrls.fileListBox.String;
if value < 1 || value > length(fileNames)
    return;
end

fileName = fileNames{value};

movefile(fileName, uiData.dumpDir);
fprintf('Moved file %s to dump directory\n', fileName);

[fileDir, fileName0] = fileparts(fileName);
imFileName = fullfile(fileDir, [fileName0, '.im']);
movefile(imFileName, uiData.dumpDir);
fprintf('Moved file %s to dump directory\n', imFileName);

% uiCtrls.fileListBox.String = fileNames(1 : length(fileNames) ~= value);
% if value > length(uiCtrls.fileListBox.String)
%     uiCtrls.Value = length(uiCtrls.fileListBox.String);
% else
%     uiCtrls.Value = value;
% end


end

function tokenListBoxCallback(src, event, uiData, uiCtrls)
items = uiCtrls.tokenListBox.String;
selectedToken = items{uiCtrls.tokenListBox.Value};

filePaths = uiData.filePaths{uiCtrls.tokenListBox.Value};
if uiCtrls.fileListBox.Value > 1
    uiCtrls.fileListBox.Value = 1;
end
uiCtrls.fileListBox.String = filePaths;

end

function fileListBoxCallback(src, event, uiData, uiCtrls)
idxToken = uiCtrls.tokenListBox.Value;
idxFile  = uiCtrls.fileListBox.Value;

strokeData = uiData.strokes{idxToken}{idxFile};

set(gcf, 'CurrentAxes', uiCtrls.tokenAxes);
drawStrokeData(strokeData);


end