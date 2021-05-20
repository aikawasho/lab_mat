%�V�~�����[�V������\������֐�

function dispXYZSimu(titleName,X,Y,Z,P,xslice,yslice,zslice)
     % simulation�̕\��
    figure('visible','off');
    x0=10;
    y0=10;
    width=850;
    height=500;
    set(gcf,'units','points','position',[x0,y0,width,height])
%     ax1 = axes('Position',[0 0 1 1],'Visible','off');
%     ax2 = axes('Position',[.2 .1 .7 .8]);
%     title(strcat(num2str(rad2deg(phase)),' degree'));
    title(titleName);
    hold on
    
    idx_max=P == max(max(max(P)));
    
    ax2 = gca;
    axes(ax2);
    xslice_plot = slice(X,Y,Z,P,xslice,yslice,zslice(1));
    volumeData = get(xslice_plot,'CData');
    minVolumeData = min(min(min(P)));
    maxVolumeData = max(max(max(P)));
%     pbaspect([1 1 1]) % graph�c����
    pbaspect([max(max(max(X)))-min(min(min(X))) max(max(max(Y)))-min(min(min(Y)))  max(max(max(Z)))-min(min(min(Z)))])
    set(ax2, 'FontSize', 22);
    set(xslice_plot,'LineStyle','none')  
    cbar = colorbar;
    %cbar.Label.String = 'sound pressure';
    %cbar.TicksMode = 'manual'; % �l��\�����Ȃ�
    %cbar.Limits = [0 maxVolumeData];
    set(ax2, 'CLim', [minVolumeData(1) maxVolumeData(1)]);
    
    %cbar.Position = [0.93 0.1000 0.0308 0.8000];
    ax = gca;
    ax.XLabel.String = 'x-axis [mm]';
    ax.YLabel.String = 'y-axis [mm]';
    ax.ZLabel.String = 'z-axis [mm]';
    set(ax,'FontSize', 22);

    
  


    % ���݂̈ʑ���\��
%     axes(ax1);
%     descr = {strcat('���g��',num2str(f),'Hz'), ...
%         strcat('�g��',num2str(ramda),'mm'), ...
%         strcat('Z-position: ',num2str(z_position)), ...
%         strcat('�ʑ�: ',num2str(phase/pi),'��','(',num2str(rad2deg(phase)),'deg',')') , ...
%         strcat('���˗�: ', num2str(reflectRate))
%         };
%     text(.025,0.6,descr,'FontSize',35)
%     set(ax1, 'FontSize', 35);

    fig = gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 30 15];
    
     axes(ax2)
%     view(3);
%     print(strcat('focusRowChangeView3_',num2str(Ph_num)),'-dpng','-r0');
%     
%     view(-90,0)
%     print(strcat('focusRowChangeYZ',num2str(Ph_num)),'-dpng','-r0');
%     
    j=1;
    %save(filename)
    

end