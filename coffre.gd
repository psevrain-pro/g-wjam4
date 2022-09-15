extends StaticBody2D

onready var jeu = get_node("/root/jeu")
onready var scene_particules = preload("res://ParticlesMagic.tscn")

func ouvre():
	jeu.score(5)
	AudioManager.play_coffre()
	var p = scene_particules.instance()
	get_parent().add_child(p)
	p.position = position
	queue_free()

func whoami():
	return "COFFRE"

func _on_timer_vie_timeout():
	queue_free()
