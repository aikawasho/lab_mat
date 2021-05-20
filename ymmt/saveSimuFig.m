function saveSimuFig(saveName,suffix, movefilename,P)
    %�t�H���_�ɉ摜��fig�t�@�C����ۑ�
    view(90,0)
    name =strcat('YZ_',saveName,suffix); 
    set(gcf, 'PaperPositionMode','auto');
    print(name,'-dpng','-r0'); %�S��
    movefile(strcat(name,'.png'), movefilename);
    
%     zlim([0 range])
%     print(strcat('kakuninup_z',num2str(nameIndex)),'-dpng','-r0'); %�㕔�̂�
%     movefile(strcat('kakuninup_z',num2str(nameIndex),'.png'), movefilename);
    
    name =strcat('Fig_',saveName,suffix,'.fig'); 
    saveas(gcf,name);
    movefile(name, movefilename);
    
    try
        name = strcat('P_',saveName,suffix,'.mat'); 
        save(name,'P');
        movefile(name, movefilename);
    catch
        warning('P���ۑ��ł��܂���ł����B')
    end
    close all;

end