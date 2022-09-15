extends Node2D

signal spawn

onready var scene_tache = preload("res://tache.tscn")
onready var scene_mob = preload("res://mob.tscn")
onready var scene_coffre = preload("res://coffre.tscn")

export var largeur :int = 240
export var longueur : int = 440
export var nombre_taches :int = 5
export var nombre_mobs :int = 6
var timer_spawn
var spawn_proba = 40

var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	for cpt in range (0, nombre_taches):
		create_tache(get_random_point_spawn())
	for cpt in range (0, nombre_mobs):
		create_mob(get_random_point_spawn())
	timer_spawn = $timer_spawn
	timer_spawn.connect("timeout", self, "_on_timer_spawn_timeout")
	AudioManager.play_intro()


func get_random_point_terrain():
	var result
	while result == null or ((result.x > 120 and result. x <320) and (result.y > 90 and result. y <200)):
		result = Vector2 (randi()%longueur, randi()%largeur)
	return result
 
func get_random_point_spawn():
	return Vector2 ( 20 + randi()%(longueur-40), 40 + randi()%(largeur-40))

func get_tache_proche(position: Vector2, dist_max: int = 1000):
	var best_dist = dist_max
	var best = null
	for tache in get_liste_taches():
		var d = position.distance_to(tache.position)
		if  d < best_dist :
			best_dist = d
			best = tache
	return best
	
func get_liste_taches()-> Array:
	return get_node("obstacles").get_children()
	
func create_tache(where):
	if $obstacles.get_child_count() > 100 :
		return
	var t = scene_tache.instance()
	t.position = where
	$obstacles.add_child(t)
	
func create_mob(where):
	var t = scene_mob.instance()
	t.position = where
	$obstacles.add_child(t)

func create_coffre(where):
	var t = scene_coffre.instance()
	t.position = where
	$obstacles.add_child(t)


func game_over():
	get_tree().paused = true
	$UI/popup_fin.popup()
	$UI/popup_fin/score.text = "You... and the AI... collected %s slimes!!!" % score	

func score(cb):
	score += cb
	$UI/score.text = "Slimes collected... %s" % score	

func _on_timer_spawn_timeout():
	spawn_proba += 1
	emit_signal("spawn", spawn_proba)
	AudioManager.play_spawn()
	
func _on_timer_coffre_timeout():
	create_coffre(get_random_point_spawn())
