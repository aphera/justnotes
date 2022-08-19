{
	var midiToFreq = {
		arg midiNote;
		440 * (2 ** ((midiNote - 69) / 12));
	};
	midiToFreq.value(60).postln;
}.value;
