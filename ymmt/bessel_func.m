function D = bessel_func(k,a,theta_list)
    exceed_90 = double(theta_list < pi/2); % 90�x���������̂�0�Ƃ��Ă��܂�
    D = 2.*besselj(1,k*a.*sin(theta_list)) ./ (k*a.*sin(theta_list));
    D = exceed_90.*D;
end