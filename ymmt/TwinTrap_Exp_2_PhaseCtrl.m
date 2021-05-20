% 
% ������W�������g���u��halfhalf���[�h�ŏ㉺�Ō��������킹�A��ݔg���݂�
% ������悤�ɁAz����0-100�ɂ������̂��\�����A�ۑ��ł���悤�ɂ����B
% phase�̈�����������悤�ɂ���
% �t�@�C���̕ۑ�����w��ł���悤�ɂ���
% ���ۂ̑��c�����g�W�����u�Ɠ������̃X�s�[�J�̌��ɂ����B
% figure�̕\����degree�\�����o����悤�ɂ����B
% �����̑��u�͂Ȃ�
% �}���ȒP�Ɍ����邽�߁A�����̏ڍׂ͂Ȃ����A�^�C�g���Ɉʑ���\������悤�ɂ����B
% color bar ��sound pressure �ƕ\���������B���ƃ������͂���Ȃ��B
% colorbar ��\�����ꂽsurface�̃}�b�N�X�l�Ő�������
% P = zeros�̈ʒu��ύX
% ��̑g�ݍ��킹��ς�����悤�ɂ����B(RowsCombNum�Ŏw�肷��(�z���)�B�i���o�[�̎w���1����U�i�����琔���āj)
% avarage_P��save����悤�ɂ���
% range�������ɒǉ�
% ���ԕ��ς���̂���߂��B(���Ԗ��ɕ\���ɂ���)
% ���̐F��4��ނɂ���
% ������������

function TwinTrap_Exp_2_PhaseCtrl(zp, range, range_N, hemis_r, xslice, yslice, zslice, sp_number, saveName, movefilename, titleName, phase)
  %% bottle trap�p�̒����g�U���q�z�u���s��
%     sp_number = 100;
%     hemis_r = 50;
    rangez_up = 4*8.5; rangez_bottom = -4*8.5;
    rangez_N = (rangez_up-rangez_bottom)/(8.5/20);
%     range = 30; 
%     range_N = 100;
    redColorPhase = phase;
    blueColorPhase = mod(phase + pi, 2*pi);
    magentaColorPhase = 0;
    cyanColorPhase = pi;
    zp = 0;
%     RowsCombNum = [1 2 3 4];
    delta_x = 2*range/range_N;
    delta_y = 2*range/range_N;
    delta_z = (rangez_up-rangez_bottom)/range_N;
%     
    xx = linspace(-range, range, range_N); 
    yy = linspace(-range, range, range_N);
    %zz = linspace(0, 90, range_N);
    zz = linspace(rangez_bottom, rangez_up, range_N);
    

    [X,Y,Z] = meshgrid(xx,yy,zz);

    %�@�g�̃p�����[�^
    f = 40000; %40kHz 
    T = 1/f;
    v = 340*1000; %340000 (mm/s)
    ramda = v/f;
    wave_number = 2*pi/ramda;

 
    %hemis_r = 40; 
    % �s�X�g���̊O�a
    sp_l = 10.5;
    sp_h = 7;

    % �s�X�g���̔��a
    a = 4.7; %���a4.7mm �̉~�`�s�X�g��

  

    %z_position = -zp;
    z_position = zp;
    
    %�œ_
    f_x = 0;
    f_y = 0;
    f_z = 0+z_position;

    if rem(sp_number,2) == 1
        warning('sp_number�������ł͂���܂���I')
        pause
    end
       
    %�ڂ����̓m�[�g�Q�� �X�s�[�J�̔z�u
    theta1 = 2*asin(sp_l/2/hemis_r); % sp������肪��߂�p�x
    l = hemis_r*cos(theta1/2);
    l2 = l-sp_h;
    hemis_r2 = sqrt(l2^2+(sp_l/2)^2);
    theta2 = 2*acos(l2/hemis_r2);
    div_theta = pi/180; % first_theta�����߂�Ƃ�1�x�����ނ��Ƃɂ���
    a1 = hemis_r*theta1;
    a2 = hemis_r*(theta2-theta1)/2;

    A = a1+a2*2; % �X�s�[�J�P�����肪��߂钷��
    theta3 = 2*pi*(A/(2*pi*hemis_r));
    % �X�s�[�J�̍��W���X�g������
    i = 1;
    howmany_row = floor(2*pi*hemis_r/2/A);
    row_number = 1;
    
    
    iszero = 0; 
    for first_theta = pi:-div_theta:pi/2
        rr = hemis_r*sin(first_theta); %theta�̂Ƃ��̒��S����~�܂ł̋���
%         div4rr = 2*pi*rr/4; % �~����4�Ŋ�����
        div2rr = 2*pi*rr/2; %�~�����Q�Ŋ�����
%         howmany_div4rr = floor(div4rr/A);%�X�s�[�J�������邩
        howmany_div2rr = div2rr/A;
%         if howmany_div4rr < 1
%             continue;
%         elseif howmany_div4rr == 1
%             break;
%         else howmany_div4rr > 1
%             warning('�Ȃ���howmany_div4rr���P�ȏ�ł���I�I');
%         end
        if howmany_div2rr < 1
            continue;
%         elseif howmany_div2rr >= 1
%         elseif howmany_div2rr >= 1.2 % �]�T���������邽�߂�1.2�Ƃ���
        elseif howmany_div2rr >= 2.2 % �]�T���������邽�߁E�^�񒆂Ƀ��[�U�|�C���^�����ꂽ������
            break;
        end

    end
    
    sp_number1 = sp_number/2; 
    sp_number2 = sp_number/2;
    sum_spNum1 = 0;
    sum_spNum2 = 0;
%     for theta = first_theta:-theta1:pi/2 + theta1/2
    for theta = first_theta:-theta1:pi/2 + deg2rad(1)
%     for theta = linspace(pi,pi/2,howmany_row)
        rr = hemis_r*sin(theta); %theta�̂Ƃ��̒��S����~�܂ł̋���
%         div4rr = 2*pi*rr/4; % �~����4�Ŋ�����
        div2rr = 2*pi*rr/2; % �~����2�Ŋ�����
%         howmany_div4rr = floor(div4rr/A);%�X�s�[�J�������邩
        howmany_div2rr = floor(div2rr/A);%�X�s�[�J�������邩
        tmp_phai = pi/(howmany_div2rr+1); %�񂲂Ƃ̏����z�u��phai
        tmp = sum_spNum1 + howmany_div2rr*2;
        if tmp <= sp_number1
            % �ʏ폈��
            sum_spNum1 = tmp;
%              for j = 0:3
            for j = 0:1
%                 for phai = linspace(j*pi+theta3,(j+1)*pi-theta3,howmany_div2rr)
                 for phai = linspace(j*pi+tmp_phai,(j+1)*pi-tmp_phai,howmany_div2rr)

                  x = hemis_r*sin(theta)*cos(phai);
                  y = hemis_r*sin(theta)*sin(phai);
                  z = -hemis_r*cos(theta)+z_position;
                  sp_list(i) = UltrasonicSpeaker3D_3(x, y, z,f_x,f_y,f_z,f); 
                  sp_list(i).row_number = row_number;

    %               %�g�ݍ��킹�����F����
    %               if ismember(row_number, RowsCombNum)
    %                   sp_list(i).qui_color = 'red'; 
    %               end
                  %�����͈ʑ��𔽓]
%                   if j == 2||j==3
%                      if ismember(row_number, RowsCombNum)
%                         sp_list(i).qui_color = 'red'; 
%                      else
%                          sp_list(i).qui_color = 'black';
%                      end
%                      sp_list(i).phase = pi;
%                   else
%                      if ismember(row_number, RowsCombNum)
%                         sp_list(i).qui_color = 'blue'; 
%                      else
%                         sp_list(i).qui_color = 'green';
%                      end
% 
%                   end
                  if j == 0
                      sp_list(i).qui_color = 'red';
                      sp_list(i).phase = phase;
                  elseif j == 1
                      sp_list(i).qui_color = 'blue';
                      sp_list(i).phase = phase + pi;
                  end
                  i = i+1;
                end
             end     
             row_number = row_number+1;
        else
            % �Ō�̗�̏���
            
            break;
        end
         
        endtheta = theta;
        
%         if row_number == 4
%             howmany_div4rr = 4; % 4��ڂ̓X�s�[�J�̕��ɗ]�T���������邽�߁A4�ɂ���.
%         elseif row_number == 5
%             howmany_div4rr = 5; % 5��ڂ̓X�s�[�J�̕��ɗ]�T���������邽�߁A5�ɂ���.
%         end


        

    end
    howmany_sp = length(sp_list);
    sp_number2 = howmany_sp;
    
    sum_spNum2 = 0;
    
    for theta = endtheta-theta1:-theta1:pi/2 + deg2rad(1)
        rr = hemis_r*sin(theta); %theta�̂Ƃ��̒��S����~�܂ł̋���
%         div4rr = 2*pi*rr/4; % �~����4�Ŋ�����
        div2rr = 2*pi*rr/2; % �~����2�Ŋ�����
%         howmany_div4rr = floor(div4rr/A);%�X�s�[�J�������邩
        howmany_div2rr = floor(div2rr/A);%�X�s�[�J�������邩
        tmp_phai = pi/(howmany_div2rr + 1);
        tmp = sum_spNum2 + howmany_div2rr*2;
        if tmp <= sum_spNum1
            % �ʏ폈��
            sum_spNum2 = tmp;
            for j = 0:1
%                 for phai = linspace(j*pi+theta3,(j+1)*pi-theta3,howmany_div2rr)
%              for j = 0:3
%                 for phai = linspace(j*2*pi/4+theta3,(j+1)*2*pi/4-theta3,howmany_div4rr)
               for phai = linspace(j*pi+tmp_phai,(j+1)*pi-tmp_phai,howmany_div2rr)
                  x = hemis_r*sin(theta)*cos(phai);
                  y = hemis_r*sin(theta)*sin(phai);
                  z = -hemis_r*cos(theta)+z_position;
                  sp_list(i) = UltrasonicSpeaker3D_3(x, y, z,f_x,f_y,f_z,f); 
                  sp_list(i).row_number = row_number;

    %               %�g�ݍ��킹�����F����
    %               if ismember(row_number, RowsCombNum)
    %                   sp_list(i).qui_color = 'red'; 
    %               end
                  %�����͈ʑ��𔽓]
%                   if j == 2||j==3
%                      if ismember(row_number, RowsCombNum)
%                         sp_list(i).qui_color = 'red'; 
%                      else
%                          sp_list(i).qui_color = 'black';
%                      end
%                      sp_list(i).phase = pi;
%                   else
%                      if ismember(row_number, RowsCombNum)
%                         sp_list(i).qui_color = 'blue'; 
%                      else
%                         sp_list(i).qui_color = 'green';
%                      end
% 
%                   end
                  if j == 0
                      sp_list(i).qui_color = 'magenta';
                      sp_list(i).phase = 0;
                  elseif j == 1
                      sp_list(i).qui_color = 'cyan';
                      sp_list(i).phase = pi;
                  end
                  
                  i = i+1;
                end
             end  
             row_number = row_number+1;
        else
            % �Ō�̗�̏���
            last_row_spnum = sum_spNum1 - sum_spNum2;
            div2last_row_spnum = last_row_spnum/2;
            sum_spNum2 = sum_spNum2 + last_row_spnum;
            tmp_phai = pi/(div2last_row_spnum+1);
            for j = 0:1
                for phai = linspace(pi*j+tmp_phai,(j+1)*pi-tmp_phai,div2last_row_spnum)
                    x = hemis_r*sin(theta)*cos(phai);
                      y = hemis_r*sin(theta)*sin(phai);
                      z = -hemis_r*cos(theta)+z_position;
                      sp_list(i) = UltrasonicSpeaker3D_3(x, y, z,f_x,f_y,f_z,f); 
                      sp_list(i).row_number = row_number;

        %               %�g�ݍ��킹�����F����
        %               if ismember(row_number, RowsCombNum)
        %                   sp_list(i).qui_color = 'red'; 
        %               end
                      %�����͈ʑ��𔽓]
    %                   if j == 2||j==3
    %                      if ismember(row_number, RowsCombNum)
    %                         sp_list(i).qui_color = 'red'; 
    %                      else
    %                          sp_list(i).qui_color = 'black';
    %                      end
    %                      sp_list(i).phase = pi;
    %                   else
    %                      if ismember(row_number, RowsCombNum)
    %                         sp_list(i).qui_color = 'blue'; 
    %                      else
    %                         sp_list(i).qui_color = 'green';
    %                      end
    % 
    %                   end
                  if j == 0
                      sp_list(i).qui_color = 'magenta';
                      sp_list(i).phase = 0;
                  elseif j == 1
                      sp_list(i).qui_color = 'cyan';
                      sp_list(i).phase = pi;
                  end
                  
                  i = i+1;
                  
                end
            end
            
            break;
        end
    end
    
    
    
    howmany_sp = length(sp_list);
    % �t�H���_�̗L���̃`�F�b�N
    foldercheck = exist(movefilename,'dir'); % �����t�H���_�������7, �Ȃ����7�ȊO��Ԃ�
    if foldercheck == 7
        disp(strcat('�t�H���_ ',movefilename,' �͂���܂���.'));
    else
        disp('�t�H���_�͂Ȃ��̂ō��܂�');
        mkdir(movefilename);
    end
   

    
    h = figure('visible','off');
    
    
    x0=10;
    y0=10;
    width=650;
    height=500;
    set(h,'units','points','position',[x0,y0,width,height]);
    ax1 = axes('Position',[0 0 1 1],'Visible','off');
    ax2 = axes('Position',[.3 .2 .6 .7]);
    axes(ax2);
    
    %�X�s�[�J�̏ꏊ����\��
    for i = 1:howmany_sp
        speeker_quiver3(sp_list(i).x0,sp_list(i).y0,sp_list(i).z0,sp_list(i).v_x,sp_list(i).v_y,sp_list(i).v_z,sp_list(i).qui_color,10)
        hold on
    end
    set(ax2, 'FontSize', 20);
    
    ax = gca;
    ax.XLabel.String = 'x-axis [mm]';
    ax.YLabel.String = 'y-axis [mm]';
    ax.ZLabel.String = 'z-axis [mm]';
    view(90,0)
    
    axes(ax1);
    descr = {strcat('red',num2str(rad2deg(redColorPhase)),' [deg]'), ...
        strcat('blue',num2str(rad2deg(blueColorPhase)),' [deg]'), ...
        strcat('magenta',num2str(rad2deg(magentaColorPhase)),' [deg]'), ...
        strcat('cyan',num2str(rad2deg(cyanColorPhase)),' [deg]'), ...
        };
    text(.025,0.7,descr,'FontSize',18);
    name =strcat('TwinTrap_R',num2str(hemis_r),'N',num2str(howmany_sp)); 
    set(gcf, 'PaperPositionMode','auto');
    print(name,'-dpng','-r0'); %�S��
    movefile(strcat(name,'.png'), movefilename);
    
%     zlim([0 range])
%     print(strcat('kakuninup_z',num2str(nameIndex)),'-dpng','-r0'); %�㕔�̂�
%     movefile(strcat('kakuninup_z',num2str(nameIndex),'.png'), movefilename);
%     
    name =strcat('TwinTrap_R',num2str(hemis_r),'N',num2str(howmany_sp),'.fig'); 
    saveas(gcf,name);
    movefile(name, movefilename);
    
    csvwrite_spPositionColor_paraview_3; %csvfile�ɐU���q�̈ʒu�������o��
    
    close all
%%
    howmany_sp = length(sp_list);

    bessel = zeros(range_N,range_N,range_N,howmany_sp);
    for i = 1:howmany_sp
        sp_vector = [sp_list(i).v_x sp_list(i).v_y sp_list(i).v_z];
        vx = sp_list(i).v_x;
        vy = sp_list(i).v_y;
        vz = sp_list(i).v_z;
%         phai_list = makePhaiList2(sp_list(i).x0, sp_list(i).y0, sp_list(i).z0, ...
%             vx, vy, vz, X, Y, Z);
  phai_list = makePhaiList3(sp_list(i).x0, sp_list(i).y0, sp_list(i).z0, ...
            vx, vy, vz, X, Y, Z);
%         bessel(:,:,:,i) = bessel_func(wave_number,a,phai_list);
         bessel(:,:,:,i) = bessel_func2(wave_number,a,phai_list);
    end
    
    coef = bessel; % �W���p�̕ϐ�
    clearvars bessel phai_list

    % ���̌������X�g������
    % ���ꂼ��̃X�s�[�J�p�̌������X�g
    %attenuation_list = zeros(range_N,range_N,range_N,howmany_sp);
    %[a_func, a_func_x] = make_attenuation_list3D_3_2();
    [a_func, a_func_x] = make_attenuation_list3D_3_3(); %2018/11/12�@�ύX
    for i = 1:howmany_sp   
    %     attenuation_list(:,:,:,i) = make_attenuation_list3D_2(sp_list(i).x0, sp_list(i).y0, sp_list(i).z0, ...
    %         X,Y,Z);

        %�������
        XYZ_D = sqrt( (X-sp_list(i).x0).^2 + (Y-sp_list(i).y0).^2 + (Z-sp_list(i).z0).^2 );
        a_func_result = a_func(a_func_x,XYZ_D);
        
        %attenuation_list(:,:,:,i) = a_func_result.*bessel(:,:,:,i);
        coef(:,:,:,i) = a_func_result.*coef(:,:,:,i);
    end

    % �������팸�̂��ߕϐ����폜
    clearvars bessel bessel_above XYZ_D



    %%
    % �V�~�����[�V�����J�n 
    % ���ꂼ��̃X�s�[�J�̉����̘a���v�Z
    % �G�l���M�[�ɕϊ��i2�悷��j
    % ���ԕ��ςɂ���
    j = 1;
    


    ramda = v/f;
    wave_number = 2*pi/ramda;
    
    sum_absP = zeros(range_N,range_N,range_N);

    

    %phase = pi;

    clearvars a_func_result phai_list
    

    U_sum = zeros(range_N,range_N,range_N); %�e���Ԗ��̃|�e���V�����𑫂��Ă������߂̂��� 

        
        P_idx = 1;
        P_avarage= zeros(range_N,range_N,range_N);
        P_real = zeros(range_N,range_N,range_N);
        P_imag = zeros(range_N,range_N,range_N);
%         %��ڂ̏W�������g���u�i�����j
        for i = 1:length(sp_list) % sp_list�̗�̐������ispeaker�̐��j�J��Ԃ�
            d = sqrt((X-sp_list(i).x0).^2 + (Y-sp_list(i).y0).^2 + (Z-sp_list(i).z0).^2); % d�͒��S����̋���
            P_real(:,:,:) = P_real(:,:,:) + coef(:,:,:,i).*real(exp(1j*(wave_number.*d - sp_list(i).phase)));
            P_imag(:,:,:) = P_imag(:,:,:) + coef(:,:,:,i).*imag(exp(1j*(wave_number.*d - sp_list(i).phase)));
%             if ismember(sp_list(i).row_number,RowsCombNum)
%                 %P(:,:,:) = P(:,:,:) + attenuation_list(:,:,:,i).*sin(wave_number.*d - 2*pi*f*t - sp_list(i).phase);
% %                 P_real(:,:,:) = P_real(:,:,:) + attenuation_list(:,:,:,i).*real(exp(1j*(wave_number.*d - sp_list(i).phase)));
% %                 P_imag(:,:,:) = P_imag(:,:,:) + attenuation_list(:,:,:,i).*imag(exp(1j*(wave_number.*d - sp_list(i).phase)));
%                 P_real(:,:,:) = P_real(:,:,:) + coef(:,:,:,i).*real(exp(1j*(wave_number.*d - sp_list(i).phase)));
%                 P_imag(:,:,:) = P_imag(:,:,:) + coef(:,:,:,i).*imag(exp(1j*(wave_number.*d - sp_list(i).phase)));
% 
%             else
%                 %P(:,:,:) = P(:,:,:) + attenuation_list(:,:,:,i).*sin(wave_number.*d - 2*pi*f*t - sp_list(i).phase - phase);
% %                 P_real(:,:,:) = P_real(:,:,:) + attenuation_list(:,:,:,i).*real(exp(1j*(wave_number.*d - sp_list(i).phase - phase)));
% %                 P_imag(:,:,:) = P_real(:,:,:) + attenuation_list(:,:,:,i).*imag(exp(1j*(wave_number.*d - sp_list(i).phase - phase)));
%                 P_real(:,:,:) = P_real(:,:,:) + coef(:,:,:,i).*real(exp(1j*(wave_number.*d - sp_list(i).phase - phase)));
%                 P_imag(:,:,:) = P_imag(:,:,:) + coef(:,:,:,i).*imag(exp(1j*(wave_number.*d - sp_list(i).phase - phase)));
%             end               

            P_idx=P_idx+1;
        end
        
        P_avarage = (1/sqrt(2))*sqrt(P_real.^2+P_imag.^2); % P�̎��s�l�����߂�B
        %P_angle = angle(cos(P_real)+1j.*(sin(P_imag)));% �ʑ������Q�b�g����
        P_angle = angle(P_real+1j.*(P_imag));% �ʑ������Q�b�g����
        
        dispXYZSimu(strcat(titleName,' P-angle'),X,Y,Z,P_angle, xslice, yslice, zslice);% �ʑ�����\��
        colormap(hsv);
        saveSimuFig_2('P_angle_phase',num2str(floor(rad2deg(phase))),movefilename);
%         
%         P_angle01 = (P_angle>0 & P_angle<pi); % �ʑ� 0 ~ 180�x�𒊏o
%         P_angle_0 = (P_angle01 == 0); %�ʑ�-180~0�𒊏o
%         minusOne = P_angle_0.*(-1); %�ʑ�-180~0�̂Ƃ���-1
%         P_angle_negaPosi = P_angle01;
%         P_angle_negaPosi = P_angle_negaPosi+minusOne; %P_angle_negaPosi��1��-1�ŕ\���ꂽ
%         dispXYZSimu(strcat(titleName,' P angle negaposi'),X,Y,Z,P_angle_negaPosi);% �e�X�g�p�\��
%         P = P_avarage.*P_angle_negaPosi; 
        
        %P_avarage��\��
%         dispXYZSimu(titleName,X,Y,Z,P_avarage, xslice, yslice, zslice);
        %�X�s�[�J�̏ꏊ����\��
        h = figure('visible','off');
%         figure
        x0=10;
        y0=10;
        width=850;
        height=500;
        set(gcf,'units','points','position',[x0,y0,width,height])
        ax1 = axes('Position',[0 0 1 1],'Visible','off');
        ax2 = axes('Position',[.35 .2 .6 .71]);
        axes(ax2);  

        hold on
        xslice_plot = slice(X,Y,Z,P_avarage,xslice,yslice,zslice(1));
        volumeData = get(xslice_plot,'CData');
        minVolumeData = min(min(min(P_avarage)));
        maxVolumeData = max(max(max(P_avarage)));
    %     pbaspect([1 1 1]) % graph�c����
        pbaspect([max(max(max(X)))-min(min(min(X))) max(max(max(Y)))-min(min(min(Y)))  max(max(max(Z)))-min(min(min(Z)))])
        set(ax2, 'FontSize', 20);
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
        set(ax,'FontSize', 20);
        for i = 1:length(sp_list)
           speeker_quiver3(sp_list(i).x0,sp_list(i).y0,sp_list(i).z0,sp_list(i).v_x,sp_list(i).v_y,sp_list(i).v_z,sp_list(i).qui_color,10)
        end

        % ���݂̈ʑ���\��
        axes(ax1);
        descr = {strcat('red',num2str(rad2deg(redColorPhase)),' [deg]'), ...
            strcat('blue',num2str(rad2deg(blueColorPhase)),' [deg]'), ...
            strcat('magenta',num2str(rad2deg(magentaColorPhase)),' [deg]'), ...
            strcat('cyan',num2str(rad2deg(cyanColorPhase)),' [deg]'), ...
            };
        text(.025,0.7,descr,'FontSize',22)
        

        fig = gcf;
        fig.PaperUnits = 'inches';
        fig.PaperPosition = [0 0 30 15]; 
        
        axes(ax2);
        saveSimuFig('P_avarage_phase',num2str(floor(rad2deg(phase))),movefilename,P_avarage);
        
        %�|�e���V�����̌v�Z�̂��߂̃p�����[�^
%         c_0 = v/1000; %[mm/s] -> [m/s]
%         slice_x = 0; slice_y = 0; slice_z = 0;
%         time_div_N = 20;
%         t_div = T/time_div_N;%�|�e���V�����v�Z�̂��߂̌v�Z�񐔁i����������Ŋ��邩)
%         tlist = linspace(0,T-t_div,time_div_N);
%         t_i = 0;
%         for t = tlist
%             t_i = t_i + 1;
%             P_real = zeros(range_N,range_N,range_N);
%             P_imag = zeros(range_N,range_N,range_N);
%             for j = 1:length(sp_list) % sp_list�̗�̐������ispeaker�̐��j�J��Ԃ�
%                 d = sqrt((X-sp_list(j).x0).^2 + (Y-sp_list(j).y0).^2 + (Z-sp_list(j).z0).^2); % d�͒��S����̋���
%                 P_real(:,:,:) = P_real(:,:,:) + coef(:,:,:,j).*real(exp(1j*(wave_number.*d - 2*pi*f*t - sp_list(j).phase)));
%                 P_imag(:,:,:) = P_imag(:,:,:) + coef(:,:,:,j).*imag(exp(1j*(wave_number.*d - 2*pi*f*t - sp_list(j).phase)));
% 
% %                 if ismember(sp_list(j).row_number,RowsCombNum)
% %                     %P(:,:,:) = P(:,:,:) + attenuation_list(:,:,:,i).*sin(wave_number.*d - 2*pi*f*t - sp_list(j).phase);
% %     %                 P_real(:,:,:) = P_real(:,:,:) + attenuation_list(:,:,:,i).*real(exp(1j*(wave_number.*d - sp_list(j).phase)));
% %     %                 P_imag(:,:,:) = P_imag(:,:,:) + attenuation_list(:,:,:,i).*imag(exp(1j*(wave_number.*d - sp_list(j).phase)));
% %                     P_real(:,:,:) = P_real(:,:,:) + coef(:,:,:,i).*real(exp(1j*(wave_number.*d - sp_list(j).phase - delta_time*(i-1)))); % sin(k*d-phi-omega*t)
% %                     P_imag(:,:,:) = P_imag(:,:,:) + coef(:,:,:,i).*imag(exp(1j*(wave_number.*d - sp_list(j).phase - delta_time*(i-1))));
% % 
% %                 else
% %                     %P(:,:,:) = P(:,:,:) + attenuation_list(:,:,:,i).*sin(wave_number.*d - 2*pi*f*t - sp_list(j).phase - phase);
% %     %                 P_real(:,:,:) = P_real(:,:,:) + attenuation_list(:,:,:,i).*real(exp(1j*(wave_number.*d - sp_list(j).phase - phase)));
% %     %                 P_imag(:,:,:) = P_real(:,:,:) + attenuation_list(:,:,:,i).*imag(exp(1j*(wave_number.*d - sp_list(j).phase - phase)));
% %                     P_real(:,:,:) = P_real(:,:,:) + coef(:,:,:,i).*real(exp(1j*(wave_number.*d - sp_list(j).phase - phase - delta_time*(i-1))));
% %                     P_imag(:,:,:) = P_imag(:,:,:) + coef(:,:,:,i).*imag(exp(1j*(wave_number.*d - sp_list(j).phase - phase - delta_time*(i-1))));
% %                 end               
%             end
%             
%             P = P_imag; %P_imag(cos����)�����o��
%             dispXYZSimu(titleName,X,Y,Z,P, xslice, yslice, zslice);
%             saveSimuFig(strcat(saveName,'_P_time',num2str(t_i)),'',movefilename,P);
% %             U = PotentialCalc2(X,Y,Z,P,range,range_N,slice_x,slice_y,slice_z, c_0, f);
%             U = PotentialCalc3(X, Y, Z, P, delta_x, delta_y, delta_z,slice_x, slice_y, slice_z, c_0, f);
%             U_sum = U_sum+U;
% 
%             P_idx=P_idx+1;
%             
%             close all
%         end
%         abs_P = abs(P);
%         sum_absP = sum_absP + abs_P; %abs_P���ǂ�ǂ񑫂��Ă���
          
        
  
    
%     avarage_P = sum_absP./time_div_N;
    %titleName = strcat(titleName,' time avarage');
%     dispXSimu(titleName,X,Y,Z,avarage_P);
    %�X�s�[�J�̏ꏊ����\��
%     for i = 1:length(sp_list)
%        speeker_quiver3(sp_list(i).x0,sp_list(i).y0,sp_list(i).z0,sp_list(i).v_x,sp_list(i).v_y,sp_list(i).v_z,sp_list(i).qui_color,10)
%     end
%     saveSimuFig_2(strcat(saveName,'_avarage'),'',movefilename);
    
%     Potential = U_sum./time_div_N; %�|�e���V�����̎��ԕ���    
%     dispXSimu(titleName,X,Y,Z,Potential);
%     saveSimuFig_2(strcat(saveName,'_Xpotential'),'',movefilename);
%     dispYSimu(titleName,X,Y,Z,Potential);
%     saveSimuFigY(strcat(saveName,'_Ypotential'),'',movefilename,Potential);
%     dispZSimu(titleName,X,Y,Z,Potential);
%     saveSimuFigZ(strcat(saveName,'_Zpotential'),'',movefilename,Potential);
%     dispXYZSimu(titleName,X,Y,Z,Potential, xslice, yslice, zslice);
%     saveSimuFig(strcat(saveName,'_3Dpotential'),'',movefilename,Potential);
% 
% %     CalcFxFyFz_2(X,Y,Z,U,range,range_N,slice_x,slice_y,slice_z, saveName, movefilename);
%     CalcFxFyFz_3(X, Y, Z, Potential, delta_x, delta_y, delta_z ,slice_x, slice_y, slice_z, saveName, movefilename) ;
%     close all;
    
    clear
end


