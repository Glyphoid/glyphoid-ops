function wt = readWrittenToken(wtFN)
f = fopen(wtFN, 'rt');
txt = textscan(f, '%s', 'delimiter', '\n');
fclose(f);

txt = txt{1};

wt.tokenName = strrep(txt{1}, 'Token name: ', '');
wt.nStrokes = str2double(strrep(strrep(txt{2}, 'CWrittenToken (nStrokes=', ''), '):', ''));
wt.strokes = cell(1, wt.nStrokes);

lineNum = 3;

xMin = Inf;
yMin = Inf;
xMax = -Inf;
yMax = -Inf;

for n = 1 : wt.nStrokes
    t_stroke = struct;
    t_stroke.np = str2double(strrep(strrep(txt{lineNum}, 'Stroke (np=', ''), '):', ''));
    
    lineNum = lineNum + 1;
    
    xs_str = strrep(strrep(txt{lineNum}, 'xs=[', ''), ']', '');
    xs_items = strsplit(xs_str, ', ');
    t_stroke.xs = cellfun(@str2double, xs_items);
    
    lineNum = lineNum + 1;
    
    if min(t_stroke.xs) < xMin
        xMin = min(t_stroke.xs);
    end
    if max(t_stroke.xs) > xMax
        xMax = max(t_stroke.xs);
    end
    
    ys_str = strrep(strrep(txt{lineNum}, 'ys=[', ''), ']', '');
    ys_items = strsplit(ys_str, ', ');
    t_stroke.ys = cellfun(@str2double, ys_items);
    
    lineNum = lineNum + 1;
    
    if min(t_stroke.ys) < yMin
        yMin = min(t_stroke.ys);
    end
    if max(t_stroke.ys) > yMax
        yMax = max(t_stroke.ys);
    end
    
    wt.strokes{n} = t_stroke;
end

wt.xMin = xMin;
wt.yMin = yMin;
wt.xMax = xMax;
wt.yMax = yMax;


end