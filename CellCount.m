close all;clear;clc;

Image = im2double(imread("E:\University\Computervission\Homework\CV_HW_5\Q2\Cells.tif"));

% become image to black & white by multithresh outsu 
thresh=multithresh(Image,2);
binaryImage=Image>thresh(1,1);
figure,imshow(binaryImage,[])



% find best value foe errossion -> 5 is best

% for i=1:10
%     SE_1=strel("disk",i);
%     I=imerode(binaryImage,SE_1);
%     figure,imshow([I Image],[])
%     title(i);
%     pause(3);
% end



% for seperate cell with each other

SE_1=strel("disk",5);
I=imerode(binaryImage,SE_1);
figure,imshow([I Image],[])

% call function to count seperate component
binaryImage=I;
[L ,num]=count_components(binaryImage);

% call function to calculate area and avg_bright
[area,avg_bright]=Arae_Brightness(binaryImage,Image,'.','area_bright.xlsx');





function [area,avg_bright]=Arae_Brightness(binaryImage,Image,exel_add,exel_name)

writematrix([],strcat(exel_add,'\',exel_name),'WriteMode',"overwrite");
SE_1=strel("disk",5);
[L ,num]=count_components(binaryImage);


area=zeros(num,1);
avg_bright=zeros(num,1);


for k=1:num
    
     for i=1:size(L,1)
        for j=1:size(L,2)
            if(L(i,j)==k)
               I_per_compo(i,j)=1 ;

            else
               I_per_compo(i,j)=0 ;
            end
            
        end
     end

%     figure(1),imshow(I_per_compo,[]);

    I_per_compo =imdilate(I_per_compo,SE_1);
    L1=I_per_compo.*Image;
%     figure(2),imshow(I_per_compo,[]);


    for i=1:size(L,1)
        for j=1:size(L,2)
            if(I_per_compo(i,j)==1)
                area(k,1)=area(k,1)+1;
            end
            avg_bright(k)=avg_bright(k)+L1(i,j);
        end
    end
    avg_bright(k)=avg_bright(k)/area(k);

%     write to exel file

    writematrix([area(k),avg_bright(k)], strcat(exel_add,'\',exel_name),'WriteMode','append');
end

end




function [L, num] = count_components(BW)

[m, n] = size(BW);
L = zeros(m, n);
num = 0;


dx = [0, 1, 0, -1];
dy = [-1, 0, 1, 0];


    function dfs(x, y)
        
        L(x, y) = num;
        
      
        for k = 1:4
           
            nx = x + dx(k);
            ny = y + dy(k);
            
            
            if nx >= 1 && nx <= m && ny >= 1 && ny <= n && BW(nx, ny) == 1 && L(nx, ny) == 0
                
                dfs(nx, ny);
            end
        end
    end


for i = 1:m
    for j = 1:n
        
        if BW(i, j) == 1 && L(i, j) == 0
            
            num = num + 1;
            dfs(i, j);
        end
    end
end

end
