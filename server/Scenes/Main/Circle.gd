extends Node2D

@export var radius: float
@export var color: Color
@export var speed: float = 400

func _draw():
	draw_circle(position, radius, color)
	
