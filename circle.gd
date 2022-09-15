extends Area2D

var radius : int 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	var nombre_points =  radius + 10
	draw_arc(position, radius, 0, TAU, nombre_points, Color.aqua)

func dessine_cercle(new_radius : int):
	radius = new_radius
	update()
