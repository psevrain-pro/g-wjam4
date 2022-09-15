extends Node2D

onready var scene_skeleton = preload("res://skeleton.tscn")
export var nombre_skeletons : int = 5

onready var jeu =  get_parent()
onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
#	for cpt in range(0, nombre_skeletons):
#		var skel = scene_skeleton.instance()
#		skel.position = jeu.get_random_point_spawn()
#		skel.set_nouvelle_destination(jeu.get_random_point_terrain())
#		$agents.add_child(skel)
	timer.connect("timeout", self, "_on_timer_timeout")
	timer.start()

func _on_timer_timeout():
	var liste_agents = $agents.get_children()
	for s in liste_agents:
		if s.status =="IDLE":
			s.set_nouvelle_destination (jeu.get_random_point_terrain())

func _on_Player_call_agents(position, distance):
	var liste_agents = $agents.get_children()
	for s in liste_agents:
		if position.distance_to(s.position) < (distance +10) :
			s.set_nouvelle_destination (position, true)
