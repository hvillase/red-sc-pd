// ==================================
// OSC con PureData
// ==================================

// recibir
OSCdef(\frecuencia, {|msg| a.set(\frec, msg[1])}, '/frec').fix;
OSCdef(\amplitud, {|msg| a.set(\amp, msg[1])}, '/amp').fix;

// enviar
m = NetAddr("127.0.0.1", 3000); // <-sustuir 127.0.0.1 por la ip encontrada

m.sendMsg("/frec", rrand(200.0, 1000.0));
m.sendMsg("/amp", rrand(0.0, 1.0));

// Instrumento: SynthDef
s.boot;

(
SynthDef(\red, {|frec = 400, amp = 0, gate = 1|
	var sen1, sen2, sen3, paneo1, paneo2, paneo3, mod, env;
	mod = LFNoise0.ar(frec/100);
	sen1 = SinOsc.ar(frec * 1, 0, amp * 0.5) * mod;
	sen2 = SinOsc.ar(frec * 1.89, 0, amp * 0.25) * mod;
	sen3 = SinOsc.ar(frec * 2.17, 0, amp * 0.125) * mod;
	paneo1 = Pan2.ar(sen1, -0.5);
	paneo2 = Pan2.ar(sen2, 0);
	paneo3 = Pan2.ar(sen3, 0.5);
	env = EnvGen.kr(Env.asr(0.1,1,0.3), gate, doneAction:2);
	Out.ar(0, (paneo1 + paneo2 + paneo3) * env)
}).add
);

a = Synth(\red)
