extends Node

signal position_received_from_server(peer_id, position)

@rpc("call_local", "unreliable")
func send_input_to_server(input):
	rpc_id(1, "send_input_to_server", input)

#@rpc("call_local", "unreliable")
#func send_position_to_server(position):
#	rpc_id(1, "send_position_to_server", position)

@rpc("call_local", "unreliable")
func send_position_to_server(position):
	pass

@rpc("authority", "call_local", "reliable")
func send_position_to_clients(peer_id, position):
	position_received_from_server.emit(peer_id, position)
