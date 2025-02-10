extends Node2D
class_name player

signal peer_cmd(content)

var peer := WebSocketMultiplayerPeer.new()

@export
var mouse_input = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.peer_connected.connect(_peer_connected)
	multiplayer.peer_disconnected.connect(_peer_disconnected)
	multiplayer.server_disconnected.connect(_close_network)
	multiplayer.connection_failed.connect(_close_network)
	multiplayer.connected_to_server.connect(_connected)
	
	if mouse_input:
		# The player follows the mouse cursor automatically, so there's no point
		# in displaying the mouse cursor.
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _input(event: InputEvent) -> void:
	if mouse_input:
		# Getting the movement of the mouse so the sprite can follow its position.
		if event is InputEventMouseMotion:
			position = event.position - Vector2(0, 16)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

@rpc
func log(content):
	peer_cmd.emit(content)
	print("log: emit signal peer_cmd"+content)

func _peer_connected(id):
	print("peer connect",str(id))
	log.rpc("peer connect",str(id))

func _peer_disconnected(id):
	print("peer disconnected",id)

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
