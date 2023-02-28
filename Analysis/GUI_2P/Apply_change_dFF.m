function Apply_change_dFF(app)
%
% Re calculate/ apply change to dFF.
%

%% Reset
dFF = app.imgobj.F;
F0 = mean(dFF(app.imgobj.f0,:));

%%

% Step1 detrend
if app.Detrend.Value
    dFF = detrend(dFF);
end

% Step2 Low-cut filter
if app.Lowcutfilter.Value
    dFF = lowcut(dFF);
end

% Step3 Offset
if app.Offset.Value
    dFF = dFF - F0;
end

% Step4 (re) calculate dFF

dFF = (dFF - F0)./ repmat(F0, size(dFF,1),1);

% Step5 Zscored
if app.Zscore.Value
    sd_dFF = sd(dFF(app.imgobj.f0, :));
    sd_dFF = repmapt(sd_dFF, size(F,1),1);
    dFF = dFF/sd_dFF;
end

%% Return
app.imgobj.dFF = dFF;

end