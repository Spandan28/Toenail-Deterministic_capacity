%% The data that follow below are the ones that will be used in the main code
%% This data containes detail about connection and the spec of the nails, wood and clip
%% The function, deterministic_capacity will be called here
clear all

% Input Data starts here

%% Input for no of connections
no_of_conn = 4;

%% Data for nails - number, diameter, properties of wood 
% Number of nails in the connection at one end
N_nail = 5;

% Wood type

% W = 'SYP'; % can be DFI , SPF, SYP


% Diameter of the nails used in penny units for the clip connection
Dia_nail = 8;
conn = [1; 2; 4; ];

wood_type = ['DFI';'SYP' ;'SPF' ;];

% Diameter of the Toenail connection
Toenail = [1; 2; 3; 4];
Dia_Toenail = 8;

% W='SPF';
% no_of_conn = 4;
% 
%  [det_capacity] =  deterministic_capacity(Dia_nail,N_nail,W,no_of_conn);
for i =1:length(wood_type)
    for j = 1:length(conn)
        W = wood_type(i,1:3);
        no_of_conn = conn(j);
        N_Toenail  = 0;
        
       %% This step calls the function and gives the deterministic capacity
         [det_capacity, det_capacity_Toenail]=  deterministic_capacity(Dia_nail,N_nail,W,no_of_conn,Dia_Toenail,N_Toenail);
        summary_clip (i,j) = det_capacity;
        
    end
end
for i =1:length(wood_type)
    for j = 1:length(Toenail)
        
        W = wood_type(i,1:3);
        %% This step calls the function and gives the deterministic capacity
        N_Toenail = Toenail(j);
        [det_capacity, det_capacity_Toenail]=  deterministic_capacity(Dia_nail,N_nail,W,no_of_conn,Dia_Toenail,N_Toenail);
        summary_Toenail (i,j) = det_capacity_Toenail;
        
    end
end

plot([1 2 4],summary_clip(1,:),'-dk',[1 2 4], summary_clip(2,:),'-*k', [1 2 4], summary_clip(3,:),'-ok','Markersize',7); 
ax= gca;  set(gca,'XLim',[1 4]) ; set(gca,'XTick',1:1:4); 
set(gca,'XTickLabel',['1';'2';'3'; '4']);
xlabel('Number of connections');
ylabel('Deterministic capacity (lbs)');
legend('DFI','SYP','SPF');