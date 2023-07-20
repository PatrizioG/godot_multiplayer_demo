extends Node2D

var multiplayer_peer = ENetMultiplayerPeer.new()
var connected_peers = {}
const PORT = 9999
const ADDRESS = "127.0.0.1"

var Circle = preload("res://Scenes/Main/Circle.tscn")
var local_player: Circle

func _on_server_btn_pressed():
	$NetworkInfo/NetworkSideDisplay.text = "Server"
	$Menu.visible = false
	multiplayer_peer.create_server(PORT)
	multiplayer.multiplayer_peer = multiplayer_peer
	$NetworkInfo/UniquePeerID.text = str(multiplayer.get_unique_id())
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)

func peer_connected(peer_id):
	print("User " + str(peer_id) + " connected")
	
	# Chose a random color.
	var color = Color(randf(), randf(), randf())
	
	# Spawn the character to all the connected client
	rpc("spawn_character", peer_id, color)
	
	# Spawn the previously connected character to the new connected client
	rpc_id(peer_id, "spawn_previously_connected_characters", connected_peers)
	
	# Add player to the server.
	add_player(peer_id, color)

func peer_disconnected(peer_id):
	print("User " + str(peer_id) + " disconnected")
	var circle = get_node(str(peer_id))
	if circle:
		circle.queue_free()

# default
#@rpc("authority", "call_remote", "reliable", channel)

@rpc("call_remote")
func spawn_character(peer_id, color):
	# call this method only to connected clients
	add_player(peer_id, color)
	
@rpc("call_remote")
func spawn_previously_connected_characters(peers):
	for peer in peers.keys():
		add_player(peer, peers[peer])
	
func _on_client_btn_pressed():
	$NetworkInfo/NetworkSideDisplay.text = "Client"
	$Menu.visible = false
	multiplayer_peer.create_client(ADDRESS, PORT)	
	multiplayer.multiplayer_peer = multiplayer_peer
	$NetworkInfo/UniquePeerID.text = str(multiplayer.get_unique_id())
	$Lag.visible = true
	
	multiplayer.connection_failed.connect(func(): 
		print("Connection failed"))
		
	multiplayer.connected_to_server.connect(func():
		print("Connected to server"))
		
	multiplayer.server_disconnected.connect(func():
		print("Server disconnected"))

func add_player(peer_id, color):
	connected_peers[peer_id] = color
	var circle = Circle.instantiate()
	circle.name = str(peer_id)
	circle.label = str(peer_id)
	circle.color = color
	circle.set_multiplayer_authority(peer_id)
	add_child(circle)
	if peer_id == multiplayer.get_unique_id():
		local_player = circle

func _on_line_edit_text_submitted(new_text):
	print("input submitted: ", new_text)	
	local_player.latency = float(new_text) # Replace with function body.	
	$Lag/LineEdit.release_focus()
