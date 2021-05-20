% 
% ������W�������g���u��halfhalf���[�h�ŏ㉺�Ō��������킹�A��ݔg���݂�
% ������悤�ɁAz����0-100�ɂ������̂��\�����A�ۑ��ł���悤�ɂ����B
% phase�̈�����������悤�ɂ���
% ���˗���������悤�ɂ���
% �t�@�C���̕ۑ�����w��ł���悤�ɂ���
% ���ۂ̑��c�����g�W�����u�Ɠ������̃X�s�[�J�̌��ɂ����B
% figure�̕\����degree�\�����o����悤�ɂ����B
% �����̑��u�͂Ȃ�
% �}���ȒP�Ɍ����邽�߁A�����̏ڍׂ͂Ȃ����A�^�C�g���Ɉʑ���\������悤�ɂ����B
% color bar ��sound pressure �ƕ\���������B���ƃ������͂���Ȃ��B
% colorbar ��\�����ꂽsurface�̃}�b�N�X�l�Ő�������
% P = zeros�̈ʒu��ύX
% �m�F�̂��߁A�����̖����\�����邱�Ƃɂ���
% halfhalf�̔��˂ł͂Ȃ��āA�����͂���ɋt�ɂ���Ƃǂ��Ȃ�̂�

function halfhalf_tractor_half(zp, range_N, phase, nameIndex,reflectRate, movefilename)

range = 60;
%range_N = 200;

xx = linspace(-range, range, range_N); 
yy = linspace(-range, range, range_N);
%zz = linspace(0, 90, range_N);
zz = linspace(-30, 90, range_N);

[X,Y,Z] = meshgrid(xx,yy,zz);

