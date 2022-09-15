extends Node2D

onready var jeu = get_node("/root/jeu")

# Called when the node enters the scene tree for the first time.
func _ready():
	jeu.connect("spawn", self, "spawn")

func spawn(proba):
	if randi()%100 < proba:
		#AudioManager.play_spawn()
		$AnimatedSprite.play("spawn")
		yield($AnimatedSprite, "animation_finished")
		$AnimatedSprite.play("default")
		var where = Vector2(position.x + randi()%10,position.y + randi()%10 )
		jeu.create_mob(where)
