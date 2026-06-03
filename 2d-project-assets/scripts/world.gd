#world.gd
extends Node2D

@onready var generation = $WorldObjects/WorldGeneration

func _ready():
	print("WORLD READY")

func _process(_delta):
	#print("Process is running... ")
	generation.update_chunks(get_player_chunk())

func get_player_chunk() -> Vector2i:
	var player = %Player
	#print("get_player_chunk is running...")

	return Vector2i(
		floor(player.global_position.x / 1024),
		floor(player.global_position.y / 1024)
	)

func _on_player_health_depleted():
	$UI/EndScreen.visible = true
	get_tree().paused = true
