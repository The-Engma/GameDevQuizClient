extends Node

const PORT = 9999

var peer = ENetMultiplayerPeer.new()

func _ready() -> void:
	var error = peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_peer_connected)
	
func _on_peer_connected(peer_id: int) -> void:
	print(peer_id)
