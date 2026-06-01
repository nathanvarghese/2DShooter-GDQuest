extends CharacterBody2D

signal health_depleted

var health = 100.0

func _physics_process(delta):
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = direction * 600
	move_and_slide()
	
	var happy_boo = get_node("HappyBoo")

	# Flip sprite based on horizontal movement
	if direction.x < 0:
		happy_boo.scale.x = -1
	elif direction.x > 0:
		happy_boo.scale.x = 1

	if velocity.length() > 0.0:
		happy_boo.play_walk_animation()
	else:
		happy_boo.play_idle_animation()
	
	#if velocity.length() > 0.0:
		#get_node("HappyBoo").play_walk_animation()
	#else:
		#get_node("HappyBoo").play_idle_animation()

	const DAMAGE_RATE = 6.0
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs:
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		%HealthBar.value = health
		if health <= 0.0:
			health_depleted.emit()
