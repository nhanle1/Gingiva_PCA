temp=imread('ref.jpg');
outputfile='refEdge.jpg';
imwrite( edge(imgaussfilt(rgb2gray(temp),2),'Sobel'),outputfile);
clear outputfile temp