 close all;clc;clear;
   
puzzle_solver("E:\University\بینایی کامپیوتر\تکلیف\CV_HW_4\Q4\Puzzle_1_1200_1920\Unrotated_40\");

puzzle_solver("E:\University\بینایی کامپیوتر\تکلیف\CV_HW_4\Q4\Puzzle_1_1200_1920\Unrotated_160\");

puzzle_solver("E:\University\بینایی کامپیوتر\تکلیف\CV_HW_4\Q4\Puzzle_2_1200_1920\Unrotated_40\");

puzzle_solver("E:\University\بینایی کامپیوتر\تکلیف\CV_HW_4\Q4\Puzzle_2_1200_1920\Unrotated_160\");

puzzle_solver("E:\University\بینایی کامپیوتر\تکلیف\CV_HW_4\Q4\Puzzle_3_600_960\Unrotated_40\");

puzzle_solver("E:\University\بینایی کامپیوتر\تکلیف\CV_HW_4\Q4\Puzzle_3_600_960\Unrotated_160\");

puzzle_solver("E:\University\بینایی کامپیوتر\تکلیف\CV_HW_4\Q4\Puzzle_4_600_960\Unrotated_40\");

puzzle_solver("E:\University\بینایی کامپیوتر\تکلیف\CV_HW_4\Q4\Puzzle_4_600_960\Unrotated_160\");




function acc=accuracy(o_img,c_img)
counter=0;
    for i=1:size(o_img,1)
        for j=1:size(o_img,2)
           
            if (abs(o_img(i,j)-c_img(i,j))==[0,0,0])
                counter=counter+1;
            end

        end
    end
    acc=counter/(size(o_img,1)*size(o_img,2));
     disp("Accuracy:")
    disp(acc)

end





function puzzle_solver(image_path)
s1=dir(image_path);
s1=s1(3:end);

Output_img=0;
Original_img=0;
Shuffled_img=0;
Corner1_img=0;
Corner2_img=0;
Corner3_img=0;
Corner4_img=0;
Size_row_pixel=0;
Size_col_pixel=0;
Piece_Num_row=0;
Piece_Num_col=0;
index=1;

        for j=1:numel(s1)
            if(s1(j).isdir==0)
                  if (s1(j).name=="Original.tif")
                    Original_img=imread(strcat(image_path,s1(j).name));  
                    Size_row_pixel=size(Original_img,1);
                    Size_col_pixel=size(Original_img,2);
                 
                  elseif(s1(j).name=="Shuffled_Patches.tif")
                      Shuffled_img=imread(strcat(image_path,s1(j).name));

                  elseif (s1(j).name=="Output.tif")
                    Output_img=imread(strcat(image_path,s1(j).name));       
                    

                  elseif (s1(j).name(1)=="C")
                   

                        delimiter = '[._]';
                        temp = regexp(s1(j).name, delimiter, 'split');
                      if(temp(1,2)=="1")
                            if(temp(1,3)=="1")
                                Corner1_img=imread(strcat(image_path,s1(j).name));
                            else
                                Corner2_img=imread(strcat(image_path,s1(j).name));
                          
                            end
                      else
                          if(temp(1,3)=="1")
                              Corner3_img=imread(strcat(image_path,s1(j).name));

                          else
                              Corner4_img=imread(strcat(image_path,s1(j).name));
                              Piece_Num_row=str2num(cell2mat(temp(1,2)));
                              Piece_Num_col=str2num(cell2mat(temp(1,3)));
                          end
                      end
                  else 
                  all_img{index,1}=s1(j).name;
                  all_img{index,2}=imread(strcat(image_path,s1(j).name));
                  all_img{index,3}=extractLBPFeatures(rgb2gray( all_img{index,2}));
                  index=index+1;

                  end
                 
            end     
        end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
for i=1:Piece_Num_row-2
    
    if(i==1)
        I=double(Corner1_img(end:end,:,:));
        

    else
        I=double(temp11(end:end,:,:));
    end
    temp=zeros(1,Size_row_pixel/Piece_Num_row,3);
    for j=1:1
        temp(1,:,:)=temp(1,:,:)+I(j,:,:);

    end
    C=double(zeros(size(all_img,1),Size_row_pixel/Piece_Num_row,3));
    
    for j=1:size(all_img,1)

        J=double(all_img{j,2}(1:1,:,:));
        temp1=double(zeros(1,Size_row_pixel/Piece_Num_row,3));

        for r=1:1
        C(j,:,:)=double(C(j,:,:)+J(r,:,:));
        end
    end
    CC=double(zeros(size(all_img,1),1));
    for j=1:size(all_img,1)
        for t=1:Size_row_pixel/Piece_Num_row
            for p=1:3
            CC(j)= CC(j)+((C(j,t,p)-temp(1,t,p))^2);
            end
        end

    end
    [a,index]=min(CC);

    Output_img((Size_row_pixel/Piece_Num_row)*(i)+1:(Size_row_pixel/Piece_Num_row)*(i+1), ...
        1:(Size_col_pixel/Piece_Num_col),:)=all_img{index,2};
    temp11=all_img{index,2};
    figure(1),imshow(Output_img);
    all_img(index,:)=[];
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
for i=1:Piece_Num_row-2
    
    if(i==1)
        I=double(Corner2_img(end:end,:,:));
        

    else
        I=double(temp11(end:end,:,:));
    end
    temp=zeros(1,Size_row_pixel/Piece_Num_row,3);
    for j=1:1
        temp(1,:,:)=temp(1,:,:)+I(j,:,:);

    end
    C=double(zeros(size(all_img,1),Size_row_pixel/Piece_Num_row,3));
    
    for j=1:size(all_img,1)

        J=double(all_img{j,2}(1:1,:,:));
        temp1=double(zeros(1,Size_row_pixel/Piece_Num_row,3));

        for r=1:1
        C(j,:,:)=double(C(j,:,:)+J(r,:,:));
        end
    end
    CC=double(zeros(size(all_img,1),1));
    for j=1:size(all_img,1)
        for t=1:Size_row_pixel/Piece_Num_row
            for p=1:3
            CC(j)= CC(j)+((C(j,t,p)-temp(1,t,p))^2);
            end
        end

    end
    [a,index]=min(CC);

    Output_img((Size_row_pixel/Piece_Num_row)*(i)+1:(Size_row_pixel/Piece_Num_row)*(i+1), ...
        (Size_col_pixel/Piece_Num_col)*(Piece_Num_col-1)+1:(Size_col_pixel/Piece_Num_col)*Piece_Num_col,:)=all_img{index,2};
    temp11=all_img{index,2};
    figure(1),imshow(Output_img);
    all_img(index,:)=[];
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
for i=1:Piece_Num_col-2
    
    if(i==1)
        I=double(Corner3_img(:,end:end,:));
       
    else
        I=double(temp11(:,end:end,:));
    end
   

    % Transpose the matrix by swapping the first and second dimensions
    I = permute(I, [2 1 3]);

    temp=zeros(1,Size_row_pixel/Piece_Num_row,3);
    for j=1:1
        temp(1,:,:)=temp(1,:,:)+I(j,:,:);

    end
    C=double(zeros(size(all_img,1),Size_row_pixel/Piece_Num_row,3));
    
    for j=1:size(all_img,1)
        

        J=permute(all_img{j,2}, [2 1 3]);
        J=double(J(1:2,:,:));
        temp1=double(zeros(1,Size_row_pixel/Piece_Num_row,3));

        for r=1:1
        C(j,:,:)=double(C(j,:,:)+J(r,:,:));
        end
    end
    CC=double(zeros(size(all_img,1),1));
    for j=1:size(all_img,1)
        for t=1:Size_row_pixel/Piece_Num_row
            for p=1:3
            CC(j)= CC(j)+((C(j,t,p)-temp(1,t,p))^2);
            end
        end

    end
    [a,index]=min(CC);

    Output_img((Size_row_pixel/Piece_Num_row)*(Piece_Num_row-1)+1:(Size_row_pixel/Piece_Num_row)*(Piece_Num_row), ...
        (Size_col_pixel/Piece_Num_col)*(i)+1:(Size_col_pixel/Piece_Num_col)*(i+1),:)=all_img{index,2};
    temp11=all_img{index,2};
    figure(1),imshow(Output_img);
    all_img(index,:)=[];
end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
for m=1:Piece_Num_row-1
for i=1:Piece_Num_col-2
    
    if(i==1 && m==1)
        I=double(Corner1_img(:,end:end,:));
        

    elseif(i==1)
        I=double(Output_img((Size_row_pixel/Piece_Num_row)*(m-1)+1:(Size_row_pixel/Piece_Num_row)*(m), ...
        1:(Size_col_pixel/Piece_Num_col),:));
        I=double(I(:,end:end,:));
        kkk=Output_img((Size_row_pixel/Piece_Num_row)*(m-2)+1:(Size_row_pixel/Piece_Num_row)*(m-1), ...
        (Size_col_pixel/Piece_Num_col)*(i)+1:(Size_col_pixel/Piece_Num_col)*(i+1),:);
         
        II=double(kkk(end:end,:,:));

    else
        I=double(temp11(:,end:end,:));
        if(m~=1)
        kkk=Output_img((Size_row_pixel/Piece_Num_row)*(m-2)+1:(Size_row_pixel/Piece_Num_row)*(m-1), ...
        (Size_col_pixel/Piece_Num_col)*(i)+1:(Size_col_pixel/Piece_Num_col)*(i+1),:);
%         imshow(kkk)
        II=double(kkk(end:end,:,:));
        end
    end
   

    % Transpose the matrix by swapping the first and second dimensions
    I = permute(I, [2 1 3]);

    temp=zeros(1,Size_row_pixel/Piece_Num_row,3);
    for j=1:1
        temp(1,:,:)=temp(1,:,:)+I(j,:,:);

    end
    if(m~=1)
    tempp=zeros(1,Size_row_pixel/Piece_Num_row,3);
    for j=1:1
        tempp(1,:,:)=tempp(1,:,:)+II(j,:,:);

    end
    end

    C=double(zeros(size(all_img,1),Size_row_pixel/Piece_Num_row,3));
    if(m~=1)
    C1=double(zeros(size(all_img,1),Size_row_pixel/Piece_Num_row,3));
    end
    
    for j=1:size(all_img,1)
        

        J=permute(all_img{j,2}, [2 1 3]);
        if(m~=1)
        J1=all_img{j,2};
        J1=double(J1(1:1,:,:));
        tempp1=double(zeros(1,Size_row_pixel/Piece_Num_row,3));
        end
        J=double(J(1:1,:,:));
        
        temp1=double(zeros(1,Size_row_pixel/Piece_Num_row,3));
        

        for r=1:1
        C(j,:,:)=double(C(j,:,:)+J(r,:,:));
        if(m~=1)
        C1(j,:,:)=double(C(j,:,:)+J1(r,:,:));
        end
        end
    end

    CC=double(zeros(size(all_img,1),1));
    if(m~=1)
    CC1=double(zeros(size(all_img,1),1));
    end
    for j=1:size(all_img,1)
        for t=1:Size_row_pixel/Piece_Num_row
            for p=1:3
            CC(j)= CC(j)+((C(j,t,p)-temp(1,t,p))^2);
            if(m~=1)
            CC1(j)= CC1(j)+((C1(j,t,p)-tempp(1,t,p))^2);
            end
            end
        end

    end

    if(m~=1)
    [a,index]=min(CC1);
    else
    [a,index]=min(CC);
    end

    Output_img((Size_row_pixel/Piece_Num_row)*(m-1)+1:(Size_row_pixel/Piece_Num_row)*(m), ...
        (Size_col_pixel/Piece_Num_col)*(i)+1:(Size_col_pixel/Piece_Num_col)*(i+1),:)=all_img{index,2};
    temp11=all_img{index,2};
    figure(1),imshow(Output_img);
    all_img(index,:)=[];
end
end

accuracy(Original_img,Output_img);

end

% % % % % % % % % % % % % % % % % % % % 

