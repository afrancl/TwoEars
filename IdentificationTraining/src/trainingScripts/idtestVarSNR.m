function idtestVarSNR( classname, testFlist, modelPath, SNR )

testpipe = TwoEarsIdTrainPipe();
m = load( fullfile( modelPath, [classname '.model.mat'] ) );
testpipe.featureCreator = m.featureCreator;
testpipe.modelCreator = ...
    modelTrainers.LoadModelNoopTrainer( ...
        @(cn)(fullfile( modelPath, [cn '.model.mat'] )), ...
        'performanceMeasure', @performanceMeasures.BAC2, ...
        'modelParams', struct('lambda', []));
testpipe.modelCreator.verbose( 'on' );

testpipe.testset = testFlist;

sc = dataProcs.SceneConfiguration();
sc.angleSignal = dataProcs.ValGen('manual', [0]);
sc.distSignal = dataProcs.ValGen('manual', [3]);
sc.addOverlay( ...
    dataProcs.ValGen('random', [0,359.9]), ...
    dataProcs.ValGen('manual', 3),...
    dataProcs.ValGen('manual', [SNR]), 'diffuse',...
    dataProcs.ValGen('set', {'trainingScripts/noise/whtnoise.wav'}), ...
    dataProcs.ValGen('manual', 0) );
testpipe.setSceneConfig( [sc] ); 

testpipe.init();
testpipe.pipeline.run( {classname}, 0 );

end
