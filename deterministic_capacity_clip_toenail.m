
function  [det_capacity, det_capacity_Toenail]=  deterministic_capacity(Dia_nail,N_nail,W,no_of_conn,Dia_Toenail,N_Toenail)

    
    % Estimate maximum capacity of the hurricane strap
    % Check the maximum possible force reached in each failure category and select the lowest value
    % " Testing revealed that primary failure modes for toenailed ...
    % connections included splitting and tear-out of wood, nail bending,
    % and nail withdrawal,...
    % whereas primary failure modes for joints with hurricane clips
    % included buckling of the clip" Chowdhury et al. (2007)
    
    %% Type of wood
    if W == 'SPF' % Spruce Pine Fir
        wood = 1;
        if no_of_conn == 1
            Rupture_st = 40;
        elseif no_of_conn ==2
            Rupture_st = 40;
        else
            Rupture_st = 40;
        end
    elseif W == 'SYP' % Southern Yellow Pine
        wood =2;
        if no_of_conn == 1
            Rupture_st = 50;
        elseif no_of_conn ==2
            Rupture_st = 50;
        else
            Rupture_st = 50;
        end
    elseif W =='DFI'
        wood =3; % Douglas Fir 
        if no_of_conn == 1
            Rupture_st = 65;
        elseif no_of_conn ==2
            Rupture_st = 65;
        else
            Rupture_st = 65;
        end
    end
    

    %% Failure by Pulling out of nails
    % Follow NDS for wood consturction formula
    % Given below is Sp gravity of each wood type
    
    Wood_data = [ 1 0.42   %SP
             2 0.46   % SPF
             3 0.50]; % DF
    
    Wood_d = Wood_data(:,1);
    loc = find(Wood_d == wood);
    G = Wood_data(loc,2);
    
    Nail_data = [ 6 0.1
                  8 0.143
                 10 0.15
                 16 0.165];   
%     % This data uses info from Ahmed et al.(2011)
%     % This article states that total strength is not directly proportional to number of clips used
%     % In other words if we use three clips, we do not get thrice the capacity
%     % of one clip
%     P_eff_data = [ 1 1
%                2 0.9
%                3 0.88   
%                4  0.85
%                5  0.82
%                6   0.8];

    %% Failure by pulling out of Toenails.
    
    
    %% Data for hurricane strip - Thickness, width, stresses, buckling length etc.       
    % thicknes
    Thick = 0.05;

    % Width
    Width = 0.98;
    
    Nominal_width = 1.1;
    
    % Yield stress ESR-2613 February 2008 steel yield stress
    f_y = 40000;

    % Tear stress 
    f_tear = 58015;

    % Elastic modulus
    El = 29*10^6;

    % Buckling length approximated from dimensions of the H2.5A Ref:
    % http://www.strongtie.com/products/connectors/h.asp
    x1 = 1.56;
    %% Failure by Nail yield
    dia = Nail_data(:,1);
    loca = find(dia==Dia_nail);
    actual_dia = Nail_data(loca,2);
    
%     f_y_nail = f_y;
%     N_nail_yield = 1;
%     A_nail = actual_dia^2*pi/4;
     L_nail = 1.5;
%     Nail_yield = no_of_conn*N_nail_yield*f_y_nail*A_nail;
     L_Toenail = 3.5;
     loca = find(dia==Dia_Toenail);
     actual_dia_Toenail = Nail_data(loca,2);
    %% Failure by Nail pullout
    % Lookup for pull out strength of individual nail using its dia
    
    
    if W == 'DFI'
        Pullout_nail1 = 1800*G^(5/2)*actual_dia*(1.0/cosd(60)); % as per test result data for one connection, increase the factor by 30% for Douglas Fir
    else
        Pullout_nail1 = 1800*G^(5/2)*actual_dia*(1.0/cosd(60)); % as per test result data for one connection
    end
    
    Total__pullout = Pullout_nail1*no_of_conn*N_nail*L_nail;
    
    
%     % Look up for correction factor based on number of nails (Ahmed et
%     % al.,2010)
%         if N_nail >1
%             Corr_factor  = P_eff_data(N_nail,2);
%         else
%             Corr_factor = 1;
%         end

    
    %% Failure by yielding of nail
    
    %% Failure by strip deformation
    
    
    %% Failure of strip in Yield -  Strip deformation
    % Area of strip at mid height
    % assumption is that three components of stress - normal stress,
    % bending-x, bending-z causes yield stress at the section.
    % Width is the critical section width
    % Normal stress
    Area_strip_yield = Thick*Width;
    F_Normal = f_y/ (1/Area_strip_yield);
    
    % Bendingz
    % Moment of inertia
    Iz = Thick*Width^3/12;
    % eccentricity
    
    e_x = 1.5*Nominal_width;
    F_bend_z = f_y/((e_x*Nominal_width/2)/Iz);
    
    % Bendingz
    % Moment of inertia
    Ix = Thick*Width^3/12;
    % eccentricity
    
    e_z = 1.0*Nominal_width;
    F_bend_z = f_y/((e_z*Nominal_width/2)/Ix);
    
    F = f_y/((0.7*(0.7)*Width)/(Width^3*Thick/12)*1 + 1/(Thick*Width)+ ((Width*0.5)*Thick/2)/(Width*Thick^3/12)  ); % from the after failure picture the two parts of the clip seems to have spearated (lever arm) for (0.5+0.7)*1.6
    if no_of_conn == 1
    
    Strip_yield = Area_strip_yield*0.6*f_y;
    
    Strip_st = Strip_yield;
    else
    %% Failure of strip in Tearing
    % Area of strip at mid height
    
    Area_strip_tear = Thick*Width;
     
    Strip_tear = Area_strip_tear*f_tear;
    Strip_st = Strip_tear;
    end
    
    %% Failure of strip in Buckling
    %% this was identified as an issue in lateral loaded experiments
    %% uplift loading methods do not present this as an issue
    % Area of strip x buckling stress
    
    Area_strip_buck = Thick*Width;
    I = Width*Thick^3/12;
    K = 1;
    f_buckling = pi^2*El*I/(Area_strip_buck*(K*x1)^2);
   
    Strip_buckling = no_of_conn*Area_strip_buck*f_buckling;
    
    %% Failure of wood by rupture
    % Decreased rupture strength
    
    Wood_rupture = 12*2.5*Rupture_st;
    
    %% Maximum capacity
    
    det_capacity = min ([Total__pullout, Strip_st,Strip_buckling,Wood_rupture]);
%     condition =  disp(['var = ' num2str(Total__pullout)]);
    det_capacity_Toenail =  1800*G^(5/2)*actual_dia_Toenail*N_Toenail*L_Toenail*cosd(30);
end
