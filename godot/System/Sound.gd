extends Node

var sounds = {}
var original_volume_db = {}
func _ready():
	var s = load("res://System/Sound.tscn").instance()
	add_child(s)
	for child in s.get_children():
		sounds[child.name] = child
		original_volume_db[child.name] = child.volume_db

func set_volume(sound_name, v):
	sounds[sound_name].volume_db = v

func set_pitch(sound_name, p):
	sounds[sound_name].pitch_scale = p

var fade_targets = {}
func reset(sound_name):
	if sound_name in fade_targets:
		fade_targets.erase(sound_name)
	set_volume(sound_name, original_volume_db[sound_name])

func play(sound_name):
	reset(sound_name)
	sounds[sound_name].play()

func play_varied(sound_name):
	reset(sound_name)
	sounds[sound_name].pitch_scale = 1.0+randf()*0.1-0.05
	play(sound_name)
	
func stop(sound_name):
	sounds[sound_name].stop()
	
func fade(sound_name, l):
	set_volume(sound_name, original_volume_db[sound_name]-pow(l,2)*60)
	
func fade_out(sound_name, fade_time):
	fade_targets[sound_name] = {
		"t": fade_time,
		"t_max": fade_time,
		"in": false
	}
	
func fade_in(sound_name, fade_time):
	play(sound_name)
	fade_targets[sound_name] = {
		"t": fade_time,
		"t_max": fade_time,
		"in": true
	}

func _process(delta):
	var clear = []
	for key in fade_targets:
		fade_targets[key]["t"] -= delta
		var t = max(0, fade_targets[key]["t"])
		var t_max = fade_targets[key]["t_max"]
		if t >= 0:
			if fade_targets[key]["in"]:
				fade(key, clamp(t / t_max, 0, 1))
			else:
				fade(key, 1.0 - clamp(t / t_max, 0, 1))
		if t <= 0:
			if !fade_targets[key]["in"]:
				sounds[key].stop()
			clear.append(key)
	for key in clear:
		fade_targets.erase(key)
		
