  clc;clear;close all;
Key=rng;
Sectret_img=uint8(imread("Image_1.tif"));
Cover_img=uint8(imread("Image_2.tif"));

Num_row=size(Sectret_img,1);
Num_col=size(Sectret_img,2);

Num_row_b=transpose (int2bit(Num_row,16));
Num_col_b=transpose(int2bit(Num_col,16));


Cover_img(1,1)=bit2int(transpose(Num_row_b(1:8)),8)  ;
Cover_img(1,2)=bit2int(transpose(Num_row_b(9:16)),8)  ;

Cover_img(1,3)=bit2int(transpose(Num_col_b(1:8)),8)  ;
Cover_img(1,4)=bit2int(transpose(Num_col_b(9:16)),8)  ;




t=1;
s=5;



for i=1:size(Sectret_img,1)
    for j=1:size(Sectret_img,2)
        pixel_bit=transpose (int2bit(Sectret_img(i,j,1),8));
        for k=1:8

           z=transpose(int2bit(Cover_img(t,s),8));
           z(8)=pixel_bit(k);
           z=bit2int(transpose(z),8);
           Cover_img(t,s)=z;
           if (s+1>size(Cover_img,2))
                t=t+1;
                s=1;
           else
                s=s+1;
           
           end     

        end    



        pixel_bit=transpose (int2bit(Sectret_img(i,j,2),8));
        for k=1:8

           z=transpose(int2bit(Cover_img(t,s),8));
           z(8)=pixel_bit(k);
           z=bit2int(transpose(z),8);
           Cover_img(t,s)=z;
           if (s+1>size(Cover_img,2))
                t=t+1;
                s=1;
           else
                s=s+1;
           
           end     

        end    



        pixel_bit=transpose (int2bit(Sectret_img(i,j,3),8));
        for k=1:8

           z=transpose(int2bit(Cover_img(t,s),8));
           z(8)=pixel_bit(k);
           z=bit2int(transpose(z),8);
           Cover_img(t,s)=z;
           if (s+1>size(Cover_img,2))
                t=t+1;
                s=1;
           else
                s=s+1;
           
           end     

        end    
        
        
    end

end   

imshow(Cover_img,[])
imwrite(Cover_img,".\sendImage.tif")

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
Cover_img=uint8(imread("sendImage.tif"));


img_row=double( double( Cover_img(1,1)*256)+double( Cover_img(1,2)))+1;
img_col=double( double(Cover_img(1,3)*256)+double( Cover_img(1,4)))+1;


R=uint8(zeros(img_row,img_col));

G=uint8(zeros(img_row,img_col));

B=uint8(zeros(img_row,img_col));



t=1;
s=5;

pixel_bit=(zeros(1,8));

for i=1:img_row
    for j=1:img_col
        

        for k=1:8

          z=transpose(int2bit( Cover_img(t,s),8));
           pixel_bit(k)=z(8);
          if (s+1>size(Cover_img,2))
                t=t+1;
                s=1;
          else
                s=s+1;
           
          end     
          
           
        end 
        powery=1;
        temp=0;
        for r=1:8
            temp=temp+(pixel_bit(9-r)*powery);
            powery=powery*2;
        end    
        R(i,j)=temp;

    



        for k=1:8

          z=transpose(int2bit( Cover_img(t,s),8));
           pixel_bit(k)=z(8);
          if (s+1>size(Cover_img,2))
                t=t+1;
                s=1;
          else
                s=s+1;
           
          end     
          
           
        end 
        powery=1;
        temp=0;
        for r=1:8
            temp=temp+(pixel_bit(9-r)*powery);
            powery=powery*2;
        end    
        G(i,j)=temp;


        for k=1:8

          z=transpose(int2bit( Cover_img(t,s),8));
           pixel_bit(k)=z(8);
          if (s+1>size(Cover_img,2))
                t=t+1;
                s=1;
          else
                s=s+1;
           
          end     
          
           
        end 
        powery=1;
        temp=0;
        for r=1:8
            temp=temp+(pixel_bit(9-r)*powery);
            powery=powery*2;
        end    
        B(i,j)=temp;
        
    end

end   

imshow(cat(3,R,G,B),[])

