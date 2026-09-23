extends EnemieStateBase

func on_physics_process(delta: float) -> void:
	
	#control raycast
	if not controlled_node.left_down_raycast.is_colliding():
		controlled_node.direction = Vector2.ZERO
	elif not controlled_node.right_down_raycast.is_colliding():
		controlled_node.direction = Vector2.ZERO
	elif controlled_node.left_raycast.is_colliding() and \
	controlled_node.player.global_position.x > controlled_node.global_position.x:
		controlled_node.direction = Vector2.ZERO
	elif controlled_node.right_raycast.is_colliding() and \
	controlled_node.player.global_position.x < controlled_node.global_position.x:
		controlled_node.direction = Vector2.ZERO
	else: controlled_node.direction = (controlled_node.global_position - controlled_node.player.global_position).normalized()
	
	
	controlled_node.velocity.x = controlled_node.direction.x * controlled_node.walk_speed
	
	controlled_node.velocity.y += 1600 * delta
	controlled_node.move_and_slide()

func off_timer():
	await get_tree().create_timer(3.0).timeout
	controlled_node.is_attack = false
	$"../../Body/AttackArea".set_deferred("monitoring",true)
	$"../../Body/AgroArea".set_deferred("monitoring",true)
	controlled_node.run_away = false
	controlled_node.animation_machine.travel("Idle")
	state_machine.change_to("Idle")
