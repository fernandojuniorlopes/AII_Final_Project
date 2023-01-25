clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clearvars;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 20;
folder = pwd;
baseFileName = dir('all-miasz/*.pgm');
fid = fopen( 'exp.txt', 'w' );
for k = 1:length(baseFileName)
    if k < 10
        img_name = append('mdb00',string(k));
    elseif k <100
        img_name = append('mdb0',string(k));
    else
        img_name = append('mdb',string(k));
    end
    fullFileName = fullfile(folder, append('all-miasz/', img_name,'.pgm'));
    % Check if file exists.
    if ~exist(fullFileName, 'file')
        % The file doesn't exist -- didn't find it there in that folder.
        % Check the entire search path (other folders) for the file by stripping off the folder.
        fullFileNameOnSearchPath = baseFileName; % No path this time.
        if ~exist(fullFileNameOnSearchPath, 'file')
            % Still didn't find it.  Alert user.
            errorMessage = sprintf('Error: %s does not exist in the search path folders.', fullFileName);
            uiwait(warndlg(errorMessage));
            return;
        end
    end

    rgbImage = imread(fullFileName);
    original = rgbImage;
    if rem(k,2)== 0
        rgbImage = flip(rgbImage,2);
    end

    rgbImage = imcrop(rgbImage,[190 10 580 1024]);
    imgo = rgbImage;
    imgbi = imbinarize(rgbImage);
    L = bwareafilt(imgbi, 1);
    rgbImage(~L) = NaN;

    % Get the dimensions of the image.
    % numberOfColorChannels should be = 1 for a gray scale image, and 3 for an RGB color image.
    grayImage = rgbImage; % Initialize.
    [rows, columns, numberOfColorChannels] = size(grayImage);
%     grayImage = im2gray(rgbImage);
    grayImage = rgbImage;

    [rows, columns, numberOfColorChannels] = size(grayImage);

    lowThreshold = 190;
    highThreshold = 280;
    %previous highTreshold 280
    % https://www.mathworks.com/matlabcentral/fileexchange/29372-thresholding-an-image?s_tid=srchtitle
    % [lowThreshold, highThreshold] = threshold(lowThreshold, highThreshold, grayImage)
    binaryImage = grayImage > lowThreshold & grayImage <= highThreshold;

    binaryImage = imclearborder(binaryImage);
%     imshowpair(original,binaryImage,'montage');
%     pause(2)
    
    %********** Display the binary image.
%     title(string(k),'FontSize', fontSize, 'Interpreter', 'None');
%     subplot(1, 2, 1);
%     imshow(rgbImage,[]);
%     set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
%     drawnow;
%     subplot(1, 2, 2);
%     imshow(binaryImage, []);
%     pause(2)
    %**********

    stats = regionprops(binaryImage, 'Area', 'ConvexArea', 'Perimeter', 'Orientation', 'Centroid','MajorAxisLength','MinorAxisLength','Orientation','FilledArea');
    
    %Features
    allAreas = [stats.Area];
    allPerimeters = [stats.Perimeter];
    allCentroids = [stats.Centroid];

    totalAreaOfAllBlobs = max(allAreas);
    totalPerimeter = max(allPerimeters);
    avgArea = mean(allAreas);
    avgPer = mean(allPerimeters);
    meanCent = mean(allCentroids);
    diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
    mdiameters = max(diameters);
    
    %writing metrics to file
    fprintf( fid, '%s,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f\n', img_name, totalAreaOfAllBlobs, totalPerimeter,mdiameters, meanCent, avgArea, avgPer);
end
fprintf("PROGRAM ENDED\n")