% ���ǁ@�ߎ������Ă��̊֐��������Ă���Ƃ��������ɂ���(2018/04/13)
%�@ make_attenuation_list3D_3�Ƃ̋ߎ��̔�r
% ������(4m)�܂ł���Ă݂�

function [a_func, x] = make_attenuation_list3D_3_3()
    %%�����̌v�Z�i�K���ȋߎ��j
    %ver2 �ł͈ꎟ�֐��ߎ����������A�w���֐��ߎ��ɂ���
    %xlist = [5.5	6	7	10	20	30	50	117	150	200	300	400	435	593	715];
    %plist = [883.8834765	714.177849	707.1067812	585.4844148	273.6503243	185.2619767	115.9655121	45.67909806	45.04270196	36.2038672	23.82949853	18.95046174	11.9501046	7.566042559	6.929646456];
    %fun = @(x,xlist)x(1)./(x(2)*xlist); %����� y = a/(b*x)�@�̊֐�
    xlist = [25	30	40	50	60	70	80	90	100	110	130	150	200];
    plist = [128.6934342	115.2584053	86.2670273	65.40737726	56.56854249	48.7903679	42.14356416	35.56747109	34.50681092	30.97127702	25.24371209	24.39518395	16.40487732];
%     a_func = @(x,xlist)x(1)./xlist + x(2); %����� y = x0/x + x1�@�̊֐�
    a_func = @(x,xlist)x(1)./(xlist-x(3)) + x(2); %����� y = x0/(x-x2) + x1�@�̊֐�
    %x0 = [505,0]; %�@�Ƃ肠�����ŏ��� y = 500/x + 0�@�Ƃ���
    x0 = [505,0,1];
%     xlist = [50	117	150	200	300	400	435	593	715];
%     plist = [115.9655121	45.67909806	45.04270196	36.2038672	23.82949853	18.95046174	11.9501046	7.566042559	6.929646456];
%     fun = @(x,xlist)x(1)*xlist+x(2); %�P���֐� y = a*x�@�̊֐�
%     x0 = [-1 1000]; %�@�Ƃ肠�����ŏ��� y = 10e^x�@�Ƃ���

    options = optimoptions(@lsqcurvefit,'Display','none');
    x = lsqcurvefit(a_func,x0,xlist,plist,[],[],options); %����Ɉ�ԗǂ��ߎ������Ă����


    xlist2 = [0	10	20	30	40	50	60	70	80	90	100	110	1000	2000	3000	4000];
    plist2 = [574.1707063	330.9259736	185.2619767	136.4716088	110.3086579	83.43860018	68.44793642	57.41707063	55.22503961	45.46696603	41.08290399	38.39589822	3.62038672	1.767766953	0.585484415	0.530330086];
    a_func2 = @(x2,xlist2)x2(1)./(xlist2-x2(3)) + x2(2);
    x0_2 = [505,0,-1];
    
    x2 = lsqcurvefit(a_func2,x0_2,xlist2,plist2);
    
%     % �ߎ��̊m�F
%     h = figure;
%     hold on
% %     plot(xlist,plist);
% %     plot(xlist,a_func(x,xlist));    
%     plot(xlist,plist,xlist2,a_func(x,xlist2));
%     plot(xlist2,plist2,xlist2,a_func2(x2,xlist2));
%     xlim([-10 4000])
%     title('make attenuation list3D-3-3test')
%     legend('experiment','kinji','experiment2','kinji2')
%     
%     % �ߎ��̊m�F�ilog�\���j
%     h2 = figure;
%     hold on
% %     plot(xlist,plist);
% %     plot(xlist,a_func(x,xlist));    
%     plot(xlist,plist,xlist2,a_func(x,xlist2));
%     plot(xlist2,plist2,xlist2,a_func2(x2,xlist2));
%     xlim([-10 4000])
%     title('make attenuation list3D-3-3test')
%     legend('experiment','kinji','experiment2','kinji2')
%     ax = gca;
%     ax.XScale = 'log';
    
    a_func = a_func2; x = x2;
% 
%     %%�����̌v�Z�i�K���ȋߎ��j
%     a_list = zeros(length(X), length(Y), length(Z));
% %     for i = 1:length(X)
% %         for j = 1:length(Y)
% %             for k = 1:length(Z)
% %                 a_list(i,j,k) = fun(x,sqrt((X(i,j,k)-xx0)^2 + (Y(i,j,k)-yy0)^2 + (Z(i,j,k)-zz0)^2)); 
% %             end
% %         end
% %     end
% 
%     %�������
%     XYZ_D = sqrt( (X-xx0).^2 + (Y-yy0).^2 + (Z-zz0).^2 );
%     a_list = a_func(x,XYZ_D);
%     a_list = a_list ./ max(max(max(a_list))); %���K���i�ő�l��1�ɂ���j 
% 

end