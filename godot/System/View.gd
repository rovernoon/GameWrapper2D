extends Node

const FADE_TIME = 0.1

var canvas 
var views = {}

static func _recurse_find_views(path, view_scenes):
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir() and !file_name in [".", ".."]:
				_recurse_find_views(path + "/" + file_name, view_scenes)
			elif file_name.ends_with(".tscn"):
				var view_name = file_name.right(file_name.find_last("/")+1)
				view_name = view_name.left(len(view_name)-5)
				view_scenes[view_name] = load(path + "/" + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func _ready():
	canvas = CanvasLayer.new()
	canvas.layer = 2
	add_child(canvas)
	
	var view_scenes = {}
	_recurse_find_views("res://View", view_scenes)
	
	for s in view_scenes:
		views[s] = view_scenes[s].instance()
		views[s].visible = false
		canvas.add_child(views[s])

var t = 0
var t_max = 0
var fade_target
var fade_out = false
var has_focus = false
var stack = []
func _process(delta):
	if t > 0 and fade_target != null:
		t -= delta
		if t <= 0:
			t = 0
			if fade_out:
				fade_target.visible = false
				fade_target.ready = false
				stack.pop_back()
				if len(stack) > 0:
					has_focus = true
					stack[len(stack)-1].modulate = Color.white
				else:
					has_focus = false
				fade_target.on_close()
				fade_target.emit_signal("close")
			else:
				fade_target.on_open()
				fade_target.emit_signal("open")
		if fade_out:
			fade_target.modulate.a = sqrt(t/t_max)
		else:
			fade_target.modulate.a = 1-sqrt(t/t_max)
	
	for view in stack:
		if _view_has_focus(view):
			view.process(delta)

func open(view_name, args=null):
	fade_target = views[view_name]
	fade_target.ready = false
	fade_target.visible = true
	fade_target.modulate.a = 0
	fade_target.on_opening(args)
	fade_out = false
	t_max = FADE_TIME
	t = t_max
	has_focus = true
	# Apply a visual effect to unfocused views, so that the focused one stands out
	if len(stack) > 0:
		stack[len(stack)-1].modulate = Color.darkgray
	stack.append(fade_target)

func close(view_name):
	fade_target = views[view_name]
	fade_target.on_closing()
	fade_out = true
	t_max = FADE_TIME
	t = t_max

func _view_has_focus(v):
	return has_focus and stack[len(stack)-1] == v

func is_view_ready(view_name):
	return views[view_name].ready

func connect_view(view_name, signal_name, to, fn_name, args=[]):
	views[view_name].connect(signal_name, to, fn_name, args)

