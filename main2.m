% This is a fifth-order multiple recursive generator. 
% The sequence is: x_n = (a_1 x_{n-1} + a_5 x_{n-5}) mod m
% with a_1 = 107374182, a_2 = a_3 = a_4 = 0, a_5 = 104480 and m = 2^31-1.
% We initialize the generator with x_n = s_n MOD m for n = 1..5,
% where s_n = (69069 * s_{n-1}) mod 2^32, and s_0 = s is the user-supplied seed.
% The seeds must lie in the range [0, 2^31 - 2] with at least one non-zero value 

clear
clc
close all

% the user-supplied seed
seed = 1;
% x = LCG(seed);
s0 = seed;
s1 = mod(69069*s0,2^32);
s2 = mod(69069*s1,2^32);
s3 = mod(69069*s2,2^32);
s4 = mod(69069*s3,2^32);
s5 = mod(69069*s4,2^32);
s_n = [s1 s2 s3 s4 s5];

s_n_mod = mod(s_n, (2^31-1) );
x = s_n_mod;
loop = 10000;
% for ii = 1 : loop
%     noise_seq = gen_Random(x);
%     x(2:5) = x(1:4);
%     x(1) = noise_seq;
% end
% noise_seq
a = [107374182 0 0 0 104480];
for ii = 6:10006
    x(ii) = mod(( a(5) * x(ii - 1) + a(1) * x(ii - 5)) , 2^31-1);
end
