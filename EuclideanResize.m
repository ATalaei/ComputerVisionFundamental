function output_image = euclidean_resize(input_image, scale_factor)


[height, width, num_channels] = size(input_image);


new_height = round(height * scale_factor);
new_width = round(width * scale_factor);


[x_new, y_new] = meshgrid(1:new_width, 1:new_height);


x = (x_new-0.5) ./ scale_factor + 0.5;
y = (y_new-0.5) ./ scale_factor + 0.5;

dx = abs(x - round(x));
dy = abs(y - round(y));
dist = sqrt(dx.^2 + dy.^2);


output_image = zeros(new_height, new_width, num_channels);
for k = 1:num_channels
    channel = input_image(:,:,k);
    output_image(:,:,k) = interp2(channel, x, y, 'linear') .* (1 - dist) ...
        + interp2(channel, x+1, y, 'linear') .* dist;
end

output_image = cast(output_image, class(input_image));

end