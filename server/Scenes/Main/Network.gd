extends Node

var network = ENetMultiplayerPeer.new()
var port = 1909
var max_players = 100

signal peer_connected_signal(peer_id)
signal peer_disconnected_signal(peer_id)

func _ready():
	start_server()
	
func peer_connected(peer_id):
	print("User " + str(peer_id) + " connected")
	peer_connected_signal.emit(peer_id)
	
func peer_disconnected(peer_id):
	print("User " + str(peer_id) + " disconnected")
	peer_disconnected_signal.emit(peer_id)

func start_server():
	network.create_server(port, max_players)	
	multiplayer.multiplayer_peer = network
	print("Server started")
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)

@rpc("any_peer")
func fetch_skill_damage(type):
	var player_id = multiplayer.get_remote_sender_id()
	print("RPC called by: ", player_id, " with param ", type)
	#return_fetch_skill_damage(100)
	
@rpc("call_local")
func return_fetch_skill_damage(damage):
	var player_id = multiplayer.get_remote_sender_id()
	rpc_id(player_id, "return_fetch_skill_damage", damage)
	
@rpc("any_peer", "unreliable")
func synchronize_on_server(input):
	print('synchronize_on_server')
