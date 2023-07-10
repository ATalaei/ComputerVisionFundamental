 close all;clear; clc;
% I=(imread('im_50.png'));
% R=I(:,:,1);
% G=I(:,:,2);
% B=I(:,:,3);
% J=rgb2gray(I);
% J=medfilt2(J,[5 5]);
% u=imcrop(J);
% imshow(u)
% imwrite(u,'num_8_9.tif')
% 
% read images
directory_path = './Images';

files = dir(directory_path);

image_data = cell(length(files)-2,2); 
for i = 3:length(files) 
    if files(i).isdir == 0 

        file_path = fullfile(directory_path, files(i).name); 
        file_contents = imread(file_path); 
   
        image_data{i-2,1} = files(i).name; 
        image_data{i-2,2} = file_contents; 
    end
end


% read image labeles
directory_path = './Lables';

files = dir(directory_path);

label_data = cell(length(files)-2,2); 


for i = 3:length(files) 
    if files(i).isdir == 0 
       
        file_path = fullfile(directory_path, files(i).name); 
        file_contents = imread(file_path);
        
        
        label_data{i-2,1} = files(i).name; 
        label_data{i-2,2} = file_contents; 
    end
end




counter=zeros(size(image_data,1));
% 1:cor 2:x 3:y 4:label(0..9)
max_Corr_arr=zeros(size(image_data,1),10,4);

for i=1:size(image_data,1)
    J=rgb2gray(image_data{i,2});
    J=Denoiser(J);
    largerImage = J;
    for j=1:size(label_data,1)/9
        temp=zeros(9,4);
        for z=1:9

            smallerImage = label_data{j,2};

            corr = normxcorr2(smallerImage, largerImage);

            maxCorr = max(corr(:));
            temp(z,1)=maxCorr;

            max_Corr_arr(i,j)=maxCorr;
% 
%             threshold = .90; 
%             if maxCorr > threshold
%                 counter(i)=counter(i)+1;
%                 disp(label_data{j,1})
                [maxCorr, imax] = max(abs(corr(:)));
                [ypeak, xpeak] = ind2sub(size(corr),imax(1));

       
                yoffset = ypeak - size(smallerImage,1);
                xoffset = xpeak - size(smallerImage,2);
                temp(z,2)=xoffset+1+(size(smallerImage,2)/2);
                temp(z,3)=yoffset+1+(size(smallerImage,1)/2);
                temp(z,4)=j;
   


%                 %%%%%%%%%draw red regtangle outside detected
%                 numbers%%%%%%%%%%%%%%%%%
%                 figure, imshow(largerImage), hold on;
%                 rectangle('Position', [xoffset+1, yoffset+1, size(smallerImage,2), size(smallerImage,1)], 'EdgeColor', 'r', 'LineWidth', 2);

%                 disp('The smaller image exists within the larger image.');
    
%             end


        end    
        
        [max_val, max_idx] = max(temp(:,1)); 
        max_Corr_arr(i,j,1) = temp(max_idx,1); 
        max_Corr_arr(i,j,2) = temp(max_idx,3);
        max_Corr_arr(i,j,3) = temp(max_idx,2);
        max_Corr_arr(i,j,4) = temp(max_idx,4)-1;
        
    end    
end   

max_Corr_arr_sorted=zeros(size(image_data,1),10,4);
for i=1:100
    [~,sort_indices]=sort(max_Corr_arr(i,:,1),'descend');

    for z = 1:size(max_Corr_arr, 2)
              for t = 1:size(max_Corr_arr, 3)
                 max_Corr_arr_sorted(i, :, :) = max_Corr_arr(i, sort_indices, :);
              end
    end


end  



foldername = 'Coordinates';

filelist = dir(fullfile(foldername, '*.txt'));

data = cell(length(filelist), 1);


for i = 1:length(filelist)
   
    filename = fullfile(foldername, filelist(i).name);
    
   
    fileID = fopen(filename, 'r');
    
    
    j = 1;
    while ~feof(fileID) && j <= 10
        line = fgets(fileID);
        if ischar(line)
            data{i}(j,:) = sscanf(line, '%f,%f,%f');
        end
        j = j + 1;
    end
    
    % Close the file
    fclose(fileID);
end



counter=0;

for i=1:size(image_data,1)
    
    if(i<21)
        write_data=zeros(4,4);
        write_data=max_Corr_arr_sorted(i,:,1:4);
        [~,sort_indices]=sort(write_data(4),'ascend');

        write_data(:,:) = write_data(sort_indices,:);
             
       


        
        filename = sprintf('ans%d.txt', i-1);
      

        fileID = fopen(filename,'w');

for y=1:4
        xx=abs(write_data(1,y,2)-data{i}(y,1));
        yy=abs(write_data(1,y,3)-data{i}(y,2));
        if(xx^2+yy^2<=data{i}(y,3)^2)
            counter=counter+1;
        end    
        fprintf(fileID,'%.2f %.2f\n',write_data(1,y,2:3));
end    
        


fclose(fileID);


    elseif(i<41)
        write_data=zeros(6,4);
        write_data=max_Corr_arr_sorted(i,:,1:4);
        [~,sort_indices]=sort(write_data(6),'ascend');

        write_data(:,:) = write_data(sort_indices,:);
             
        filename = sprintf('ans%d.txt', i-1);
      

        fileID = fopen(filename,'w');

for y=1:6
          xx=abs(write_data(1,y,2)-data{i}(y,1));
        yy=abs(write_data(1,y,3)-data{i}(y,2));
        if(xx^2+yy^2<=data{i}(y,3)^2)
            counter=counter+1;
        end    
        fprintf(fileID,'%.2f %.2f\n',write_data(1,y,2:3));
end    
        


fclose(fileID);

    elseif(i<61)

        write_data=zeros(8,4);
        write_data=max_Corr_arr_sorted(i,:,1:4);
        [~,sort_indices]=sort(write_data(8),'ascend');

        write_data(:,:) = write_data(sort_indices,:);
             
        


        
        filename = sprintf('ans%d.txt', i-1);
      

        fileID = fopen(filename,'w');

for y=1:8
          xx=abs(write_data(1,y,2)-data{i}(y,1));
        yy=abs(write_data(1,y,3)-data{i}(y,2));
        if(xx^2+yy^2<=data{i}(y,3)^2)
            counter=counter+1;
        end    
        fprintf(fileID,'%.2f %.2f\n',write_data(1,y,2:3));
end    
        


fclose(fileID);


    else
        write_data=zeros(10,4);
        write_data=max_Corr_arr_sorted(i,:,1:4);
        [~,sort_indices]=sort(write_data(10),'ascend');

        write_data(:,:) = write_data(sort_indices,:);
             
   


        
        filename = sprintf('ans%d.txt', i-1);
      

        fileID = fopen(filename,'w');

for y=1:10
        xx=abs(write_data(1,y,2)-data{i}(y,1));
        yy=abs(write_data(1,y,3)-data{i}(y,2));
        if(xx^2+yy^2<=data{i}(y,3)^2)
            counter=counter+1;
        end    

        fprintf(fileID,'%.2f %.2f\n',write_data(1,y,2:3));
end    
        


fclose(fileID);

    end    
end     
disp(counter)
