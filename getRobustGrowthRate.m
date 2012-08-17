function [rate] = getRobustGrowthRate(t,od,lower,upper)

% calculates growth rate from od curve
% t == array containing time points
% od == array containing od values at these time points
% lower == lower bound for od values (beginnig of exponential growth)
% upper == upper bound for od values (end of exponential growth)

% finds first index for which od>lod && od at the following data point
% greater than for this one
od_tmp1=od;
od_tmp2=od;
od_tmp2(1)=[];
od_tmp1(end)=[];

%l_ind=find(od_tmp1>=lower & od_tmp2>=od_tmp1,1,'first'); % finds index corresponding to lod
%u_ind=find(od>=upper,1,'first'); % finds index corresponding to uod
l_ind=find(log2(od_tmp1)>=lower & log2(od_tmp2)>=log2(od_tmp1),1,'first'); % finds index corresponding to lod
u_ind=find(log2(od)>=upper,1,'first'); % finds index corresponding to uod

if( isempty( u_ind ) )
    l_ind = 1;
    u_ind = size(t,2);
end
% do the naive thing:
%rate = ( t(u_ind) - t(l_ind) ) / 60
%return;

if isempty(u_ind)
    u_ind=length(od); % if uod is not reached, use whole array
end

% default
rate = NaN;

if ~isempty(l_ind) && l_ind<u_ind % lind>=uind can happen for non-monotonic growth curves
    
    t_tmp=t(l_ind:u_ind); % in hours

    % the ODs between the lower and upper thresholds
    od_tmp=log2(od(l_ind:u_ind)); % * log2( upper/lower ); % in doublings
    
    
    %    t_tmp=cat(2,t_tmp,ones(length(t_tmp),1));
    
    %    [b,bint]=regress(od_tmp,t_tmp);
    %    g=b(1); % growth rate in 1/h from linear regression
    %    g_eb=b(1)-bint(1); % error estimate for g
    %    odt0=exp(b(2)); % extrapolated od at t=0 (direct value typically hidden in measurement noise)
    %    odt0_eb=exp(b(2)-bint(2));
    
    if( size(t_tmp,2) >= 3 )      
    
        [ g, r ] = robustfit( t_tmp,od_tmp );
        %    g(2) / log2( od_tmp(1) / od_tmp(end) )
 %       r
        rate = g(2) * 60;
        % in case the rate is clear messed up
        if( ( rate <= 0.01 ) || ( r.s > 0.05 ) )
%            rate = NaN;
        end
    end
else
    rate = NaN;
end

