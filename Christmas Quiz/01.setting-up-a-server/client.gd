extends Node

const ADDRESS = "localhost"
const PORT = 9999

var peer = ENetMultiplayerPeer.new()

func _ready():
	peer.create_client(ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer
