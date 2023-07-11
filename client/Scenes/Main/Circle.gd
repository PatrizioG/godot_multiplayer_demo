extends Node2D

@export var radius: float
@export var color: Color
@export var speed: float = 400
@export var client_side_prediction: bool = true
@export var entity_interpolation:bool = true;
@export var server_reconciliation:bool = true;

var input_sequence_number = 0
var pending_inputs: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	draw_circle(position, radius, color)

func _physics_process(delta):
	process_server_messages()
	process_input(delta)	
	if entity_interpolation:
		interpolate_entities()

func process_server_messages():
	while true:
		var world_state = Network.world_states.pop_back()
		if world_state == null:
			break
		
func process_input(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("ui_left"): velocity.x -= 1
	if Input.is_action_pressed("ui_right"): velocity.x += 1
	if Input.is_action_pressed("ui_up"): velocity.y -= 1
	if Input.is_action_pressed("ui_down"): velocity.y += 1
	
	if velocity.length() <= 0:
		return
	
	velocity = velocity.normalized() * speed * delta
	
	# Send the input to the server.
	input_sequence_number += 1
	var input: Dictionary = {
		"velocity" = velocity,
		"press_time" = delta,
		"input_sequence_number" = input_sequence_number,
	}
	
	Network.to_server(input)	
	
	if client_side_prediction:
		position += velocity
		
	# Save this input for later reconciliation.
	pending_inputs.append(input)
	
func interpolate_entities():
	pass
