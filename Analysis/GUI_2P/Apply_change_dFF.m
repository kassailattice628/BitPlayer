function Apply_change_dFF(app)
%
% Re calculate/ apply change to dFF.
%

%% Reset
dFF = app.imgobj.F;
F0 = mean(dFF(app.imgobj.f0,:));
F0mat = repmat(F0, size(dFF, 1), 1);
dFF = (dFF - F0mat)./ F0mat;

%%

% Step1 detrend
if app.Detrend.Value
    dFF = detrend(dFF);
end

% Step2 Low-cut filter
if app.Lowcutfilter.Value
    dFF = lowcut(dFF);
end

% Step3 (re) calculate dFF
%dFF = (dFF - F0mat)./ F0mat;

% Step4 Offset
if app.Offset.Value
    F0 = mean(dFF(app.imgobj.f0,:));
    F0mat = repmat(F0, size(dFF, 1), 1);
    dFF = dFF - F0mat;
end

% Step5 Zscored
if app.Zscore.Value
    sd_dFF = std(dFF(app.imgobj.f0, :));
    sd_dFF = repmat(sd_dFF, size(dFF,1),1);
    dFF = dFF./sd_dFF;
end

%% Return
app.imgobj.dFF = dFF;

end