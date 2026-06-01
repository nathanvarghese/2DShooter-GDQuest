extends Area2D

func _process(_delta):
	look_at(get_global_mouse_position())
	
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 and  rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
	
	if Input.is_action_just_pressed("shoot"):
		shoot()

func shoot():
	const BULLET = preload("res://bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_transform = %ShootingPoint.global_transform
	%ShootingPoint.add_child(new_bullet)
	
