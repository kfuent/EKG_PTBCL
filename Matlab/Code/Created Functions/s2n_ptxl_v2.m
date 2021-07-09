function [ dia_num ] = s2n_ptxl_v2( rhy, sample,scp_code  )
%%s2n_ptxl_v2 Summary of this function goes here
%   diag = String, from scp_statement (diagnostic, form, rhythm)
%           Value should be saved in 'ptbxl_statments.mat'

%   sample = interger of individual in sample size
%            Based on data set (max 21837 for ptbxl_database)
%   scp_code = String from csv. (scp_codes) 

%   OUTPUT
%   dia__num  = numerical value based on diag postion. 
%   Detailed explanation goes here

% First Col of Diagnostic 
for i = 1:sample
    for j = 1:size(rhy,1)
        idx_1 = ( contains( scp_code{i,1},rhy{j,1} ) ); 
        if j == size(rhy,1)
            if idx_1 == 1
                j = size(rhy,1);
                break
            elseif idx_1 == 0 
                j = 0;
                break
            end
        elseif idx_1 == 1
            break
            
        end
    end
    dia_num(i,1) = j;
end


for k = 2:10
for i = 1:sample
    if dia_num(i,k-1) == size(rhy,1) 
        dia_num(i,k) = 0;
    elseif dia_num(i,k-1) > 0 
        dia_num(i,k) = 1;
    else 
        dia_num(i,k) = 0;
    end
    if dia_num(i,k) ==1
        for j = dia_num(i,k-1)+1:size(rhy,1)
            idx_1 = ( contains( scp_code{i,1},rhy{j,1} ) );

            if idx_1 == 0
                if j == size(rhy,1)               
                    j = 0;               
                    break            
                end               
            elseif idx_1 == 1
                if j == dia_num(i,1)               
                    if j == size(rhy,1)
                        j = 0;
                        break
                    else
                        j = j+1;
                    end
                elseif j ~= dia_num(i,1)
                    break        
                end 
            end          
        end
        dia_num(i,k) = j;
    end
end
end

w = sum(dia_num);
for i = 1:size(w,2)
    if w(i) == 0
        y = i;
        break
    end
end

    
dia_num = dia_num(:,1:y-1);


end

