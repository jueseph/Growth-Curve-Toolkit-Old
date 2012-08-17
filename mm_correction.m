function y=mm_correction(beta,x)

k = beta(1);
alpha = beta(2);
b = beta(3);

y = ( ( x - b ) * k ) ./ ( alpha - ( x - b ) );