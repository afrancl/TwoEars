sim = simulator.SimulatorConvexRoom();
set(sim, ...
    'HRIRDataset', simulator.DirectionalIR( ...
        'impulse_responses/qu_kemar_anechoic/QU_KEMAR_anechoic_3m.sofa'), ...
    'Sources', {simulator.source.Point()}, ...
    'Sinks',   simulator.AudioSink(2) ...
    );
set(sim.Sources{1}, ...
    'Name', 'Cello', ...
    'Position', [1; 2; 0], ...
    'AudioBuffer', simulator.buffer.FIFO(1) ...
    );
set(sim.Sources{1}.AudioBuffer, ...
    'File', 'stimuli/anechoic/instruments/anechoic_cello.wav' ...
    );

%% initialization
% note that all the parameters including objects' positions have to be
% defined BEFORE initialization in order to init properly  
sim.set('Init',true);

%%
sim.Sources{1}.setDynamic( ...
    'Position', 'Velocity', 0.25); % move source with 0.25 m/s
set(sim.Sources{1}, ...
    'Position', [1; -2; 0] ... %final position
    );  
  
while ~sim.isFinished()
    sim.set('Refresh',true);  % refresh all objects
    sim.set('Process',true);
end

data = sim.Sinks.getData();
sim.Sinks.saveFile('out_moving_source.wav',sim.SampleRate);
sim.set('ShutDown',true);
