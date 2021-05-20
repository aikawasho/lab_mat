% theta_list ���O�̂Ƃ���D���������Ƃ��Ă��܂��̂ŉ���
function D = bessel_func2(k,a,theta_list)
    exceed_90 = double(theta_list < pi/2); % 90�x���������̂�0�Ƃ��Ă��܂�
    D = 2.*besselj(1,k*a.*sin(theta_list)) ./ (k*a.*sin(theta_list));
    D = exceed_90.*D;
    D(isnan(D)) = 1; % nan���܂�ł���v�f��inf�Ȃ̂�1�Ƃ���
end