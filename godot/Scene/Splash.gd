extends Node2D

func _ready():
	$AnimationPlayer.play("Splash")

func on_splash_done():
	get_tree().change_scene("res://Scene/Menu.tscn")
