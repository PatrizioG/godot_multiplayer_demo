extends Node

signal input_received_from_client
signal position_received_from_client

@rpc("any_peer", "call_remote", "unreliable")
func send_input_to_server(input):
	var peer_id = multiplayer.get_remote_sender_id()		
	input_received_from_client.emit(input, peer_id)

@rpc("any_peer", "call_remote", "unreliable")
func send_position_to_server(position):
	var peer_id = multiplayer.get_remote_sender_id()		
	position_received_from_client.emit(position, peer_id)

@rpc("authority", "call_local", "reliable")
func send_position_to_clients(peer_id, position):
	pass
