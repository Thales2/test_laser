function [wave] = scopeCapture(scope,Ndata,delay)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here



    app.DS1000z = scope;
    
    fprintf(app.DS1000z, ':TRIGger:SWEep NORMal');
    fprintf(app.DS1000z, ':RUN');
    
    pause(delay)
    
    data = [];
    fprintf(app.DS1000z, ':STOP');
    
    fprintf(app.DS1000z, ':WAV:SOUR CHAN1');
    fprintf(app.DS1000z, ':WAV:MODE RAW');
    fprintf(app.DS1000z, ':WAV:FORM BYTE');
    
    indexStart = 1;
    indexStop  = 125000;
    step = 125000;
    for i = 1:64
        fprintf(app.DS1000z, [':WAV:STAR ' num2str(indexStart)]);
        fprintf(app.DS1000z, [':WAV:STOP ' num2str(indexStop)]);
        fprintf(app.DS1000z, ':WAV:DATA?' );
        
        [temp,len]= fread(app.DS1000z,step);
        data = [data; temp(12:end)];
        
        indexStart = indexStart + step;
        indexStop  = indexStop  + step;
    end
    
    
    
%     fprintf(app.DS1000z, ':WAV:STAR 1');
%     fprintf(app.DS1000z, ':WAV:STOP 125000');
%     fprintf(app.DS1000z, ':WAV:DATA?' );
%     
%     [temp,len]= fread(app.DS1000z,125000);
%     data = [data; temp(12:end)];
%     
%     fprintf(app.DS1000z, ':WAV:STAR 125001');
%     fprintf(app.DS1000z, ':WAV:STOP 250000');    
%     fprintf(app.DS1000z, ':WAV:DATA?' );
%     
%     [temp,len]= fread(app.DS1000z,125000);
%     data = [data; temp(12:end)];    
%     
%     fprintf(app.DS1000z, ':WAV:STAR 250001');
%     fprintf(app.DS1000z, ':WAV:STOP 375000');    
%     fprintf(app.DS1000z, ':WAV:DATA?' );
%     
%     [temp,len]= fread(app.DS1000z,125000);
%     data = [data; temp(12:end)];        
% 
%     fprintf(app.DS1000z, ':WAV:STAR 375001');
%     fprintf(app.DS1000z, ':WAV:STOP 500000');    
%     fprintf(app.DS1000z, ':WAV:DATA?' );    
%     
%     [temp,len]= fread(app.DS1000z,125000);
%     data = [data; temp(12:end)];        
% 
%     fprintf(app.DS1000z, ':WAV:STAR 500001');
%     fprintf(app.DS1000z, ':WAV:STOP 625000');
%     fprintf(app.DS1000z, ':WAV:DATA?' );
%     
%     [temp,len]= fread(app.DS1000z,125000);
%     data = [data; temp(12:end)];
%     
%     fprintf(app.DS1000z, ':WAV:STAR 625001');
%     fprintf(app.DS1000z, ':WAV:STOP 750000');    
%     fprintf(app.DS1000z, ':WAV:DATA?' );
%     
%     [temp,len]= fread(app.DS1000z,125000);
%     data = [data; temp(12:end)];    
%     
%     fprintf(app.DS1000z, ':WAV:STAR 750001');
%     fprintf(app.DS1000z, ':WAV:STOP 875000');    
%     fprintf(app.DS1000z, ':WAV:DATA?' );
%     
%     [temp,len]= fread(app.DS1000z,125000);
%     data = [data; temp(12:end)];        
% 
%     fprintf(app.DS1000z, ':WAV:STAR 875001');
%     fprintf(app.DS1000z, ':WAV:STOP 1000000');    
%     fprintf(app.DS1000z, ':WAV:DATA?' );    
%     
%     [temp,len]= fread(app.DS1000z,125000);
%     data = [data; temp(12:end)];        
% 
%     
%     
%     fprintf(app.DS1000z, ':WAV:STAR 1000001');
%     fprintf(app.DS1000z, ':WAV:STOP 1125000');
%     fprintf(app.DS1000z, ':WAV:DATA?' );
%     
%     [temp,len]= fread(app.DS1000z,125000);
%     data = [data; temp(12:end)];
%     
%     fprintf(app.DS1000z, ':WAV:STAR 1125001');
%     fprintf(app.DS1000z, ':WAV:STOP 1250000');    
%     fprintf(app.DS1000z, ':WAV:DATA?' );
%     
%     [temp,len]= fread(app.DS1000z,125000);
%     data = [data; temp(12:end)];    
%     
%     fprintf(app.DS1000z, ':WAV:STAR 1250001');
%     fprintf(app.DS1000z, ':WAV:STOP 1375000');    
%     fprintf(app.DS1000z, ':WAV:DATA?' );
%     
%     [temp,len]= fread(app.DS1000z,125000);
%     data = [data; temp(12:end)];        
% 
%     fprintf(app.DS1000z, ':WAV:STAR 1375001');
%     fprintf(app.DS1000z, ':WAV:STOP 1500000');    
%     fprintf(app.DS1000z, ':WAV:DATA?' );    
%     
%     [temp,len]= fread(app.DS1000z,125000);
%     data = [data; temp(12:end)];        
% 
%     fprintf(app.DS1000z, ':WAV:STAR 1500001');
%     fprintf(app.DS1000z, ':WAV:STOP 1625000');
%     fprintf(app.DS1000z, ':WAV:DATA?' );
%     
%     [temp,len]= fread(app.DS1000z,125000);
%     data = [data; temp(12:end)];
%     
%     fprintf(app.DS1000z, ':WAV:STAR 1625001');
%     fprintf(app.DS1000z, ':WAV:STOP 1750000');    
%     fprintf(app.DS1000z, ':WAV:DATA?' );
%     
%     [temp,len]= fread(app.DS1000z,125000);
%     data = [data; temp(12:end)];    
%     
%     fprintf(app.DS1000z, ':WAV:STAR 1750001');
%     fprintf(app.DS1000z, ':WAV:STOP 1875000');    
%     fprintf(app.DS1000z, ':WAV:DATA?' );
%     
%     [temp,len]= fread(app.DS1000z,125000);
%     data = [data; temp(12:end)];        
% 
%     fprintf(app.DS1000z, ':WAV:STAR 1875001');
%     fprintf(app.DS1000z, ':WAV:STOP 2000000');    
%     fprintf(app.DS1000z, ':WAV:DATA?' );    
%     
%     [temp,len]= fread(app.DS1000z,125000);
%     data = [data; temp(12:end)];            
    
    
    
    % Request the data
    
    
    wave = data; 
    wave = wave';     
    
    

    

end


