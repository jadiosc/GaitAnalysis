%% Seleccionar el video
[filename,path]=uigetfile('*.avi','Selecciona un archivo de video');
archivo=strcat(path,filename);   

pelicula = mmreader(archivo);
numFrames = pelicula.NumberOfFrames;
arcos=zeros(1,numFrames);

%% Procesa un cuadro a la vez
for k = 1 : numFrames
    imagenOriginal = read(pelicula, k);
    imagenbyn = im2bw(imagenOriginal, 0.5);
    se = strel('disk',10);
    imagen = imdilate(imagenbyn,se);
    s = regionprops(imagen, 'centroid');
    centroids = cat(1, s.Centroid);
    %% Ordena los centroides de acuerdo a su valor en el eje y
    [centroides, pos]=sort(centroids,'ascend');
    %% Con pos, obtienes el orden correcto y los acomodamos en un nuevo vector
    centros=[centroids(pos(1,2),:,1); centroids(pos(2,2),:,1); centroids(pos(3,2),:,1)];
    vector1=[centros(2,1)-centros(1,1) centros(2,2)-centros(1,2)];
    vector2=[centros(3,1)-centros(2,1) centros(3,2)-centros(2,2)];
    theta = acos(dot(vector1,vector2)/(norm(vector1)*norm(vector2)));
    arcos(1,k)=rad2deg(theta); 
    subplot(2,1,1);
    imshow(imagenOriginal);
    hold on;
    plot(centroids(:,1), centroids(:,2), 'b*');
    line(centros(1:2,1,1),centros(1:2,2,1));
    line(centros(2:3,1,1),centros(2:3,2,1));
    hold off;
    title('video')
    subplot(2,1,2); plot(arcos)
    title('angulo')
end 