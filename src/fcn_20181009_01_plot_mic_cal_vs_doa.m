function[] = fcn_20181009_01_plot_mic_cal_vs_doa(cal_energy_left,cal_energy_right,in_params)

[nCal,nMicPerHa,nDoa,nWin] = size(cal_energy_left);
if nMicPerHa~=3 || nDoa~=29
    error('unexpected matrix dimensions')
end

params.per_doa_gain = ones(nDoa,1);
params.save_fig_path_stub = [];
params.ylims =  4*[-1 1];

if nargin > 2 && ~isempty(in_params)
    params = override_valid_fields(params,in_params);
end

xlims = [0 nDoa+1];
if nDoa==29
    doa_split = cumsum([16 6 6]) + 0.5;
else
    doa_split = [];
end
for iwin = 1:nWin
    figure;
    for iside = 1:2
        switch iside
            case 1
                sidelab = 'left';
                data = cal_energy_left(:,:,:,iwin);
                xlab = '';
            case 2
                sidelab = 'right';
                data = cal_energy_right(:,:,:,iwin);
                xlab = 'doa index';
        end
        for imic = 1:nMicPerHa
            if imic==1
                ylab = {sidelab;'Power wrt left mic 1'};
            else
                ylab = '';
            end
            subplot(2,nMicPerHa,imic+(iside-1)*nMicPerHa);
            mean_data = reshape(mean(data(:,imic,:),1),nDoa,1);
            mean_data = mean_data .* params.per_doa_gain(:).^2;
            if iside==1 && imic==1
                ref_lev = mean_data(1);
            end
            plot(10*log10(mean_data./ref_lev),'x');
            hold all;
            plot(repmat(doa_split,2,1),repmat(params.ylims(:),1,length(doa_split)),':k')
            ylabel(ylab);
            xlabel(xlab);
        end
    end
    set(get(gcf,'children'),'ylim',params.ylims,'xlim',xlims)
    
    if isempty(params.save_fig_path_stub)
        set(gcf,'windowstyle','docked','name',sprintf('win %d',iwin));
    else
        setFigureSize(gcf,[24 18],'centimeters')
        ahm_print_to_pdf(gcf,sprintf('%s_win_%d',...
            params.save_fig_path_stub,iwin));
    end
end