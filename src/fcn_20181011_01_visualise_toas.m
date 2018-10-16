function[] = fcn_20181011_01_visualise_toas(ir,in_params)

params.figh = [];
params.offset=210;
params.nSamples = 100;
params.baseline_r = 251;
params.chair_rot_deg = 0;
params.label = '';
params.chanlist = [1,4;2,5];
params.channame = {'front left','front right';'back left','back right'};

params = override_valid_fields(params,in_params);


doa_az_deg = [0:15] .* (360/16);
[nRow,nCol] = size(params.chanlist);

if isempty(params.figh)
    figh = figure;
else
    figh = params.figh;
end
figure(figh)
set(figh,'name',params.label)
for irow = 1:nRow
    for icol = 1:nCol
        ichan = params.chanlist(irow,icol);
        axh = subplot(nRow,nCol,icol+(irow-1)*nCol);
        axh.ColorOrderIndex = 1;
        title(axh,params.channame{irow,icol});
        axh.Title.Units='normalized';
        axh.Title.Position = [0 1 1].*axh.Title.Position;
        axh.Title.HorizontalAlignment = 'left';
        horiz_hrir = permute(ir(:,ichan,1:16),[1 3 2]);
        
        for idoa = 1:16
            sigvec = envelope(horiz_hrir(:,idoa));
            sigvec=(0.2*params.nSamples/0.08).* sigvec(params.offset+(0:params.nSamples-1));
            A=[(0:params.nSamples-1);sigvec.';-sigvec.'];
            angle=doa_az_deg(idoa)-params.chair_rot_deg;
            rotA1 = [cosd(angle),-sind(angle);...
                sind(angle),cosd(angle)] * A([1 2],:);
            rotA2 = [cosd(angle),-sind(angle);...
                sind(angle),cosd(angle)] * A([1 3],:);
            phtmp=plot(rotA1(1,:),rotA1(2,:));
            hold all;
            plot(rotA2(1,:),rotA2(2,:),'color',phtmp.Color);
        end
        set(axh,'DataAspectRatio',[1 1 1])
        circ_az_deg = [0:2:360];
        r=params.baseline_r-params.offset;
        plot(r*cosd(circ_az_deg),r*sind(circ_az_deg),'k','linewidth',2)
        axis((params.nSamples) .* [-1 1 -1 1])
        %xlabel('x')
        %ylabel('y')
        set(axh,'xtick',[],'ytick',[]);
        text(params.nSamples*1.1,0,'front','horizontalalignment','center');
        text(-params.nSamples*1.1,0,'back','horizontalalignment','center');
        text(0,params.nSamples*1.1,'left','horizontalalignment','right');
        text(0,-params.nSamples*1.1,'right','horizontalalignment','left');
        view(-90,90)
    end
end