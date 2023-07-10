function output_image = resize_nearest(input_image, scale_factor)



output_size = round(scale_factor * size(input_image));


output_image = zeros(output_size(1), output_size(2), size(input_image, 3), class(input_image));


[xx,yy] = meshgrid(1:output_size(2), 1:output_size(1));
x = round(xx/scale_factor);
y = round(yy/scale_factor);

x = min(max(x,1),size(input_image,2));
y = min(max(y,1),size(input_image,1));


for k = 1:size(input_image, 3)
    output_image(:,:,k) = input_image(sub2ind(size(input_image), y, x, ones(size(x))*k));
end


imshow(output_image);

end