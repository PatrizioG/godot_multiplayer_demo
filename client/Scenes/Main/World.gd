extends Node2D

var Circle = preload("res://Scenes/Main/Circle.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var circle = Circle.instantiate()
	add_child(circle)	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
