extends EnemieStateBase

func on_physics_process(delta: float) -> void:
	
	controlled_node.direction = (controlled_node.player.global_position - controlled_node.global_position).normalized()
	controlled_node.velocity.x = controlled_node.direction.x * controlled_node.run_speed
	
	controlled_node.velocity.y += 1600 * delta
	controlled_node.move_and_slide()
