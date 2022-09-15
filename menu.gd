extends Node2D


func _process(delta):
	if Input.is_action_pressed("ui_select"):
		get_tree().change_scene("res://jeu.tscn")
