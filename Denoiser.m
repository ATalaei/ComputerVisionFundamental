function denoise_img= my_denoiser(I)
J = zeros(size(I,1),size(I,2));
I = padarray(I, [5, 5]);

I_mirror=zeros(size(I,1),size(I,2));
I_mirror(I==0)=1;
I_mirror(I==255)=1;
I(I==0)=0;
I(I==255)=0;


for i=6:size(I_mirror,1)-5
    for j=6:size(I_mirror,2)-5

        if(I_mirror(i,j)==0)

            J(i-5,j-5)=I(i,j);
        
        end

        if(I_mirror(i,j)==1)
            if(sum(sum(I_mirror(i-1:i+1,j-1:j+1)))<8)
                % Extract the 3x3 neighborhood around the pixel of interest
                neighborhood = I(i-1:i+1, j-1:j+1);
                bw = zeros(3,3);
                bw(2,2)=1;
                % Compute the Euclidean distance transform of the neighborhood
                dist_transform = bwdist(bw);

                % Calculate the weights for each pixel based on their distance from the center pixel
                weights = 1 ./ (0.01+dist_transform);
                sum(sum(weights .* double(neighborhood)));
                net_weight=0;
                
                for u=1:3
                    for t=1:3
                        if(neighborhood(u,t)~=0)
                            net_weight=net_weight+weights(u,t);
                            
                        end    
                        
                    end    
                end   
                % Calculate the weighted average of the neighborhood
                weighted_avg = sum(sum(weights .* double(neighborhood))) / net_weight;
                J(i-5, j-5) = round(weighted_avg);
                

                
                 
            elseif(sum(sum(I_mirror(i-2:i+2,j-2:j+2)))<23)
                % Extract the 3x3 neighborhood around the pixel of interest
                neighborhood = I(i-2:i+2, j-2:j+2);
                bw = zeros(5,5);
                bw(3,3)=1;
                % Compute the Euclidean distance transform of the neighborhood
                dist_transform = bwdist(bw);

                % Calculate the weights for each pixel based on their distance from the center pixel
                weights = 1 ./ (0.01+dist_transform);
                sum(sum(weights .* double(neighborhood)));
                net_weight=0;
                for u=1:5
                    for t=1:5
                        if(neighborhood(u,t)~=0)
                            net_weight=net_weight+weights(u,t);
                        end    
                        
                    end    
                end   
                % Calculate the weighted average of the neighborhood
                weighted_avg = sum(sum(weights .* double(neighborhood))) / net_weight;
                J(i-5, j-5) = round(weighted_avg);
%                 J(i-5, j-5) = median(median(neighborhood));


                elseif(sum(sum(I_mirror(i-3:i+3,j-3:j+3)))<46)
                % Extract the 3x3 neighborhood around the pixel of interest
                neighborhood = I(i-3:i+3, j-3:j+3);
                bw = zeros(7,7);
                bw(4,4)=1;
                % Compute the Euclidean distance transform of the neighborhood
                dist_transform = bwdist(bw);

                % Calculate the weights for each pixel based on their distance from the center pixel
                weights = 1 ./ (0.01+dist_transform);
                sum(sum(weights .* double(neighborhood)));
                net_weight=0;
                for u=1:7
                    for t=1:7
                        if(neighborhood(u,t)~=0)
                            net_weight=net_weight+weights(u,t);
                        end    
                        
                    end    
                end   
                % Calculate the weighted average of the neighborhood
                weighted_avg = sum(sum(weights .* double(neighborhood))) / net_weight;
                J(i-5, j-5) = round(weighted_avg);


%                 % Calculate the weighted average of the neighborhood
%                 weighted_avg = sum(sum(weights .* double(neighborhood))) / net_weight;
%                 J(i-2, j-2) = round(weighted_avg);


                elseif(sum(sum(I_mirror(i-4:i+4,j-4:j+4)))<77)
                % Extract the 3x3 neighborhood around the pixel of interest
                neighborhood = I(i-4:i+4, j-4:j+4);
                bw = zeros(9,9);
                bw(5,5)=1;
                % Compute the Euclidean distance transform of the neighborhood
                dist_transform = bwdist(bw);

                % Calculate the weights for each pixel based on their distance from the center pixel
                weights = 1 ./ (0.01+dist_transform);
                sum(sum(weights .* double(neighborhood)));
                net_weight=0;
                for u=1:9
                    for t=1:9
                        if(neighborhood(u,t)~=0)
                            net_weight=net_weight+weights(u,t);
                        end    
                        
                    end    
                end   
                % Calculate the weighted average of the neighborhood
                weighted_avg = sum(sum(weights .* double(neighborhood))) / net_weight;
                J(i-5, j-5) = round(weighted_avg);
                
           
                
            elseif(sum(sum(I_mirror(i-5:i+5,j-5:j+5)))<122)
                % Extract the 3x3 neighborhood around the pixel of interest
                neighborhood = I(i-5:i+5, j-5:j+5);
                bw = zeros(11,11);
                bw(6,6)=1;
                % Compute the Euclidean distance transform of the neighborhood
                dist_transform = bwdist(bw);

                % Calculate the weights for each pixel based on their distance from the center pixel
                weights = 1 ./ (0.01+dist_transform);
                sum(sum(weights .* double(neighborhood)));
                net_weight=0;
                for u=1:11
                    for t=1:11
                        if(neighborhood(u,t)~=0)
                            net_weight=net_weight+weights(u,t);
                        end    
                        
                    end    
                end   
                % Calculate the weighted average of the neighborhood
                weighted_avg = sum(sum(weights .* double(neighborhood))) / net_weight;
                J(i-5, j-5) = round(weighted_avg);
                
            end    
            
        end    

    end    

end 
J=uint8(J);
J=im2double(J);

denoise_img=J;

end



function max_psnr=best_medfil(noisy_img,base_img)

% base_img=im2double(base_img);
% noisy_img=im2double(noisy_img);
I_med_3=( medfilt2(noisy_img,[3,3]));
I_med_5=( medfilt2(noisy_img,[5,5]));
I_med_7=( medfilt2(noisy_img,[7,7]));
I_med_9=( medfilt2(noisy_img,[9,9]));
I_med_11=( medfilt2(noisy_img,[11,11]));

psnr_3=psnr(I_med_3,base_img);
psnr_5=psnr(I_med_5,base_img);
psnr_7=psnr(I_med_7,base_img);
psnr_9=psnr(I_med_9,base_img);
psnr_11=psnr(I_med_11,base_img);

max_psnr=max([psnr_3 psnr_5 psnr_7 psnr_9 psnr_11]);
end