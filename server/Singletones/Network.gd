extends Node

var network = ENetMultiplayerPeer.new()
var port = 1909
var max_players = 100

signal peer_connected_signal(peer_id)
signal peer_disconnected_signal(peer_id)

var world_state = {}

func _ready():	
	network.create_server(port, max_players)	
	multiplayer.multiplayer_peer = network
	print("Server started")

	multiplayer.peer_connected.connect(
		func(peer_id):
		print("User " + str(peer_id) + " connected")
		peer_connected_signal.emit(peer_id)
	)

	multiplayer.peer_disconnected.connect(
		func(peer_id):
			print("User " + str(peer_id) + " disconnected")
			peer_disconnected_signal.emit(peer_id)
	)

@rpc("any_peer")
func fetch_skill_damage(type):
	var peer_id = multiplayer.get_remote_sender_id()
	if not world_state.has(str(peer_id)):
		world_state[str(peer_id)] = []
	world_state[str(peer_id)].push_front(type)
