# TreeGenerator.gd
class_name TreeGenerator extends Node

@export var tree_scene : PackedScene
var noise : FastNoiseLite
#@export var noise : Noise
@onready var world_objects = get_tree().current_scene.get_node("WorldObjects")


@export var chunk_size := 1024
@export var spacing := 64
@export var threshold := 0.25
@export var random_offset := 20

func generate_chunk(chunk: Vector2i):
	#print("TreeGeneration.gd is running...")
	noise = FastNoiseLite.new()
	#print("Added new instance of FastNoiseLite")
	noise.seed = randi()
	noise.frequency = 0.005

	var chunk_root := Node2D.new()
	chunk_root.y_sort_enabled = true
	#add_child(chunk_root)
	world_objects.add_child(chunk_root)

	var start_x = chunk.x * chunk_size
	var start_y = chunk.y * chunk_size

	for x in range(0, chunk_size, spacing):
		for y in range(0, chunk_size, spacing):

			var world_x = start_x + x
			var world_y = start_y + y

			var value = noise.get_noise_2d(world_x, world_y)

			if value > threshold:

				var tree = tree_scene.instantiate()

				tree.position = Vector2(
					world_x + randf_range(-random_offset, random_offset),
					world_y + randf_range(-random_offset, random_offset)
				)

				chunk_root.add_child(tree)
