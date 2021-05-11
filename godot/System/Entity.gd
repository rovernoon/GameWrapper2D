extends Node

var entity_scenes = {}

func _recurse_add_entities(path):
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir() and !file_name in [".", ".."]:
				_recurse_add_entities(path + "/" + file_name)
			elif file_name.ends_with(".tscn"):
				var entity_name = file_name.right(file_name.find_last("/")+1)
				entity_name = entity_name.left(len(entity_name)-5)
				entity_scenes[entity_name] = load(path + "/" + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func _ready():
	_recurse_add_entities("res://Entity")

func instance(entity):
	if !entity in entity_scenes:
		print("Unknown entity \"%s\"" % entity)
	return entity_scenes[entity].instance()
