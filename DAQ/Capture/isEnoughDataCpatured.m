function results = isEnoughDataCpatured(app)
% Check whether captured-data duration exceeds specificed capture duration

results = (app.TimestampsFIFOBuffer(end) - app.CaptureStartMoment) > app.c.TimeSpan;

end