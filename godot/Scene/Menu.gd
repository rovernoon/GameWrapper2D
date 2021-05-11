class_name Menu
extends VBoxContainer


func _ready():
	pass


func _on_StartGame_pressed():
	get_tree().change_scene("res://Scene/Game.tscn")
