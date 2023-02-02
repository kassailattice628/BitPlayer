function results = isEnoughDataCpatured(TimeStamps, StartMoment, TimeSpan)
% Check whether captured-data duration exceeds specificed capture duration
%results = ...
% (app.TimestampsFIFOBuffer(end) - app.CaptureStartMoment) > app.c.TimeSpan;

results = (TimeStamps - StartMoment) > TimeSpan;

end