ُclc ;clear;close all;



matrix_of_img_pgm=read_img("sample.pgm");
matrix_of_img_ppm=read_img("sample.ppm");

name_of_created_file_pgm=write_img(matrix_of_img_pgm);
name_of_created_file_ppm=write_img(matrix_of_img_ppm);

x=read_img(name_of_created_file_pgm);
m=read_img(name_of_created_file_ppm);








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


function return_val = write_img(input_matrix)
   
    if (ndims(input_matrix)==2 )
        F=fopen("sample1.pgm","w");

        fprintf(F,"P5 "+size(input_matrix,2)+" "+size(input_matrix,1)+" "+255+"\n");
        
        for i=1:size(input_matrix,1)
          for j=1:size(input_matrix,2)
            fwrite(F,input_matrix(i,j),'uint8');
             
             
         end
        end 

        fclose(F);
        
        return_val="sample1.pgm";

    elseif (ndims(input_matrix)==3)
        F=fopen("sample1.ppm","w");

        fprintf(F,"P6 "+size(input_matrix,2)+" "+size(input_matrix,1)+" "+255+"\n");
        
        for i=1:size(input_matrix,1)
          for j=1:size(input_matrix,2)
              for z=1:3
                fwrite(F,input_matrix(i,j,z),'uint8');

              end
          end
        end 

        fclose(F);
        
        return_val="sample1.ppm";

    end
end







