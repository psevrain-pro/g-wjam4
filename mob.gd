extends KinematicBody2D

var speed = 40
var destination
var player
var proba_duplicate = 30
var gestation =0
onready var jeu = get_node("/root/jeu")
onready var scene_questions = preload("res://buble_questions.tscn")

func _ready():
	player = jeu.get_node("Player")
	if player:
		player.connect("call_agents", self, "_on_signal_call")
	_new_destination()

func _physics_process(delta):
	if (destination - position).length() > 0.5:
		var velocity = (destination - position).normalized() * speed
		var collision = move_and_collide(velocity * delta)
		if collision:
			_on_collision(collision)
	else :
		_new_destination()
		speed = 30 + randi()%20
	if gestation > 0:
		gestation -= delta

func whoami() -> String :
	return "MOB"

func mort():
	var player = $AnimatedSprite 
	if player.animation != "mort":
		destination = position
		AudioManager.play_skel_vs_mob()
		player.play("mort")
		yield( player, "animation_finished" )
		jeu.create_tache(position)
		queue_free()
	

func _new_destination():
	if randi()%100 < 25 :
		destination = jeu.get_node("Player").position
	else :
		destination = jeu.get_random_point_terrain()

func _on_collision(collision):
	if collision.collider.has_method("whoami"):
		var qui = collision.collider.whoami()
		if qui =="TACHE":
			pass
			#if is_instance_valid(collision.collider):
			#	collision.collider.queue_free()
			#jeu.create_mob(Vector2(position.x + randi()%10,position.y + randi()%10 ))
			#jeu.create_mob(Vector2(position.x + randi()%10,position.y + randi()%10 ))
		else:
			gestation = 10
			if gestation <= 0 and randi()%100 < proba_duplicate:
				jeu.create_tache(Vector2(position.x + randi()%10,position.y + randi()%10 ))
				AudioManager.play_duplicate()
				
			_new_destination()
	else :
		_new_destination()

func _on_signal_call(where, distance):
	if position.distance_to(where) < distance :
		destination = where
		if scene_questions:
			var buble = scene_questions.instance()
			buble.position = Vector2(0, -10)
			self.add_child(buble)
