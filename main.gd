extends Node2D

var peer := WebSocketMultiplayerPeer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.peer_connected.connect(_peer_connected)
	multiplayer.peer_disconnected.connect(_peer_disconnected)
	multiplayer.server_disconnected.connect(_close_network)
	multiplayer.connection_failed.connect(_close_network)
	multiplayer.connected_to_server.connect(_connected)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

@onready var control: Control = $Control

@rpc
func log(content):
	print("log:"+content)

func _peer_connected(id):
	print("peer connect"+str(id))
	log.rpc("peer connect"+str(id))
	control.log.rpc("peer connect"+str(id))

func _peer_disconnected(id):
	print("peer disconnected"+id)

func _close_network():
	multiplayer.multiplayer_peer.close()
	multiplayer.multiplayer_peer = null
	peer.close()

func _connected():
	print("connected")

func _on_Host_pressed():
	print("hosting")
	multiplayer.multiplayer_peer = null
	peer.create_server(9927)
	multiplayer.multiplayer_peer = peer
	print("hosted")

func _on_Disconnect_pressed():
	print("dissconnecting")
	_close_network()

func _on_Connect_pressed():
	print("connecting")
	multiplayer.multiplayer_peer = null
	peer.create_client("ws://localhost:9927")
	multiplayer.multiplayer_peer = peer
