extends Node2D

var multiplayer_peer = ENetMultiplayerPeer.new()
var connected_peer_ids = []
const PORT = 9999
const ADDRESS = "127.0.0.1"

var Circle = preload("res://Scenes/Main/Circle.tscn")

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
	var color = Color(randf(), randf(), randf())
	rpc("spawn_character", peer_id, color)
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
	
func _on_client_btn_pressed():
	$NetworkInfo/NetworkSideDisplay.text = "Client"
	$Menu.visible = false
	multiplayer_peer.create_client(ADDRESS, PORT)	
	multiplayer.multiplayer_peer = multiplayer_peer
	$NetworkInfo/UniquePeerID.text = str(multiplayer.get_unique_id())
	
	multiplayer.connection_failed.connect(func(): 
		print("Connection failed"))
		
	multiplayer.connected_to_server.connect(func():
		print("Connected to server"))
		
	multiplayer.server_disconnected.connect(func():
		print("Server disconnected"))

func add_player(peer_id, color):
	connected_peer_ids.append(peer_id)
	var circle = Circle.instantiate()
	circle.name = str(peer_id)
	circle.color = color
	circle.queue_redraw()
	circle.set_multiplayer_authority(peer_id)
	add_child(circle)	
