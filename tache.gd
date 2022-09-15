extends StaticBody2D

onready var jeu = get_node("/root/jeu")
onready var scene_particules = preload("res://ParticlesMagic.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	$Timer.connect("timeout", self, "_on_timeout")


func whoami() -> String :
	return "TACHE"

func washed():
	jeu.score(1)
	var p = scene_particules.instance()
	get_parent().add_child(p)
	p.position = position
	queue_free()

func _on_timeout():
	self.queue_free()
