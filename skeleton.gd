extends KinematicBody2D

var destination: Vector2
var speed = 50
var velocity
var timer

var status = "RUN"
var washing;

onready var jeu = get_node("/root/jeu")
onready var scene_questions = preload("res://buble_questions.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = get_node("Timer")
	timer.connect("timeout", self, "_on_timer_timeout_wash")


func _physics_process(delta):
	
	if status == "WASH":
		return
	elif status == "RUN": 
		velocity = (destination - position).normalized() * speed
		if (destination - position).length() < 1:
			status = "IDLE"

	var collision = move_and_collide(velocity * delta)
	if collision:
		_on_collision(collision)
	else:
		var tache = jeu.get_tache_proche(position, 35)
		if (tache):
			destination = tache.position
	#$debug.text= "%s %d %d" % [status, destination.x, destination.y]
	
		
func set_nouvelle_destination(dest: Vector2, call: bool = false):
	status ="RUN"
	destination = dest
	if call:
		var buble = scene_questions.instance()
		buble.position = Vector2(0, -16)
		self.add_child(buble)

func whoami() -> String :
	return "SKEL"

func _on_collision(collision):
	if collision.collider.has_method("whoami"):
		var qui = collision.collider.whoami()
		if qui =="TACHE":
			_start_washing(collision.collider)
		elif qui =="SKEL":
			status = "IDLE"
		elif qui =="MOB":
			if is_instance_valid(collision.collider):
				collision.collider.mort()
	else:
		status = "IDLE"
			
func _start_washing(what):
	$AnimatedSprite.animation = "washing"
	timer.set_wait_time(0.7)
	status = "WASH"
	washing = what
	timer.start()
	
func _on_timer_timeout_wash():
	if is_instance_valid(washing):
		washing.washed()
		AudioManager.play_gain()
	status = "RUN"
	$AnimatedSprite.animation = "default"
	
