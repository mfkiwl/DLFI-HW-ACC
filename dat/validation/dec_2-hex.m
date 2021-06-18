enc0_w = fopen('enc0_w.txt','r');
data = fscanf(enc0_w,'%8d');
b= string(dec2hex(data)) ;
c= fopen('enc0_w_h.txt','wt');
fprintf(c,"%s\n",b);


enc1_w = fopen('enc1_w.txt','r');
data = fscanf(enc1_w,'%8d');
b= string(dec2hex(data)) ;
c= fopen('enc1_w_h.txt','wt');
fprintf(c,"%s\n",b);

enc2_w = fopen('enc2_w.txt','r');
data = fscanf(enc2_w,'%8d');
b= string(dec2hex(data)) ;
c= fopen('enc2_w_h.txt','wt');
fprintf(c,"%s\n",b);

dec0_w = fopen('dec0_w.txt','r');
data = fscanf(dec0_w,'%8d');
b= string(dec2hex(data)) ;
c= fopen('dec0_w_h.txt','wt');
fprintf(c,"%s\n",b);

dec1_w = fopen('dec1_w.txt','r');
data = fscanf(dec1_w,'%8d');
b= string(dec2hex(data)) ;
c= fopen('dec1_w_h.txt','wt');
fprintf(c,"%s\n",b);

dec2_w = fopen('dec2_w.txt','r');
data = fscanf(dec2_w,'%8d');
b= string(dec2hex(data)) ;
c= fopen('dec2_w_h.txt','wt');
fprintf(c,"%s\n",b);

dasspp3_w = fopen('aspp3_w.txt','r');
data = fscanf(dasspp3_w,'%8d');
b= string(dec2hex(data)) ;
c= fopen('aspp3_w_h.txt','wt');
fprintf(c,"%s\n",b);

dasspp6_w = fopen('aspp6_w.txt','r');
data = fscanf(dasspp6_w,'%8d');
b= string(dec2hex(data)) ;
c= fopen('aspp6_w_h.txt','wt');
fprintf(c,"%s\n",b);

dasspp12_w = fopen('aspp12_w.txt','r');
data = fscanf(dasspp12_w,'%8d');
b= string(dec2hex(data)) ;
c= fopen('aspp12_w_h.txt','wt');
fprintf(c,"%s\n",b);

dasspp18_w = fopen('aspp18_w.txt','r');
data = fscanf(dasspp18_w,'%8d');
b= string(dec2hex(data)) ;
c= fopen('aspp18_w_h.txt','wt');
fprintf(c,"%s\n",b);

out_w = fopen('out_w.txt','r');
data = fscanf(out_w,'%8d');
b= string(dec2hex(data)) ;
c= fopen('out_w_h.txt','wt');
fprintf(c,"%s\n",b);

out_w = fopen('aspp_input.txt','r');
data = fscanf(out_w,'%8d');
b= string(dec2hex(data)) ;
c= fopen('aspp_input_h.txt','wt');
fprintf(c,"%s\n",b);

out_w = fopen('aspp_A.txt','r');
data = fscanf(out_w,'%8d');
b= string(dec2hex(data)) ;
c= fopen('aspp_A_h.txt','wt');
fprintf(c,"%s\n",b);
%%


%%img = imread('0001.png')
%%img = imresize(img, [31,31]);
img1 = fopen('frame_1.txt' ,'r');
img1 = fscanf(img1 , '%d');
img_b1= string(dec2hex(img1)) ;
c= fopen('frame_1_h.txt','wt');
fprintf(c,"%s\n",img_b1);

img2 = fopen('frame_2.txt' ,'r');
img2 = fscanf(img2 , '%d');
img_b2= string(dec2hex(img2)) ;
c= fopen('frame_2_h.txt','wt');
fprintf(c,"%s\n",img_b2);

fclose all
