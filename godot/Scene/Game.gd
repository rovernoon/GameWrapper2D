class_name Game
extends Node2D


func _ready():
	View.open("ExampleView")

func _process(_delta):
	if !View.has_focus and Input.is_action_just_pressed("ui_select"):
		View.open("ExampleView")
