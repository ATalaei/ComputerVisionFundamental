
clc;clear;close all;
in_degree=input("please enter image rotation degree:");
I=im2double(imread("sample.ppm"));
J=my_imrotate(I,in_degree);
imwrite(J,"Rotated_img_30_deg.ppm");






function return_val=my_imrotate(I,degree)

    Rotation_M=[cosd(degree) sind(degree);-sind(degree) cosd(degree)];

    img_center_row= ceil(size(I,1)/2);
    img_center_col= ceil(size(I,2)/2);

    img_rot_rows=ceil(abs(size(I,1)*cosd(degree))+abs(size(I,2)*sind(degree)));%minimum size needed for rotated img Rows
    img_rot_cols=ceil(abs(size(I,2)*cosd(degree))+abs(size(I,1)*sind(degree)));%minimum size needed for rotated img Cols
    

    rot_img_center_row= ceil(img_rot_rows/2);
    rot_img_center_col= ceil(img_rot_cols/2);

    Rotated_img=zeros(img_rot_rows,img_rot_cols,3);

    for i=1:size(Rotated_img,1)
        for j=1:size(Rotated_img,2)
            temp= Rotation_M*[i-rot_img_center_row;j-rot_img_center_col];
            temp_i=round((temp(1,1)+img_center_row));
            temp_j=round((temp(2,1)+img_center_col));

            %check that pixel exist in initial image
            if(temp_i>= 1 && temp_i<=size(I,1) &&  temp_j>= 1 && temp_j<=size(I,2) )
                Rotated_img(i,j,:)=I(temp_i,temp_j,:);
            end    
        end    
    end
    
    return_val=Rotated_img;
    imshow(Rotated_img,[]);

end 




