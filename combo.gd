extends Node2D

var paths: Array[NodePath] = []


func _enter_tree() -> void:
	for ch in $GridContainer.get_children():
		paths.append(NodePath(str(get_path()) + "/GridContainer/" + str(ch.name)))
	# Sets a dedicated Multiplayer API for each branch.
	for path in paths:
		get_tree().set_multiplayer(MultiplayerAPI.create_default_interface(), path)


func _exit_tree() -> void:
	# Clear the branch-specific Multiplayer API.
	for path in paths:
		get_tree().set_multiplayer(null, path)

#func _ready() -> void:
	#add_player_peer()
	#add_player_peer()
	#
	#for ch in $GridContainer.get_children():
		#paths.append(NodePath(str(get_path()) + "/GridContainer/" + str(ch.name)))
	## Sets a dedicated Multiplayer API for each branch.
	#for path in paths:
		#get_tree().set_multiplayer(MultiplayerAPI.create_default_interface(), path)

var y = 0

func add_player_peer():
	
	var p = preload("res://main.tscn")
	var pp = p.instantiate()
	pp.position = Vector2(0, y)
	y+=50
	$GridContainer.add_child(pp)
	pp.peer_cmd.connect(peer_cmd_f)
	
func peer_cmd_f(content):
	print("accept peer cmd")
