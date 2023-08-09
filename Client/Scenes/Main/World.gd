extends Node2D

var multiplayer_peer = ENetMultiplayerPeer.new()
var connected_peers = {}
const PORT = 9999
const ADDRESS = "127.0.0.1"

var Circle = preload("res://Scenes/Main/Circle.tscn")
var local_player: Circle

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
	
func _ready():
	$NetworkInfo/NetworkSideDisplay.text = "Client"
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
		
	SyncroHub.position_received_from_server.connect(func(peer_id, position):
		print('position received: ', position, ' for peer ', peer_id)
		var circle = self.get_node(peer_id)
		if circle:
			circle.position = position
		)

func add_player(peer_id, color):
	connected_peers[peer_id] = color
	var circle = Circle.instantiate()
	circle.name = str(peer_id)
	circle.label = str(peer_id)
	circle.color = color
	circle.set_multiplayer_authority(peer_id)
	add_child(circle)
	
	# SyncroHub.send_position_to_server(circle.position)
	SyncroHub.send_position_to_server.rpc_id(1, circle.position)
	
	if peer_id == multiplayer.get_unique_id():
		local_player = circle

func _on_line_edit_text_submitted(new_text):
	print("input submitted: ", new_text)	
	local_player.latency = float(new_text) # Replace with function body.	
	$Lag/LineEdit.release_focus()
