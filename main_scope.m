clear all
close all


Ndata = 2^14;
app.DS1000z = [];
% Since instrfind is not finding any device - workaround -
o=oscilloscope();
devStr=o.resources;
deviceNr=devStr{contains(devStr,'USB')};
clear o;


% Create the VISA-USB object if it does not exist
% otherwise use the object that was found.
if isempty(app.DS1000z)
    app.DS1000z = visa('NI',deviceNr);
    %app.DS1000z = visa('NI','USB0::0x1AB1::0x04CE::DS1ZA192712515::0::INSTR');
    %app.DS1000z = visa('NI', 'USB0::0x1AB1::0x04CE::DS1ZA192712385::0::INSTR');
else
    fclose(app.DS1000z);
    app.DS1000z=app.DS1000z(1);
end
app.DS1000z.InputBufferSize = Ndata;


% Connect to instrument object, obj1.
if ~strcmp(app.DS1000z.status,'open')
    % Set the device property. In this demo, the length of the input buffer is set to 2048.
    try
        fopen(app.DS1000z);
    catch
        error('Cannot open connection. Is the oscilloscope connected and switched on?')
    end
end

%
% % RAW Mode
% pause(0.01)
% fprintf(app.DS1000z, ':WAV:MODE RAW' );
% fprintf(app.DS1000z, ':WAV:MODE?' );
% disp(['Mode: ' fscanf(app.DS1000z)])

try
    % Set channel
    fprintf(app.DS1000z, ':WAV:SOURce CHAN1' );
    % Normal Mode
    fprintf(app.DS1000z, ':WAV:MODE NORM' );
    % Samplerate T?
    
    fprintf(app.DS1000z, ':ACQuire:MDEPth 24000000' );
    
    fprintf(app.DS1000z, ':ACQuire:SRATe?');
    SampRate = fscanf(app.DS1000z)
    
    fprintf(app.DS1000z, ':RUN');
    
    pause(1)
    
    fprintf(app.DS1000z, ':STOP');
    
    fprintf(app.DS1000z, ':WAV:SOUR CHAN1');
    fprintf(app.DS1000z, ':WAV:MODE RAW');
    fprintf(app.DS1000z, ':WAV:FORM BYTE');
    fprintf(app.DS1000z, ':WAV:STAR 1');
    fprintf(app.DS1000z, ':WAV:STOP 120000');
    fprintf(app.DS1000z, ':WAV:DATA?' );
    
    
    
    % Request the data
    [data,len]= fread(app.DS1000z,Ndata);
    
    wave = data(12:len-1); 
    wave = wave'; 
    subplot(211); 
    plot(wave); 
    fftSpec = fft(wave',Ndata); 
    fftRms = abs(fftSpec'); 
    fftLg = 20*log(fftRms); 
    subplot(212); 
    plot(fftLg);
    
    fclose(app.DS1000z)
catch e
    fprintf(1,'The identifier was:\n%s',e.identifier);
    fprintf(1,'There was an error! The message was:\n%s',e.message);
    fclose(app.DS1000z)
end





