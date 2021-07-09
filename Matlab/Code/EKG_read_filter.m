clc; close all; clear all
%% Reading ptbxl_database
data1 = readtable('ptbxl_database.csv');%Doctor Statments
data2 = readtable('scp_statements.csv');%Statements for Diag

%% Sep. Data into different componemts. 
scp_c2ode = data1(:, 12);%Scp_Code
sig_error = data1(:,20:25);%Anything Wrong with Data Set (ptxl)
label = data2(:, 1:5);%String, description, diag, form, rhythm
lab_short = label(:, [1 3:5]);%String, diag, form, rhythm
location = data1(:,27);% Directory for 100 hz data

%% Based on scp_statements (position matters) 
diagno = lab_short(1:44,1);    %Diagnostic 
form = lab_short([1:4 45:45+14],1);%Form
rhythm  = lab_short(59:end,1)  ;%Rhythm
%% Based on String on a MATRCIX 
Sample = 21837;
%s2n_ptxl_v2 looks at Scp_Code and srarches for any string in Var1. 
% Max sample 21837. Code goes from i = 1:Sample
dia_ = s2n_ptxl_v2(diagno,Sample, scp_c2ode);
form_ = s2n_ptxl_v2(form,Sample, scp_c2ode);
rhy = s2n_ptxl_v2(rhythm,Sample, scp_c2ode);
%% Saves Variables in terms of variables
%save('EKG_dia_form_rhy_ALL.mat')
%% Loads Variables
load('EKG_dia_form_rhy_ALL.mat')
%% Filtering Data
set = Sample;
for i = 1:set
    for j = 1:size(sig_error,2)
        x(i,j) = strlength(sig_error{i,j});%Looking if sig_error
        if(x(i,j))> 0 
            %if x contains anything, note location, and move to next sample 
            w(i) = i; %ECG_ID Location where something is wrong
            i = i + 1;
            break
        end
    end
end
for i = 1:length(w)
    if w(i)== 0
        EKG_Filt(i) = i;%looking for lECG Locations where there is no data issue
    end
end
EKG_Filt = nonzeros(EKG_Filt);% All "good Data"

%% Filtering Data to desired Data
for i = 1:length(EKG_Filt)
    dia_filt(i,:) = dia_(EKG_Filt(i),:);
    form_filt(i,:)= form_(EKG_Filt(i),:);
    rhy_filt(i,:)= rhy(EKG_Filt(i),:);
end
%% Turnnig Val_filt into Boolen Format
for i = 1:length(EKG_Filt)
    for j = 1:size(dia_filt,2) %1 to 6
        if dia_filt(i,j) >0
            cc = dia_filt(i,j);
            dia_mat(i,cc) =1; %[gg_, 44]
        end
    end
    for j = 1:size(form_filt,2) %1 to 5
        if form_filt(i,j) >0
            cc = form_filt(i,j);
            form_mat(i,cc) =1;%[gg_, 19]
        end
    end
    for j = 1:size(rhy_filt,2) %1 to 3
        if rhy_filt(i,j) >0
            cc = rhy_filt(i,j);
            rhy_mat(i,cc) =1;%[gg_, 13]
        end
    end
end
%% Saves Variables in terms of variables
%save('EKG_dia_form_rhy_Boolean.mat')
%% Loads Variables
load('EKG_dia_form_rhy_Boolean.mat')