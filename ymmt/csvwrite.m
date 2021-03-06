% csvの書き出し
function csvwrite(P ,range)
    
    csv_w = cell(numel(P)+1,4);
    csv_w(1,:) = {'data_x', 'data_y', 'data_z','data_p'};

    range_N = length(P);
    xx = linspace(-range, range, range_N); 
    yy = linspace(-range, range, range_N);
    zz = linspace(-range, range, range_N);

    csv_index = 2;
    for i = 1:length(P)
        for j = 1:length(P)
            for k = 1:length(P)
                csv_w(csv_index,:) = {xx(i) yy(j) zz(k) P(i,j,k)};
                %csv_w(csv_index,:) = {xx(i) yy(j) zz(k) avarage_E(j,i,k)}; % matlabでのxy軸がparaviewではyx軸となるのでi,jを入れ替えてある
                csv_index = csv_index + 1;
            end
        end
    end

    csv_w_dataset = cell2dataset(csv_w);
export(csv_w_dataset,'File',strcat('halfhalfBigSurface','.csv'),'Delimiter',',')
end

