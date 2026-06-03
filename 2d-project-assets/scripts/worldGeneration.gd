# WorldGeneration.gd
class_name WorldGeneration extends Node

@export var chunk_size := 1024
@export var render_distance := 2

var loaded_chunks := {}

func update_chunks(center_chunk: Vector2i):
	#print("update_world is running...")
	for x in range(
		center_chunk.x - render_distance,
		center_chunk.x + render_distance + 1
	):
		for y in range(
			center_chunk.y - render_distance,
			center_chunk.y + render_distance + 1
		):

			var chunk := Vector2i(x, y)

			if not loaded_chunks.has(chunk):
				create_chunk(chunk)

func create_chunk(chunk: Vector2i):
	#print("create_chunk is running...")

	loaded_chunks[chunk] = true

	for generator in get_children():

		if generator.has_method("generate_chunk"):
			generator.generate_chunk(chunk)
