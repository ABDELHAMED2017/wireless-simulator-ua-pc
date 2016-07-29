function [eNodeBs,UEs]=sys_init_alloc_power_RB(eNodeBs,UEs,pathloss_matrix)
% 
% ���ʳ�ʼ��
%
global netconfig;
N_RB                 = netconfig.nb_RBs;
RB_bandwidth         = netconfig.RB_bandwidth;
noise_density        = netconfig.noise_density;
UE_per_eNodeB        = netconfig.nb_users_per_sector;
min_power_per_RB     = netconfig.min_power_per_RB;   
max_power_per_sector = netconfig.max_power_per_sector;
number_of_bts   = length(eNodeBs);
%% ˥������ά��ת��
%
g = dim_transform(pathloss_matrix); % ���ں������ķ������У������������ʱ��Ҫͳһ����
%
%% ���վ����RB
% ����վ��RB������
for b_ = 1:number_of_bts
    g_temp = g(1 + UE_per_eNodeB*(b_-1):UE_per_eNodeB*b_,:,b_); % ����ĳһ�ض���վ��ȡ�����Ӧ��˥��ֵ(��վ�û���RB)
    while nnz(g_temp) ~= 0
        for u_ = 1:UE_per_eNodeB
            [~,n_ix] = max(g_temp(u_,:));  % ȡ���û���Ӧ˥��ֵ����RB�����
            UEs(u_+UE_per_eNodeB*(b_-1)) = alloc_RB(UEs(u_+UE_per_eNodeB*(b_-1)),n_ix); % Allocate RB to UE
            eNodeBs(b_).RB(n_ix) = u_+UE_per_eNodeB*(b_-1); % ��Դ���û��������
            g_temp(:,n_ix) = 0; % ����˥��ֵ�Ӵ�С��˳��������RB�����ѷ����RB��Ӧ��˥��ֵ����
        end
    end
end

%% ��ʼ������
% ��ʼ�����ʷ���(������N_RB��RB��ƽ�������ܹ��ʣ���ÿ��RB�ϵĹ�����ͬ)
for n_=1:N_RB
    for b_=1:number_of_bts
        if eNodeBs(b_).RB(n_)~=0
%             average_power = max_power_per_sector/N_RB;
%             eNodeBs(b_).P(n_) = average_power;  % v6�У���ʼ��������Ϊ��С����
% 
            eNodeBs(b_).P(n_) = min_power_per_RB;  % v6�У���ʼ��������Ϊ��С����
        else
            eNodeBs(b_).P(n_)=0;
        end
    end
end
%
%% ��ʼ������
for b_=1:number_of_bts
    eNodeBs(b_).I_noise = noise_density * RB_bandwidth;
end
%
end