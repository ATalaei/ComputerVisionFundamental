close all;clear;clc;

Images_Path = "E:\University\Computervission\Homework\CV_HW_5\Q3\DRIVE\Test\images\";
Mask_Path = "E:\University\Computervission\Homework\CV_HW_5\Q3\DRIVE\Test\mask\";
Manual_Path = "E:\University\Computervission\Homework\CV_HW_5\Q3\DRIVE\Test\1st_manual\";
Image_Dir = dir(Images_Path);
Mask_Dir = dir(Mask_Path);
Manual_Dir = dir(Manual_Path);
Sensitivity = 0;
Specificity = 0;
Accuracy = 0;
filename = 'Resulte.xlsx';
writematrix([], filename,WriteMode="overwrite");
Number_of_Input=20;


for k=1:numel(Image_Dir)
    if Image_Dir(k).isdir == 0

        I = im2double(imread(strcat(Images_Path, Image_Dir(k).name)));
        I_mask = im2double(imread(strcat(Mask_Path, Mask_Dir(k).name)));
        I_GT = logical(im2double(imread(strcat(Manual_Path ,Manual_Dir(k).name))));


%preproccess

I=I(:,:,2);
I=adapthisteq(I);
I_mask_1=adapthisteq(I_mask);

net = denoisingNetwork('DnCNN');

se4=strel('square',1);
I_op=imtophat(I,se4);
I_bot=imbothat(I,se4);
I=I+I_op-I_bot;
% I=imadjust(I);
I= denoiseImage(I,net);

I=medfilt2(I,[3 3]);
I_mask_2=medfilt2(I_mask_1);



I=I.*(I_mask);
% figure,imshow(I)


H=fspecial("average",[13 13]);
I_mean=imfilter(I,H);
I_mask_3=imfilter(I_mask_2,H);


Diff=I-I_mean;
mask_diff=I_mask_2-I_mask_3;


%main proccess

I_thresh=imbinarize(Diff,-0.045);
mask_teresh=imbinarize(mask_diff,-0.04);




SE_1=strel("square",7);
mask_ring=imerode(mask_teresh,SE_1);



I_comp=1-I_thresh;

I_final=I_comp.*mask_ring;


%post proccess

SE_2=strel("square",1);
I_final=imopen(I_final,SE_2);
% figure,imshow([I I_final]);

I_final = bwareaopen(I_final, 15);
I_final=imclose(I_final,SE_2);
SE_3=strel("square",1);
I_final=imdilate(I_final,SE_3);


figure,imshow([I I_final]);
        CM = segmentationConfusionMatrix(I_final,I_GT);
        Se=(CM(2,2) / (CM(2,1) + CM(2,2)));
        Sp=(CM(1,1) / (CM(1,1) + CM(1,2)));
        Ac=((CM(1,1) + CM(2,2)) / sum(CM(:)));

        disp(["Sensitivity" Se]);
        disp(["Specificity" Sp]);
        disp(["Accuracy" Ac]);
      

        
        
        writematrix([Se Sp Ac], filename,'WriteMode','append');
        Sensitivity = Sensitivity + Se;
        Specificity = Specificity + Sp;
        Accuracy = Accuracy + Ac;

    end
end
Se_F=Sensitivity/Number_of_Input;
Sp_F=Specificity/Number_of_Input;
Ac_F=Accuracy/Number_of_Input;


writematrix([Se_F Sp_F Ac_F], filename,'WriteMode','append');

disp(["Fianl Sensitivity:"  Sensitivity/Number_of_Input])
disp(["Fianl Specificity: " Specificity/Number_of_Input])
disp(["Fianl Accuracy: " Accuracy/Number_of_Input])
