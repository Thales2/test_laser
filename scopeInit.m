function scope = scopeInit(Ndata)


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

    % Set channel
    fprintf(app.DS1000z, ':WAV:SOURce CHAN1' );
    % Normal Mode
    fprintf(app.DS1000z, ':WAV:MODE NORM' );
    % Samplerate T?

    fprintf(app.DS1000z, ':ACQuire:MDEPth 24000000' );

    fprintf(app.DS1000z, ':ACQuire:SRATe?');
    
    fprintf(app.DS1000z, ':TRIGger:SWEep NORMal');
    
    fprintf(app.DS1000z, ':RUN');
    
    scope = app.DS1000z;

end