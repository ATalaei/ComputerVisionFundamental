







% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

function outputImage = BilinearResize(image, scaleFactor)


[height, width, ~] = size(image);

newHeight = round(height * scaleFactor);
newWidth = round(width * scaleFactor);

outputImage = zeros(newHeight, newWidth, size(image, 3), class(image));

for i = 1:newHeight
    for j = 1:newWidth
        
        
        x = (i-1)/scaleFactor + 1;
        y = (j-1)/scaleFactor + 1;
        
        x1 = floor(x);
        x2 = min(x1+1, height);
        y1 = floor(y);
        y2 = min(y1+1, width);
        
        wx2 = x - x1;
        wx1 = 1 - wx2;
        wy2 = y - y1;
        wy1 = 1 - wy2;
        
        outputImage(i,j,:) = wx1*wy1*image(x1,y1,:) + wx2*wy1*image(x2,y1,:) + wx1*wy2*image(x1,y2,:) + wx2*wy2*image(x2,y2,:);
        
    end
end

outputImage=cast(outputImage,class(image));

end

