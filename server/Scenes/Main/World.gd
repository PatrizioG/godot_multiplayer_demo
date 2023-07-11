extends Node

var Circle = preload("res://Scenes/Main/Circle.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Network.peer_connected_signal.connect(peer_connected)
	Network.peer_disconnected_signal.connect(peer_disconnected)
	
func peer_connected(peer_id):
	var circle = Circle.instantiate()
	circle.name = str(peer_id)
	add_child(circle)	
	
func peer_disconnected(peer_id):
	get_node(str(peer_id)).queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
