Cameraman = im2double(imread("E:\University\بینایی کامپیوتر\تکلیف\CV_HW_2\Q4\LR_Cameraman.tif"));
j=Mer(Cameraman);
i=im2double(imread("E:\University\بینایی کامپیوتر\تکلیف\CV_HW_2\Q4\Cameraman.tif"));
my_PSNR(j,i)
function Output_Image = Mer(Input_Image)
    i1 = size(Input_Image,1);
    i2 = size(Input_Image,2);
    i3 = size(Input_Image,3);
    o1 = 2 * i1 ;
    o2 = 2 * i2 ;
    o3 = i3 ;
    Output_Image = zeros(o1,o2,o3);
    for i=1:i1
        for j=1:i2
            Output_Image((i-1)*2+1,(j-1)*2+1,:) = Input_Image(i,j,:);
        end
    end
    for i=1:i1-1
        for j=1:i2-1
            Output_Image((i-1)*2+2,(j-1)*2+2,:) = (Output_Image((i-1)*2+1,(j-1)*2+1,:) + Output_Image((i-1)*2+1,(j-1)*2+3,:) + Output_Image((i-1)*2+3,(j-1)*2+1,:) + Output_Image((i-1)*2+3,(j-1)*2+3,:))/4;
        end
    end

    for i=1:i1-1
        for j=2:i2-1
            Output_Image((i-1)*2+2,(j-1)*2+1,:) = (Output_Image((i-1)*2+2,(j-1)*2+0,:) + Output_Image((i-1)*2+2,(j-1)*2+2,:) + Output_Image((i-1)*2+1,(j-1)*2+1,:) + Output_Image((i-1)*2+3,(j-1)*2+1,:))/4;
        end
    end
    for i=2:i1-1
        for j=1:i2-1
            Output_Image((i-1)*2+1,(j-1)*2+2,:) = (Output_Image((i-1)*2+0,(j-1)*2+2,:) + Output_Image((i-1)*2+2,(j-1)*2+2,:) + Output_Image((i-1)*2+1,(j-1)*2+1,:) + Output_Image((i-1)*2+1,(j-1)*2+3,:))/4;
        end
    end
    
    for i=1:i1-1
        Output_Image((i-1)*2+2,1,:) = (Output_Image((i-1)*2+1,1,:) + Output_Image((i-1)*2+3,1,:) + Output_Image((i-1)*2+2,2,:))/3;
    end
    for i=1:i1-1
        Output_Image((i-1)*2+2,o2-1,:) = (Output_Image((i-1)*2+1,o2-1,:) + Output_Image((i-1)*2+3,o2-1,:) + Output_Image((i-1)*2+2,o2-2,:))/3;
    end
    for j=1:i2-1
        Output_Image(1,(j-1)*2+2,:) = (Output_Image(1,(j-1)*2+1,:) + Output_Image(1,(j-1)*2+3,:) + Output_Image(2,(j-1)*2+2,:))/3;
    end
    for j=1:i2-1
        Output_Image(o1-1,(j-1)*2+2,:) = (Output_Image(o1-1,(j-1)*2+1,:) + Output_Image(o1-1,(j-1)*2+3,:) + Output_Image(o1-2,(j-1)*2+2,:))/3;
    end
    Output_Image(o1,1:o2-1,:) = Output_Image(o1-1,1:o2-1,:);
    Output_Image(1:o1-1,o2,:) = Output_Image(1:o1-1,o2-1,:);
    Output_Image(o1,o2,:) = Output_Image(o1-1,o2-1,:);
end