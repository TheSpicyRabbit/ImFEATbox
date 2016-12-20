function [SegmentedImage BinaryImage] = Segmentation(I, Margin , Iteration, Smoothness,plotflag)
% Function to segment the MR images based on Chan-Vese model
%
% Input     - I: A 2D image. Color images will be converted to grayscale                
%           - Margin: Margin values from the edges of the image for 
%             rectangular initial masking. Binary image representing 
%             initialization. Initial state position being close to object.
%           - Iteration: Number of iterarions to run for Chan-Vese model  
%           - Smoothness: Smoothnes Factor. Higher value leads to smoother
%             boundaries, smooth out details.
%           - plotflag: flag to enable/disable visualization
%
% Output    - SegmentedImage: The main image with black backgrounds
%           - BinaryImage: The black and white map of segmentation.
%            (1: foreground, 0: background)
%
%
% ************************************************************************
% Implemented for MRI feature extraction by the Department of Diagnostic
% and Interventional Radiology, University Hospital of Tuebingen, Germany
% and the Institute of Signal Processing and System Theory University of
% Stuttgart, Germany. Last modified: Dezember 2016
%
% This implementation is part of ImFEATbox, a toolbox for image feature
% extraction and analysis. Available online at:
% https://github.com/annikaliebgott/ImFEATbox
%
% Contact: annika.liebgott@iss.uni-stuttgart.de
% ************************************************************************
%
% Implementation based on:  T. F. Chan and L. A. Vese, "Active contours 
%                           without edges", Image processing, 
%                           IEEE transactions on, vol. 10, no. 2, 
%                           pp. 266–277, 2001."


% Check for color image and convert to the grayscale
if(numel(size(I))==3)       %if image is 3D
    if(size(I,3)==3)
        I = rgb2gray(I);
    end
end

% Initialization
MaskImage = zeros(size(I));
MaskImage(Margin:size(I,1)-Margin,Margin:size(I,2)-Margin)=1;
MaskImage = double(MaskImage);


% Check whether the MaskImage and original image sizes are the same and
% raise an error
if(any(size(I)~=size(MaskImage)))
    error('Image and MaskImage Must Be in The Same Size');
end

% Perform segmentation by means of Chan-Vese model MATLAB function.
BinaryImage = activecontour(I,MaskImage,Iteration,'Chan-Vese',Smoothness);

[a b] = find(BinaryImage==1);

SegmentedImage = zeros([abs(max(a)-min(a)) abs(max(a)-min(a))]);

% Replace the background with zero pixels
for i=1:1:size(BinaryImage,1)
    for j=1:1:size(BinaryImage,2)
        if BinaryImage (i,j) == 1;
            SegmentedImage(i,j) = I(i,j);
        end
    end
end

if plotflag==1
    % display results
    figure; subplot(2,2,1)
    imagesc(I); axis image; colormap gray;
    title('The Main Image');
    
    subplot(2,2,2)
    imagesc(MaskImage); axis image; colormap gray;
    title('The Initialization');
    
    subplot(2,2,3)
    imagesc(BinaryImage); axis image; colormap gray;
    title('The Final Segmenatation Output');
    
    subplot(2,2,4)
    imagesc(I); axis image; colormap gray;
    hold on;
    contour(BinaryImage,[0 0],'b','linewidth',3);
    hold off;
    title('The Image With the Segmentation Shown in Blue');
end
