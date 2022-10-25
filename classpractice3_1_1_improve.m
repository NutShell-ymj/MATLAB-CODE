function classpractice3_1_1_improve(~)
%Assume a 7-cell network
%In this function I adjust the rho matrix accroding to the distance to get
%a more accurate result.
clear



disp('----------------------------------------------------------------------------')
disp('------------------------This is Class Practice 3.1.1------------------------')
disp('---------Accurate Capacity Simulations for Frequency Reuse algorithms----------------')
disp('----------------------By Mingjun Ying at July 31th, 2021--------------------')
disp('(0) - IFR')
disp('(1) - FFR')
disp('(2) - SWF')
disp('(3) - txITL')
disp('-----------------------------------------------------------------------------')
fprintf('\n')

which_method=input('Choose method 0,1,2, or 3:');
fprintf('\n')
switch which_method
    case 0 %IFR
        reuse_factor=input('Frequency reuse factor (1 or 3): ');
        Nc=input('Number of frequency channels: ');
        snr_dB=input('SNR in dB:');
        Um=input('Average number of users in each cell: ');
        Number_realizations=input('Number of realizations: ');
        
        snr=10^(snr_dB/10);
        P=1;
        sigma=sqrt(P/snr);%snr=P/sigma^2;
        fprintf('\n')
        t=0.9000;%rho is based on the distance
        e=0.5774;
        r=0.5000;
        if reuse_factor==1 %IFR1
            disp('----------The Capacity Simulations of IFR1----------');
            for c=1:7
                f(c,1:Nc)=1:Nc;
            end
            %1  2  3  4  5  6  7
            rho=[1  t  t  t  t  t  t;...%1
                t  1  t  e  r  e  t;...%2
                t  t  1  t  e  r  e;...%3
                t  e  t  1  t  e  r;...%4
                t  r  e  t  1  t  e;...%5
                t  e  r  e  t  1  t;...%6
                t  t  e  r  e  t  1];  %7
            
        elseif reuse_factor==3 % IFR3
            disp('----------The Capacity Simulations of IFR3----------');
            Nc1=round(Nc/reuse_factor);
            Nc2=Nc1;
            Nc3=Nc-Nc1-Nc2;
            f(1,1:min(Nc1,Nc3))=1:min(Nc1,Nc3);
            f(2,1:Nc2)=min(Nc1,Nc3)+1:min(Nc1,Nc3)+Nc2;
            f(3,1:max(Nc3,Nc1))=min(Nc1,Nc3)+Nc2+1:Nc;
            f(4,:)=f(2,:);
            f(5,:)=f(3,:);
            f(6,:)=f(2,:);
            f(7,:)=f(3,:);
            %1  2  3  4  5  6  7
            rho=[1  0  0  0  0  0  0;...%1
                0  1  0  e  0  e  0;...%2
                0  0  1  0  e  0  e;...%3
                0  e  0  1  0  e  0;...%4
                0  0  e  0  1  0  e;...%5
                0  e  0  e  0  1  0;...%6
                0  0  e  0  e  0  1];  %7
            
        end
        for n=1:Number_realizations
            % Setting the number of active users for all the cells
            fprintf('\n')
            disp('--------------------------------------------------')
            for c=1:7
                % the number of user in each cell
                U(c)=poissrnd(Um);
                Nchannel(c)=length(find(f(c,:)>0));
                if U(c)>Nchannel(c)
                    fprintf('Cell %d has too many users (%d) but can only serve %d users\n',c,U(c),Nchannel(c));
                end
            end
            disp('--------------------------------------------------')
            fprintf('\n')
            
            %Generate the channels between the BSs and users
            for c=1:7
                for c_=1:7
                    for u=1:min(U(c_),Nchannel(c_))
                        h(c,c_,u)=(randn+1i*randn)/sqrt(2);%from cell c to user u of cell c_
                    end
                end
            end
            
            % Computing the capacity for each user
            for c=1:7
                for u=1:min(U(c),Nchannel(c))
                    I(c,u)=0;
                    % Interference calculation
                    for c_=1:7
                        % Only consider those cell that share the same frequencies
                        if rho(c,c_)~=0 && c~=c_
                            if U(c_)>=u && Nchannel(c_)>=u
                                I(c,u)=I(c,u)+rho(c,c_)*P*abs(h(c_,c,u))^2;
                            end
                        end
                    end
                    sinr(c,u)=rho(c,c)*P*abs(h(c,c,u))^2/(I(c,u)+sigma^2);
                    capacity(c,u)=log2(1+sinr(c,u));
                    fprintf('(Cell,User) = (%d,%d)  capacity = %g\n',c,u,capacity(c,u));
                end
                cap_cell(c)=sum(capacity(c,:));
            end
            network_cap(n)=sum(cap_cell);
            fprintf('\n')
            fprintf('Simulation No.%d Network Capacity = %g\n', n, network_cap(n))
        end
        average_network_cap=mean(network_cap);
        fprintf('\n')
        switch reuse_factor
            case 1
                fprintf('Average Network Capacity for IFR1 is %g\n',average_network_cap);
            case 3
                fprintf('Average Network Capacity for IFR3 is %g\n',average_network_cap);
        end
    case 1%FFR
    case 2%SWF
end

end


