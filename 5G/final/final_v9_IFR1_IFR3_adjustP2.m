function final_v9_IFR1_IFR3_adjustP2(~)
% show
clear
clc
disp('----------------------------------------------------------------------------')
disp('--------------------------This is the Final Project-------------------------')
disp('-------------This code is made for IFR1+IFR3 for M-cell network-------------')
disp('--------------------By Mingjun Ying at August 22th, 2021--------------------')
disp('-------------------------------Class ST 3705--------------------------------')
disp('----------------------------------------------------------------------------')


% % input
% M=input('What is the number of cells: ');
% row=input('Please input the row number of the cluster: ');
% col=input('Please input the column number of the cluster: ');
% Nsim=input('Number of random simulations: ');
%
% % N0=input('Number of frequency channels at the centers: ');
% Nc=input('Number of frequency channels in the center: ');
% Ne=input('Number of frequency channels in the edge: ');
%
% snr_dB=input('The range of average SNR in dB: ');
% snr=10.^(snr_dB/10);
%
% Um=input('Average number of users per cell: ');
% input
% M=input('What is the number of cells: ');
% row=input('Please input the row number of the cluster: ');
% col=input('Please input the column number of the cluster: ');
% Nsim=input('Number of random simulations: ');
M=24;
row=4;
col=6;
Nsim=500;
% N0=input('Number of frequency channels at the centers: ');
% Nc=input('Number of frequency channels in the center: ');
% Ne=input('Number of frequency channels in the edge: ');
Nc=6;
Ne=6;
% snr_dB=input('The range of average SNR in dB: ');
snr_dB=0:2:20;
snr=10.^(snr_dB/10);

% Um=input('Average number of users per cell: ');
Um=9;


% process
P1=1;%center
% P2=0.5;%egde
P2=0.45;


% form rho matrix
rho1=rho_gen(M,row,col,1);
rho2=rho_gen(M,row,col,3);

% It allow we ignore the path loss exponent for introducing the rho matrix

% Genarate the average capacity%

Ne1=round(Ne/3);
Ne2=Ne1;
Ne3=Ne-Ne1-Ne2;

%----------------------1----------------------
f(1,1:Ne1)=1:Ne1;
for Row=1:row
    for Col=1:col
       
            if mod(Row,2)==0
                if Col<=col&&mod(Col-2,3)==0
                    f((Row-1)*col+Col,:)=f(1,:);
                end
            elseif mod(Row,2)==1
                if Col<=col&&mod(Col-1,3)==0
                    f((Row-1)*col+Col,:)=f(1,:);
                end
            end

    end
end

%----------------------2----------------------
f(2,1:Ne2)=Ne1+1:Ne1+Ne2;
for Row=1:row
    for Col=1:col
        if mod(Row,2)==0
            if Col<=col&&mod(Col-3,3)==0
                f((Row-1)*col+Col,:)=f(2,:);
            end
        elseif mod(Row,2)==1
            if Col<=col&&mod(Col-2,3)==0
                f((Row-1)*col+Col,:)=f(2,:);
            end
        end
    end
end

%----------------------3----------------------
f(3,1:Ne3)=Ne1+Ne2+1:Ne;
for Row=1:row
    for Col=1:col
        if mod(Row,2)==0
            if Col<=col&&mod(Col-4,3)==0
                f((Row-1)*col+Col,:)=f(3,:);
            end
        elseif mod(Row,2)==1
            if Col<=col&&mod(Col-3,3)==0
                f((Row-1)*col+Col,:)=f(3,:);
            end
        end
    end
end


