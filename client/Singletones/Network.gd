extends Node

var network = ENetMultiplayerPeer.new()
var address = "127.0.0.1"
var port = 1909
var world_states: Array

func _ready():	
	start_server()	

func start_server():
	network.create_client(address, port)	
	multiplayer.multiplayer_peer = network
	
	multiplayer.connection_failed.connect(func(): 
		print("Connection failed"))
		
	multiplayer.connected_to_server.connect(func():
		print("Connected to server"))
		
	multiplayer.server_disconnected.connect(func():
		print("Server disconnected"))
		
@rpc
func fetch_skill_damage(num):
	rpc_id(1, 'fetch_skill_damage', num)

@rpc("authority")
func return_fetch_skill_damage(damage):
	print("return damage: ", damage)
	
@rpc("authority")
func receive_world_state(world_state):
	world_states.push_front(world_state)
