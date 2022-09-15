extends KinematicBody2D

signal call_agents

var speed = 120
var velocity = Vector2()
var puissance_depart = 50
var puissance = puissance_depart
var puissance_inc = 250
onready var jeu =  get_node("/root/jeu")

func get_input(delta):

	if Input.is_action_pressed("ui_select"):
		puissance += delta * (puissance + puissance_inc)
		$cercle.dessine_cercle(puissance)
	elif Input.is_action_just_released("ui_select") :
			emit_signal("call_agents", position, puissance)
			$cercle.dessine_cercle(0)
			puissance = puissance_depart
			AudioManager.play_call()
	else :
		velocity = Vector2()
		if Input.is_action_pressed('ui_right'):
			velocity.x += 1
		if Input.is_action_pressed('ui_left'):
			velocity.x -= 1
		if Input.is_action_pressed('ui_down'):
			velocity.y += 1
		if Input.is_action_pressed('ui_up'):
			velocity.y -= 1
		velocity = velocity.normalized() * speed

func _physics_process(delta):
	get_input(delta)
	var collision = move_and_collide(velocity * delta)
	if collision and collision.collider.has_method("whoami") and $AnimatedSprite.animation!="mort" :
		if collision.collider.whoami() == "COFFRE":
			collision.collider.ouvre()
		else:
			_perdu()

func _perdu():
	AudioManager.play_mort()
	$AnimatedSprite.play("mort")
	yield( $AnimatedSprite, "animation_finished" )
	jeu.game_over()