cap_cell=zeros(1,M);
Nchannel=zeros(1,M);
sinr_center=zeros(M,Nc);
capacity_center=zeros(M,Nc);
sinr_edge=zeros(M,Ne);
capacity_edge=zeros(M,Ne);
% user number

    for m=1:length(snr_dB)
        for n=1:Nsim%for each sim
            
            for c=1:M
                U(c)=poissrnd(Um);
                
                U1(c)=round(rand*U(c));% number of users at cell centers
                
                U2(c)=U(c)-U1(c);% number of users at cell edges
                Nchannel(c)=length(find(f(c,:)>0));% frequency in a cell edge
                
                %             if U1(c)> Nc
                %                 fprintf('In the cell %d center has too many users (%d) but can only serve %g users\n',c,U2(c),Nc);
                %             end
                %
                %             if U2(c)> Nchannel(c)
                %                 fprintf('In the cell %d edge has too many users (%d) but can only serve %g users\n',c,U1(c),Nchannel(c));
                %             end
            end
            % Generate the channel between the BSs and users for cell center
            
            for c=1:M
                for c_=1:M
                    
                    if U1(c_)>0
                        for u=1:min(Nc,U1(c_))
                            h1(c,c_,u)=rho1(c,c_)*(randn+1i*randn)/sqrt(2);
                        end
                    end
                    
                    
                    % Generate the channel between the BSs and users for cell edge
                    if U2(c_)>0
                        
                        for u=1:min(Nchannel(c_),U2(c_))
                            h2(c,c_,u)=rho2(c,c_)*(randn+1i*randn)/sqrt(2);
                        end
                    end
                    
                end
            end
            %             disp(' h2(1,1,1)')
            %           h2(1,1,1)
            %           disp(' h2(2,2,3)')
            %           h2(2,2,3)
            % Comput the capacity
            for c=1:M
                %                 %for center users
                sigma1=P1./sqrt(snr);
                if U1(c)>0
                    for u=1:min(Nc,U1(c))
                        I0(c,u)=0;
                        for c_=1:M
                            if rho1(c,c_)~=0 && c~=c_
                                if U1(c_)>=u && Nc>=u
                                    I0(c,u)=I0(c,u)+rho1(c,c_)*P1*abs(h1(c_,c,u))^2;
                                end
                            end
                        end
                        sinr_center(c,u)=P1*abs(h1(c,c,u))^2/(I0(c,u)+sigma1(m)^2);
                        capacity_center(c,u)=log2(1+sinr_center(c,u));
                        %fprintf('CELL CENTER:(Cell,User)=(%d,%d), capacity = %g\n',c,u,capacity_center(c,u));
                    end
                end
                
                % for edge users
                sigma2=P2./sqrt(snr);
                
                if U2(c)>0
                    for u=1:min(Nchannel(c),U2(c))
                        In(c,u)=0;%I define
                        for c_=1:M
                            if rho2(c,c_)~=0 && c~=c_
                                if U2(c_)>=u && Nchannel(c_)>=u
                                    In(c,u)=In(c,u)+rho2(c,c_)*P2*abs(h2(c_,c,u))^2;
                                end
                            end
                        end
                        
                        
                        %                         abs(h2(c,c,u))
                        sinr_edge(c,u)=P2*abs(h2(c,c,u))^2/(In(c,u)+sigma2(m)^2);
                        capacity_edge(c,u)=log2(1+sinr_edge(c,u));
                        %fprintf('CELL EDGE:(Cell,User)=(%d,%d) gives capacity =%g\n',c,u,capacity_edge(c,u));
                    end
                end
                
                
                %
                %     cap_cell(c)=sum(capacity(c,:));
                %  if min(U(c),Nchannel(c))>=1
                %      cap_cell(c)=sum(capacity(c,1:min(U(c),Nchannel(c))));
                %  else
                %      cap_cell(c)=0;
                %  end
                % cap_net(n)=sum(cap_cell);
                if U1(c)>0 && U2(c)>0
                    cap_cell(c)=sum(capacity_center(c,1:min(U1(c),Nc)))+sum(capacity_edge(c,1:min(U2(c),Nchannel(c))));
                    %cap_cell(c)=sum(capacity_center(c,:))+sum(capacity_edge(c,:));
                    
                elseif U1(c)>0 && ~(U2(c)>0)
                    cap_cell(c)=sum(capacity_center(c,1:min(U1(c),Nc)));
                elseif ~(U1(c)>0) && U2(c)>0
                    cap_cell(c)=sum(capacity_edge(c,1:min(U2(c),Nchannel(c))));
                else
                    cap_cell(c)=0;
                end
            end
            cap_net(m,n)=sum(cap_cell);
        end
        clear cap_cell
        Ave_cap_net(m)=mean(cap_net(m,:));
        
        fprintf('For SNR = %gdB, P2=%g, Average network capacity with IFR1(center)+IFR3(edge) is %g\n',snr_dB(m),P2,Ave_cap_net(m));
    end
    fprintf('----------------------------------------------------------------------------------------\n');
    
    switch P1
        case 0.2
            
            plot(snr_dB,Ave_cap_net, 'r>-','linewidth',1.2);
            hold on

            
        case 0.4
            plot(snr_dB,Ave_cap_net, 'b^-','linewidth',1.2);
            
        case 0.6
            plot(snr_dB,Ave_cap_net, 'ms-','linewidth',1.2);
            
        case 0.8
            plot(snr_dB,Ave_cap_net, 'g*-','linewidth',1.2);
            
        case 1
            plot(snr_dB,Ave_cap_net, 'yx-','linewidth',1.2);
            hold on
            
    end
    

grid on
% legend('P1=0.2','P1=0.4','P1=0.6','P2=0.8','P2=1','Location','SouthEast');
% xlabel('Average SNR in dB');
% ylabel('Average Network Capacity * 10');
% title('IFR1(center)+IFR3(edge) 24-cell network');


end


