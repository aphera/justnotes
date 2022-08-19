{
	var	intervalToRatio = Dictionary[
		// from https://music.stackexchange.com/questions/108096/what-are-the-ratios-of-just-intonation
		0 -> 1,
		1 -> (16 / 15),
		2 -> (9  / 8),
		3 -> (6 / 5),
		4 -> (5 / 4),
		5 -> (4 / 3),
		6 -> (45 / 32),
		7 -> (3 / 2),
		8 -> (8 / 5),
		9 -> (5 / 3),
		10 -> (9 / 5),
		11 -> (15 / 8),
	];

	var midiToFreq = {
		arg midiNote;
		440 * (2 ** ((midiNote - 69) / 12));
	};

	var jnsynth = {
		arg freq;
		Pulse.ar(freq * 1.0001, 0.367879441, 0.01) +
		SinOsc.ar(freq, 0.2, 0.2) +
		Saw.ar(freq * 0.9999, 0.02);
	};

	var getFrequencyMultiplier = {
		arg fundamental, harmonic;
		var difference = harmonic - fundamental;
		2 ** (difference / 12).floor;
	};

	var buildChord = {
		arg fundamental, harmonics; // These should be midi notes
		var fundamentalFreq = midiToFreq.value(fundamental);
		var getHarmonicFreq = {
			arg harmonic;
			var multiplier = getFrequencyMultiplier.value(fundamental, harmonic);
			var interval = (harmonic - fundamental) % 12;
			var ratio = intervalToRatio[interval] * multiplier;
			ratio * fundamentalFreq;
		};
		var harmonicFreqs = harmonics.collect(getHarmonicFreq);
		var allFreqs = [fundamentalFreq] ++ harmonicFreqs;
		allFreqs.postln;
		Pan2.ar(Mix.new(allFreqs.collect(jnsynth)), 0.0);
	};
	buildChord.value(55, [59, 62, 65, 69]); // G
	// buildChord.value(50, [53, 57, 60, 64]); // D
	// buildChord.value(62, [41, 69, 72, 52]); // D (alt)
	// buildChord.value(46, [49, 53, 56, 59]); // B-flat
	// buildChord.value(46, [50, 53, 56, 59]); // B-flat (alt)
	// buildChord.value(45, [48, 52, 55, 58]); // A
	// buildChord.value(57, [60, 64, 67, 58]); // A (alt)
}.play;