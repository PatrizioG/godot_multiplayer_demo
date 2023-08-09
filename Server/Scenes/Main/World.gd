extends Node2D

var multiplayer_peer = ENetMultiplayerPeer.new()
var connected_peers := Dictionary()
const PORT = 9999

# Called when the node enters the scene tree for the first time.
func _ready():	
	multiplayer_peer.create_server(PORT)
	multiplayer.multiplayer_peer = multiplayer_peer	
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)

	SyncroHub.input_received_from_client.connect(func(input, peer_id):
		print('input received: ', input, ' from: ', peer_id)
		# connected_peers[str(peer_id)]["input"].append(input)
		#update position
		connected_peers[str(peer_id)]["position"] += input.velocity
		)

	SyncroHub.position_received_from_client.connect(func(position, peer_id):
		print('position received: ', position, ' from: ', peer_id)
		connected_peers[str(peer_id)]["position"] = position
		# 
	)
	
func _physics_process(delta):
	for peer_id in connected_peers.keys():
		var peer : Dictionary = connected_peers[peer_id]
		if peer.has("position"):
			SyncroHub.send_position_to_clients.rpc(peer_id, peer["position"])
		

func send_input_to_server_back(input, sender_id):
		for peer in connected_peers.keys():
			connected_peers[peer]["input"]
	

func peer_connected(peer_id):
	print("User " + str(peer_id) + " connected")
	
	# Chose a random color.
	var color = Color(randf(), randf(), randf())
	
	# Spawn the character to all the connected client
	rpc("spawn_character", peer_id, color)
	
	# Spawn the previously connected character to the new connected client
	rpc_id(peer_id, "spawn_previously_connected_characters", connected_peers)
	
	connected_peers[str(peer_id)] = { 
		"input" = []
	}
	
	var label = Label.new()
	label.text = str(peer_id)
	$VBoxContainer.add_child(label)

func peer_disconnected(peer_id):
	print("User " + str(peer_id) + " disconnected")
	connected_peers.erase(str(peer_id))
#	var circle = get_node(str(peer_id))
#	if circle:
#		circle.queue_free()


@rpc("call_local")
func spawn_character(peer_id, color):
	pass
	
@rpc("call_local")
func spawn_previously_connected_characters(peers):
	pass
