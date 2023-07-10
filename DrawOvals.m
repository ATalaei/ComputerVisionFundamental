clc;clear;close all;

I=read_img("sample.ppm");
G=I;
im_center=[ceil(size(I,1)/2),ceil(size(I,2)/2)];
for i=1:size(I,1)
    for j=1:size(I,2)
        if((((i-im_center(1))^2)/((200)^2))+ ( ((j-im_center(2))^2)/((400)^2))<1  && ...
                (((i-im_center(1))^2)/((400)^2))+ ( ((j-im_center(2))^2)/((200)^2))<1)
           

                I(i,j,1)=uint8(255);
                I(i,j,2)=uint8(255);
                I(i,j,3)=uint8(255);

        
        elseif((((i-im_center(1))^2)/((200)^2))+ ( ((j-im_center(2))^2)/((400)^2))<1)

                I(i,j,1)=uint8(255-I(i,j,1));
                I(i,j,2)=uint8(255-I(i,j,2));
                I(i,j,3)=uint8(255-I(i,j,3));

        
        elseif((((i-im_center(1))^2)/((400)^2))+ ( ((j-im_center(2))^2)/((200)^2))<1)
                I(i,j,1)=I(i,j,1);
                I(i,j,2)=I(i,j,2);
                I(i,j,3)=I(i,j,3);

        else
                %a=0.2989*I(i,j,1)+0.5870*I(i,j,2)+0.1140*I(i,j,3);
                a=0.1*I(i,j,1)+0.5*I(i,j,2)+0.3*I(i,j,3);%use it for better contrast
                I(i,j,1)=a;
                I(i,j,2)=a;
                I(i,j,3)=a;
            
            
        end    
    end
end    

figure,imshow([I;G],[]);

write_img([I;G],"Q2_ANS.ppm");

read_img("Q2_ANS.ppm");









function return_val = read_img(path)
    F=fopen(path);
    file_content=fread(F,'uint8');
    fclose(F);
    if file_content (1)==80 && file_content(2)==53
        i= (1);
        while true
             if(file_content(i)==10)
                img_feature=file_content(1:i-1);
                break;   
              end 
        i=i+1;
        end
        img_content=file_content(i+1:end);
        w=convertCharsToStrings(char(img_feature));

        img_feature= str2double(split(w));

        I=zeros(img_feature(3),img_feature(2));
        k=1;
        for i=1:img_feature(3)
          for j=1:img_feature(2)
             I(i,j)=img_content(k);
             k=k+1;
          end
        end    
    figure,imshow(I,[])
    return_val=I;
    


    elseif file_content (1)==80 && file_content(2)==54
        i= (1);
        while true
             if(file_content(i)==10)
                img_feature=file_content(1:i-1);
                break;   
              end 
        i=i+1;
        end
        img_content=file_content(i+1:end);
        w=convertCharsToStrings(char(img_feature));

        img_feature= str2double(split(w));

        R=uint8(zeros(img_feature(3),img_feature(2)));
        G=uint8( zeros(img_feature(3),img_feature(2)));
        B=uint8(zeros(img_feature(3),img_feature(2)));
        k=1;
        for i=1:img_feature(3)
          for j=1:img_feature(2)
             R(i,j)=uint8(img_content(k));
             G(i,j)=uint8(img_content(k+1));
             B(i,j)=uint8(img_content(k+2));
             k=k+3;
          end
        end 
    im=cat(3,R,G,B); 
    
    figure, imshow(im,[]);
    return_val=im;
    end

    
end


function return_val = write_img(input_matrix,filename)
   
    if (ndims(input_matrix)==2 )
        F=fopen(filename,"w");

        fprintf(F,"P5 "+size(input_matrix,2)+" "+size(input_matrix,1)+" "+255+"\n");
        
        for i=1:size(input_matrix,1)
          for j=1:size(input_matrix,2)
             fwrite(F,input_matrix(i,j),'uint8');
             
          end
        end 

        fclose(F);
        
        return_val=filename;

    elseif (ndims(input_matrix)==3)
        F=fopen(filename,"w");

        fprintf(F,"P6 "+size(input_matrix,2)+" "+size(input_matrix,1)+" "+255+"\n");
        
        for i=1:size(input_matrix,1)
          for j=1:size(input_matrix,2)
              for z=1:3
                fwrite(F,input_matrix(i,j,z),'uint8');

              end
          end
        end 

        fclose(F);
        
        return_val=filename;

    end
end