%�@�g�̃p�����[�^
f = 40000; %40kHz 
T = 1/f;
v = 340*1000; %340000 (mm/s)
ramda = v/f;
wave_number = 2*pi/ramda;

%�����̔��a 5cm(50mm)
hemis_r = 50; 
% �s�X�g���̊O�a
sp_l = 10;
sp_h = 7;

% �s�X�g���̔��a
a = 4.7; %���a4.7mm �̉~�`�s�X�g��

%% ��ڂ̏W�������g���u�i�����j

z_position = -zp;

%�œ_
f_x = 0;
f_y = 0;
f_z = 0+z_position;

%�ڂ����̓m�[�g�Q�� �X�s�[�J�̔z�u
theta1 = 2*asin(sp_l/2/hemis_r); % sp������肪��߂�p�x
l = hemis_r*cos(theta1/2);
l2 = l-sp_h;
hemis_r2 = sqrt(l2^2+(sp_l/2)^2);
theta2 = 2*acos(l2/hemis_r2);
a1 = hemis_r*theta1;
a2 = hemis_r*(theta2-theta1)/2;

A = a1+a2*2; % �X�s�[�J�P�����肪��߂钷��
theta3 = 2*pi*(A/(2*pi*hemis_r));
% �X�s�[�J�̍��W���X�g������
i = 1;
howmany_row = floor(2*pi*hemis_r/4/A);
row_number = 1;
for theta = linspace(pi,pi/2,howmany_row)
    rr = hemis_r*sin(theta); %theta�̂Ƃ��̒��S����~�܂ł̋���
    div4rr = 2*pi*rr/4; % �~����4�Ŋ�����
    howmany_div4rr = floor(div4rr/A);%�X�s�[�J�������邩
    if row_number == 4
        howmany_div4rr = 4; % 4��ڂ̓X�s�[�J�̕��ɗ]�T���������邽�߁A4�ɂ���.
    elseif row_number == 5
        howmany_div4rr = 5; % 5��ڂ̓X�s�[�J�̕��ɗ]�T���������邽�߁A5�ɂ���.
    end
    
    for j = 0:3
        for phai = linspace(j*2*pi/4+theta3,(j+1)*2*pi/4-theta3,howmany_div4rr)
          
          x = hemis_r*sin(theta)*cos(phai);
          y = hemis_r*sin(theta)*sin(phai);
          z = hemis_r*cos(theta)+z_position;
          sp_list(i) = UltrasonicSpeaker3D_3(x, y, z,f_x,f_y,f_z,f); 
          sp_list(i).row_number = row_number;
          
          if j == 0||j==1
             sp_list(i).qui_color = 'red'; 
          end
          i = i+1;
        end
    end
   
    row_number = row_number+1;
end

howmany_sp = length(sp_list);

bessel = zeros(range_N,range_N,range_N,howmany_sp);
for i = 1:howmany_sp
    sp_vector = [sp_list(i).v_x sp_list(i).v_y sp_list(i).v_z];
    vx = sp_list(i).v_x;
    vy = sp_list(i).v_y;
    vz = sp_list(i).v_z;
    phai_list = makePhaiList2(sp_list(i).x0, sp_list(i).y0, sp_list(i).z0, ...
        vx, vy, vz, X, Y, Z);
    bessel(:,:,:,i) = bessel_func(wave_number,a,phai_list);
end



% ���̌������X�g������
% ���ꂼ��̃X�s�[�J�p�̌������X�g
attenuation_list = zeros(range_N,range_N,range_N,howmany_sp);
[a_func, a_func_x] = make_attenuation_list3D_3_2();
for i = 1:howmany_sp   
%     attenuation_list(:,:,:,i) = make_attenuation_list3D_2(sp_list(i).x0, sp_list(i).y0, sp_list(i).z0, ...
%         X,Y,Z);
    
    %�������
    XYZ_D = sqrt( (X-sp_list(i).x0).^2 + (Y-sp_list(i).y0).^2 + (Z-sp_list(i).z0).^2 );
    a_func_result = a_func(a_func_x,XYZ_D);
    attenuation_list(:,:,:,i) = a_func_result.*bessel(:,:,:,i);
end

% �������팸�̂��ߕϐ����폜
clearvars bessel bessel_above


%% ��ڂ̏W�������g���u(�㑤�j

z_position = zp;

%�œ_
f_x = 0;
f_y = 0;
f_z = 0+z_position;

%�ڂ����̓m�[�g�Q�� �X�s�[�J�̔z�u
theta1 = 2*asin(sp_l/2/hemis_r); % sp������肪��߂�p�x
l = hemis_r*cos(theta1/2);
l2 = l-sp_h;
hemis_r2 = sqrt(l2^2+(sp_l/2)^2);
theta2 = 2*acos(l2/hemis_r2);
a1 = hemis_r*theta1;
a2 = hemis_r*(theta2-theta1)/2;

A = a1+a2*2; % �X�s�[�J�P�����肪��߂钷��
theta3 = 2*pi*(A/(2*pi*hemis_r));
% �X�s�[�J�̍��W���X�g������
i = 1;
howmany_row = floor(2*pi*hemis_r/4/A);
row_number = 1;
for theta = linspace(pi,pi/2,howmany_row)
    rr = hemis_r*sin(theta); %theta�̂Ƃ��̒��S����~�܂ł̋���
    div4rr = 2*pi*rr/4; % �~����4�Ŋ�����
    howmany_div4rr = floor(div4rr/A);%�X�s�[�J�������邩
    if row_number == 4
        howmany_div4rr = 4; % 4��ڂ̓X�s�[�J�̕��ɗ]�T���������邽�߁A4�ɂ���.
    elseif row_number == 5
        howmany_div4rr = 5; % 5��ڂ̓X�s�[�J�̕��ɗ]�T���������邽�߁A5�ɂ���.
    end
    
    
    for j = 0:3
        for phai = linspace(j*2*pi/4+theta3,(j+1)*2*pi/4-theta3,howmany_div4rr)
          
          x = hemis_r*sin(theta)*cos(phai);
          y = hemis_r*sin(theta)*sin(phai);
          %z = hemis_r*cos(theta)+z_position;
          z = -hemis_r*cos(theta)+z_position; %�@�㑤�Ȃ̂Ő����t�ɂ���
          sp_list2(i) = UltrasonicSpeaker3D_3(x, y, z,f_x,f_y,f_z,f); 
          sp_list2(i).row_number = row_number;
          if j == 0||j==1
             sp_list2(i).qui_color = 'black'; 
          else
              sp_list2(i).qui_color = 'red';
          end
          i = i+1;
        end
    end
   
    row_number = row_number+1;
end

howmany_sp = length(sp_list);

bessel = zeros(range_N,range_N,range_N,howmany_sp);
for i = 1:howmany_sp
    sp_vector = [sp_list2(i).v_x sp_list2(i).v_y sp_list2(i).v_z];
    vx = sp_list2(i).v_x;
    vy = sp_list2(i).v_y;
    vz = sp_list2(i).v_z;
    phai_list = makePhaiList2(sp_list2(i).x0, sp_list2(i).y0, sp_list2(i).z0, ...
        vx, vy, vz, X, Y, Z);
    bessel(:,:,:,i) = bessel_func(wave_number,a,phai_list);
end



% ���̌������X�g������
% ���ꂼ��̃X�s�[�J�p�̌������X�g
attenuation_list2 = zeros(range_N,range_N,range_N,howmany_sp);
[a_func, a_func_x] = make_attenuation_list3D_3_2();
for i = 1:howmany_sp   
%     attenuation_list2(:,:,:,i) = make_attenuation_list23D_2(sp_list2(i).x0, sp_list2(i).y0, sp_list2(i).z0, ...
%         X,Y,Z);
    
    %�������
    XYZ_D = sqrt( (X-sp_list2(i).x0).^2 + (Y-sp_list2(i).y0).^2 + (Z-sp_list2(i).z0).^2 );
    a_func_result = a_func(a_func_x,XYZ_D);
    attenuation_list2(:,:,:,i) = a_func_result.*bessel(:,:,:,i);
end


% �������팸�̂��ߕϐ����폜
clearvars bessel bessel_above

%%
% �V�~�����[�V�����J�n 
% ���ꂼ��̃X�s�[�J�̉����̘a���v�Z
% �G�l���M�[�ɕϊ��i2�悷��j
% ���ԕ��ςɂ���
j = 1;
time_div_N = 10;


ramda = v/f;
wave_number = 2*pi/ramda;
T = 1/f;
time_div_N = 10;

sum_absP = zeros(range_N,range_N,range_N);

tlist = 0:T/time_div_N:T;

%phase = pi;

clearvars a_func_result phai_list

    
    for t = tlist
        
        P_idx = 1;
        P= zeros(range_N,range_N,range_N);
%         %��ڂ̏W�������g���u�i�����j
        for i = 1:length(sp_list) % sp_list�̗�̐������ispeaker�̐��j�J��Ԃ�
            d = sqrt((X-sp_list(i).x0).^2 + (Y-sp_list(i).y0).^2 + (Z-sp_list(i).z0).^2); % d�͒��S����̋���
           
            if strcmp(sp_list(i).qui_color,'red') %��󂪐ԂȂ��
               if sp_list(i).row_number <= 4
                    P(:,:,:) = P(:,:,:) + reflectRate * attenuation_list(:,:,:,i).*sin(wave_number.*d - 2*pi*f*t - pi);
                else
                    P(:,:,:) = P(:,:,:) + reflectRate * attenuation_list(:,:,:,i).*sin(wave_number.*d - 2*pi*f*t - pi - phase);
                end
            else
                if sp_list(i).row_number <= 4
                    P(:,:,:) = P(:,:,:) + reflectRate * attenuation_list(:,:,:,i).*sin(wave_number.*d - 2*pi*f*t);
                else
                    P(:,:,:) = P(:,:,:) + reflectRate * attenuation_list(:,:,:,i).*sin(wave_number.*d - 2*pi*f*t - phase);
                end
            end
            P_idx=P_idx+1;
        end
        
        
        %��ڂ̏W�������g���u(�㑤)
        for i = 1:length(sp_list2) % sp_list�̗�̐������ispeaker�̐��j�J��Ԃ�
            d = sqrt((X-sp_list2(i).x0).^2 + (Y-sp_list2(i).y0).^2 + (Z-sp_list2(i).z0).^2); % d�͒��S����̋���

            if strcmp(sp_list2(i).qui_color,'red')
                if sp_list2(i).row_number <= 4
                    P(:,:,:) = P(:,:,:) + attenuation_list2(:,:,:,i).*sin(wave_number.*d - 2*pi*f*t - pi);
                else
                    P(:,:,:) = P(:,:,:) + attenuation_list2(:,:,:,i).*sin(wave_number.*d - 2*pi*f*t - pi - phase);
                end
            else
                if sp_list2(i).row_number <= 4
                    P(:,:,:) = P(:,:,:) + attenuation_list2(:,:,:,i).*sin(wave_number.*d - 2*pi*f*t);
                else
                    P(:,:,:) = P(:,:,:) + attenuation_list2(:,:,:,i).*sin(wave_number.*d - 2*pi*f*t - phase);
                end 
            end
            P_idx=P_idx+1;
        end
        

        abs_P = abs(P);
        sum_absP = sum_absP + abs_P; %abs_P���ǂ�ǂ񑫂��Ă���
        j = j+1;
    
    end
    
    avarage_P = sum_absP./time_div_N;

    % simulation�̕\��
    figure
    x0=10;
    y0=10;
    width=650;
    height=500;
    set(gcf,'units','points','position',[x0,y0,width,height])
%     ax1 = axes('Position',[0 0 1 1],'Visible','off');
%     ax2 = axes('Position',[.2 .1 .7 .8]);
    title(strcat(num2str(rad2deg(phase)),' degree'));

    hold on
    xslice = 0;
    %yslice = 0;
    %zslice = min(zz);
    ax2 = gca;
    axes(ax2);
    slice_plot = slice(X,Y,Z,avarage_P,xslice,[],[]);
    volumeData = get(slice_plot,'CData');
    minVolumeData = min(min(volumeData));
    maxVolumeData = max(max(volumeData));
    %pbaspect([1 1 1]) % graph�c����
    set(ax2, 'FontSize', 28);
    set(slice_plot,'LineStyle','none')  
    cbar = colorbar;
    cbar.Label.String = 'sound pressure';
    %cbar.TicksMode = 'manual'; % �l��\�����Ȃ�
    %cbar.Limits = [0 maxVolumeData];
    set(ax2, 'CLim', [minVolumeData maxVolumeData]);
    
    %cbar.Position = [0.93 0.1000 0.0308 0.8000];
    ax = gca;
    ax.XLabel.String = 'x-Axis (mm)';
    ax.YLabel.String = 'y-Axis (mm)';
    ax.ZLabel.String = 'z-Axis (mm)';
    set(ax,'FontSize', 35);

    %�X�s�[�J�̏ꏊ����\��
    for i = 1:length(sp_list)
       speeker_quiver3(sp_list(i).x0,sp_list(i).y0,sp_list(i).z0,sp_list(i).v_x,sp_list(i).v_y,sp_list(i).v_z,sp_list(i).qui_color,10)
    end
    for i = 1:length(sp_list2)
       speeker_quiver3(sp_list2(i).x0,sp_list2(i).y0,sp_list2(i).z0,sp_list2(i).v_x,sp_list2(i).v_y,sp_list2(i).v_z,sp_list2(i).qui_color,10)
    end
  


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
    
    view(-90,0)
    print(strcat('kakunin_z',num2str(nameIndex)),'-dpng','-r0'); %�S��
    movefile(strcat('kakunin_z',num2str(nameIndex),'.png'), movefilename);
    
    zlim([0 range])
    print(strcat('kakuninup_z',num2str(nameIndex)),'-dpng','-r0'); %�㕔�̂�
    movefile(strcat('kakuninup_z',num2str(nameIndex),'.png'), movefilename);
    
    %% ���̖��������Ă�����x�\��
        figure
    x0=10;
    y0=10;
    width=650;
    height=500;
    set(gcf,'units','points','position',[x0,y0,width,height])
%     ax1 = axes('Position',[0 0 1 1],'Visible','off');
%     ax2 = axes('Position',[.2 .1 .7 .8]);
    title(strcat(num2str(rad2deg(phase)),' degree'));

    hold on
    xslice = 0;
    %yslice = 0;
    %zslice = min(zz);
    ax2 = gca;
    axes(ax2);
    slice_plot = slice(X,Y,Z,avarage_P,xslice,[],[]);
    volumeData = get(slice_plot,'CData');
    minVolumeData = min(min(volumeData));
    maxVolumeData = max(max(volumeData));
    %pbaspect([1 1 1]) % graph�c����
    set(ax2, 'FontSize', 28);
    set(slice_plot,'LineStyle','none')  
    cbar = colorbar;
    cbar.Label.String = 'sound pressure';
    %cbar.TicksMode = 'manual'; % �l��\�����Ȃ�
    %cbar.Limits = [0 maxVolumeData];
    set(ax2, 'CLim', [minVolumeData maxVolumeData]);
    
    %cbar.Position = [0.93 0.1000 0.0308 0.8000];
    ax = gca;
    ax.XLabel.String = 'x-Axis (mm)';
    ax.YLabel.String = 'y-Axis (mm)';
    ax.ZLabel.String = 'z-Axis (mm)';
    set(ax,'FontSize', 35);

    %�X�s�[�J�̏ꏊ����\��

    for i = 1:length(sp_list2)
       speeker_quiver3(sp_list2(i).x0,sp_list2(i).y0,sp_list2(i).z0,sp_list2(i).v_x,sp_list2(i).v_y,sp_list2(i).v_z,sp_list2(i).qui_color,10)
    end
  


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
    
    view(-90,0)
    print(strcat('YZ_z',num2str(nameIndex)),'-dpng','-r0'); %�S��
    movefile(strcat('YZ_z',num2str(nameIndex),'.png'), movefilename);
    
    zlim([0 range])
    print(strcat('YZup_z',num2str(nameIndex)),'-dpng','-r0'); %�㕔�̂�
    movefile(strcat('YZup_z',num2str(nameIndex),'.png'), movefilename);
    
    saveas(gcf,strcat('YZup_z',num2str(nameIndex),'.fig'));
    movefile(strcat('YZup_z',num2str(nameIndex),'.fig'), movefilename);
    
    
    clear
end

