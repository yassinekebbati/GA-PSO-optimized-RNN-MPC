%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Yassine Kebbati
% Date: 10/10/2021
% Control GA-Algo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i = RouetteWheelSelection(p)

%     p = p/sum(p);
%     r = rand*sum(p);
    r = rand*sqrt(sum(p));
    c = cumsum(p);
    i = find(r <= c, 1, 'first');
    

end