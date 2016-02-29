function show_img_data(X, Y, labels, varargin)
% Usage example:
%   X = csvread('new_image_sdve_train_data.csv');
%   Y = csvread('new_image_sdve_train_labels.csv');
%   labels = strsplit(fileread('token_names.txt'));
%   show_img_data(X, Y, labels, 1000)

if nargin > 2
    beginIdx = varargin{1};
else
    beginIdx = 1;
end

spN = 6;

figure('Units', 'normalized', 'Position', [0.1, 0.1, 0.8, 0.8]);

endIdx = beginIdx + spN * spN - 1;


while beginIdx <= size(X, 1)
    clf;
    
    scount = 1;
    
    for n = beginIdx : endIdx
        subplot(spN, spN, scount);
        scount = scount + 1;

        img = transpose(reshape(X(n, 1 : 1024), [32, 32]));

    %     subplot('Position', [0.1, 0.3, 0.8, 0.6]);
        cla;

        imagesc(img);
        colormap gray;

        [~, idx] = max(Y(n, :));
        title(labels{idx});

        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
    %     subplot('Position', [0.1, 0.05, 0.8, 0.22]);
    %     cla;
    %     plot(X(n, 1025 : end));
    %     set(gca, 'YLim', [-2, 3]);

    %     ginput(1);
    end
    
    a = input('Press enter to continue: ', 's');
    
    beginIdx = endIdx + 1;
    endIdx = min([endIdx + spN * spN, size(X, 1)]);
    
end

end