extends Node2D

@export var noise_height_text : NoiseTexture2D 
@export var chunk_size := 1024 
@export var tree_spacing := 64 
@export var noise_threshold := 0.25

var noise : Noise 
var loaded_chunks = {}

func _ready(): 
	noise = noise_height_text.noise
	
func _process(_delta): 
	var player = %Player
	var chunk_x = floor(player.global_position.x / chunk_size) 
	var chunk_y = floor(player.global_position.y / chunk_size)
	
	var current_chunk = Vector2i(chunk_x, chunk_y) 
	update_chunks(current_chunk)
	
func update_chunks(center_chunk): 
	var render_distance = 2
	
	for x in range( center_chunk.x - render_distance, center_chunk.x + render_distance + 1 ): 
		for y in range( center_chunk.y - render_distance, center_chunk.y + render_distance + 1 ):
			var chunk = Vector2i(x, y)
			
			if !loaded_chunks.has(chunk): 
				generate_chunk(chunk)


func generate_chunk(chunk : Vector2i): 
	const TREE = preload("res://scenes/tree.tscn")
	var chunk_node = Node2D.new() 
	add_child(chunk_node)
	loaded_chunks[chunk] = chunk_node
	
	var start_x = chunk.x * chunk_size 
	var start_y = chunk.y * chunk_size
	
	for x in range(0, chunk_size, tree_spacing):
		for y in range(0, chunk_size, tree_spacing):
			var world_x = start_x + x 
			var world_y = start_y + y 
			var value = noise.get_noise_2d( world_x, world_y )
			
			if value > noise_threshold: 
				var tree_instance = TREE.instantiate()

				
				tree_instance.position = Vector2( world_x + randf_range(-20, 20), world_y + randf_range(-20, 20) )
				chunk_node.add_child(tree_instance)

func spawn_mob():
	var new_mob = preload("res://scenes/mob.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)

func _on_timer_timeout() -> void:
	spawn_mob()

func _on_player_health_depleted() -> void:
	%GameOver.visible = true
	get_tree().paused = true
