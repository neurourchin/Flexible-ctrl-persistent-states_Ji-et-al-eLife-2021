function smbnd = sgolay_smbound(imbin,winwidth,pbool)
% Get rid of holes in the blobs.
imbin = imfill(imbin, 'holes');
%---------------------------------------------------------------------------
% Extract the largest area using our custom function ExtractNLargestBlobs().
numberToExtract = 1;
biggestBlob = ExtractNLargestBlobs(imbin, numberToExtract);
%---------------------------------------------------------------------------
% Now get the boundaries.
boundaries = bwboundaries(biggestBlob);
numberOfBoundaries = size(boundaries, 1);
for k = 1 : numberOfBoundaries
	thisBoundary = boundaries{k};
    hold all
% 	plot(thisBoundary(:,2), thisBoundary(:,1), 'g', 'LineWidth', 2);
end

firstBoundary = boundaries{1};
% Get the x and y coordinates.
x = firstBoundary(:, 2);
y = firstBoundary(:, 1);

% Now smooth with a Savitzky-Golay sliding polynomial filter
if isempty(winwidth)
    winwidth = 35;
end
polynomialOrder = 2;
smbnd.X = sgolayfilt(x, polynomialOrder, winwidth);
smbnd.Y = sgolayfilt(y, polynomialOrder, winwidth);

if pbool
% axis image; % Make sure image is not artificially stretched because of screen's aspect ratio.
hold on;
plot(smbnd.X/ftr, smbnd.Y/ftr, 'r-', 'LineWidth', 2);
% grid on;
% title('Smoothed Boundary', 'FontSize', fontSize);
end
%==============================================================================================
% Function to return the specified number of largest or smallest blobs in a binary image.
% If numberToExtract > 0 it returns the numberToExtract largest blobs.
% If numberToExtract < 0 it returns the numberToExtract smallest blobs.
% Example: return a binary image with only the largest blob:
%   binaryImage = ExtractNLargestBlobs(binaryImage, 1);
% Example: return a binary image with the 3 smallest blobs:
%   binaryImage = ExtractNLargestBlobs(binaryImage, -3);
function binaryImage = ExtractNLargestBlobs(binaryImage, numberToExtract)
try
	% Get all the blob properties.  Can only pass in originalImage in version R2008a and later.
	[labeledImage, numberOfBlobs] = bwlabel(binaryImage);
	blobMeasurements = regionprops(labeledImage, 'area');
	% Get all the areas
	allAreas = [blobMeasurements.Area];
	if numberToExtract > length(allAreas);
		% Limit the number they can get to the number that are there/available.
		numberToExtract = length(allAreas);
	end
	if numberToExtract > 0
		% For positive numbers, sort in order of largest to smallest.
		% Sort them.
		[sortedAreas, sortIndexes] = sort(allAreas, 'descend');
	elseif numberToExtract < 0
		% For negative numbers, sort in order of smallest to largest.
		% Sort them.
		[sortedAreas, sortIndexes] = sort(allAreas, 'ascend');
		% Need to negate numberToExtract so we can use it in sortIndexes later.
		numberToExtract = -numberToExtract;
	else
		% numberToExtract = 0.  Shouldn't happen.  Return no blobs.
		binaryImage = false(size(binaryImage));
		return;
	end
	% Extract the "numberToExtract" largest blob(a)s using ismember().
	biggestBlob = ismember(labeledImage, sortIndexes(1:numberToExtract));
	% Convert from integer labeled image into binary (logical) image.
	binaryImage = biggestBlob > 0;
catch ME
	errorMessage = sprintf('Error in function ExtractNLargestBlobs().\n\nError Message:\n%s', ME.message);
	fprintf(1, '%s\n', errorMessage);
	uiwait(warndlg(errorMessage));
end
