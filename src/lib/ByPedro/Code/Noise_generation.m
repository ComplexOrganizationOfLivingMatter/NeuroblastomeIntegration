function Noise_generation(i,ratio,RS,N_images)


%% Generate image

    Img=imread(['..\initial_images_CVT\imagen_' num2str(i) '_Diagrama_01.png']);
    Img=logical(Img);
    imwrite(Img,['..\CVT-Noise\Image_' num2str(i) '_Voronoi_001_par_radio_noise_5_r1.png'])
    
    cent = regionprops(Img,'Centroid');
    cent_old = cat(1, cent.Centroid);
    cent_old=round(cent_old);
    cent_old=fliplr(cent_old); %[rows,columns]
    cent_old=[(1:size(cent_old,1))',cent_old];
     
       
    for loop=2:N_images
	
		
        %% Generate mask %%
        mask=zeros(RS,RS);
        
        % Adding seeds
        for x=1:size(cent_old,1)
            mask(cent_old(x,2),cent_old(x,3))=1;
        end
        
        % Labelling cells
        D = bwdist(mask); DL = watershed(D); bgm = DL == 0;
        Voronoi_Img=bgm;
        L_original=bwlabel(1-Voronoi_Img,8);
        
        %N_cells
        n_max_cell=max(max(L_original));
        
        %% update labels with old centers
        
        if loop ~=1
            aux=L_original;
            for x=1:n_max_cell
              aux(L_original==L_original(cent_old(x,2),cent_old(x,3)))=cent_old(x,1);
            end
            L_original=aux;
        end
        
        %% Get new centroids
        
        cent = regionprops(L_original,'Centroid');
        cent_news = cat(1, cent.Centroid);
        cent_news=round(cent_news);
        cent_news=fliplr(cent_news); %[rows,columns]
        cent_news=[(1:n_max_cell)',cent_news];
        
        
        %% Insert noise to centroid
        if mod(loop,2)==1 % If loop is pair
            aux=zeros(1,3);
            for index_cell=1:size(cent_news,1)

                %new seed for cell (index_cell)
                seeds=cent_news(index_cell,2:3);
                
                %noisy ratio with disk shape
                imagen_aux=zeros(RS);
                imagen_aux(seeds(1,1),seeds(1,2))=1;
                se1 = strel('disk',ratio);
                circle_noisy= imdilate(imagen_aux,se1);

                %get possible pixels to place the new seed
                PixelList = regionprops(circle_noisy, 'PixelList');
                list_possible_pix = cat(1, PixelList.PixelList);
                list_possible_pix=fliplr(list_possible_pix);
                imax=size(list_possible_pix,1);
                
                %chose seed randomly
                [m] = RandSimRepeticao(1,imax,1);

                % Check noisy seed is not overlapping or adjacent to other
                % seeds if the loop is closed to initials frames.
                if index_cell~=1
                    accepted=0;
                    match=0;
                    while accepted==0
                        sr=list_possible_pix(m,:);
                        for nsr=1:index_cell-1
                            for xxx=aux(nsr,2)-1:aux(nsr,2)+1
                                for yyy=aux(nsr,3)-1:aux(nsr,3)+1
                                    if(sr(1,1)==xxx) && (sr(1,2)==yyy)
                                        match=1;
                                    end
                                end
                            end
                        end
                        if match==1
                            [m] = RandSimRepeticao(1,imax,1);
                            match=0;
                        else
                            accepted=1;
                        end
                    end
                end
                aux(index_cell,1:3)=[index_cell, list_possible_pix(m,:)];
            end
            cent_news=aux;
        end
        
        Img=L_original;
        Img(L_original>0)=255;Img=logical(Img);

        
        %% Save image %%      
        
        imwrite(Img,['..\CVT-Noise\Image_' num2str(i) '_Voronoi_' num2str(loop,'%0.3d') '_par_radio_noise_5_r1.png'])
		
        %% Update centroids
        cent_old=cent_news;
        
    end
end