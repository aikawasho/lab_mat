% figure����f�[�^�𓾂�

h = gcf;
axesObjs = get(h,'Children');
dataObjs = get(axesObjs, 'Children');


% a = gca; % ���݂̍��W���܂��̓`���[�g
% get(a,'CLim'); % colorbar
% axesObjs2 = get(a,'Children');

% axesObj2����Surface�I�u�W�F�N�g�����o��
% surfaceData = axesObjs2(81); %����81�Ԗڂ�SurfaceObject���������ꍇ
% cValue = get(surfaceData, 'CData'); %surfaceData����J���[�v���b�g�p�̃f�[�^�����o���B
% cValueMax = max(max(cValue));
% cValueMin = min(min(cValue));

% �ۑ����Ă���figure���J���āAcLim��ύX���A�ۑ�
figList = dir('*.fig');
for i = 1:length(figList)
    open(figList(i).name);
    
   
    ax = gca; % ���݂̍��W���܂��̓`���[�g
    set(ax, 'FontSize', 60);
    x0=10;
    y0=10;
    width=650;
    height=640;
    set(gcf,'units','points','position',[x0,y0,width,height])
    
    get(ax,'CLim'); % colorbar
    axesObjs2 = get(ax,'Children');
    surfaceData = axesObjs2(end); %����81�Ԗڂ�SurfaceObject���������ꍇ
    cValue = get(surfaceData, 'CData'); %surfaceData����J���[�v���b�g�p�̃f�[�^�����o���B
    cValueMax = max(max(cValue));
    cValueMin = min(min(cValue));
    cbar = colorbar;
    cbar.Label.String = 'sound pressure';
    cbar.TicksMode = 'manual'; % �l��\�����Ȃ�
    cbar.Limits = [0 maxVolumeData];
    set(ax, 'CLim', [cValueMin cValueMax]);
    saveas(gcf,strcat(figList(i).name(1:end-4),'.png'));
    nameIndex = nameIndex+1;
    
    close all;
end

