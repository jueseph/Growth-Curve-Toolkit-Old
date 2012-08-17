function x=inverse_michaelis_menten(beta,y)

k = beta(1);
alpha = beta(2);

x = ( y * k ) ./ ( alpha - y );