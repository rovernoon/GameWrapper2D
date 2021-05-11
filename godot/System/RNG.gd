extends Node

enum {
	DEFAULT
}

var rng = {
	DEFAULT: null,
}

func _ready():
	for g in rng:
		rng[g] = RandomNumberGenerator.new()

func set_seed(s, generator=DEFAULT):
	rng[generator].set_seed(s)

func randi(generator=DEFAULT):
	return rng[generator].randi()

func randf(generator=DEFAULT):
	return rng[generator].randf()

func randi_range(a, b, generator=DEFAULT):
	return rng[generator].randi_range(a, b)
	
func randf_range(a, b, generator=DEFAULT):
	return rng[generator].randf_range(a, b)

func randfn(mean=0.0, deviation=1.0, generator=DEFAULT):
	return rng[generator].randfn(mean, deviation)

func randomize(generator=DEFAULT):
	rng[generator].randomize()

func get_generator(generator):
	return rng[generator]
