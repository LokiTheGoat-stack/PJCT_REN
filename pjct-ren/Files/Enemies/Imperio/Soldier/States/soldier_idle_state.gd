extends EnemieStateBase

func on_physics_process(delta: float) -> void:
	#si esta en modo espera cambiar a Idle
	if not controlled_node.is_waiting:
		controlled_node.animation_machine.travel("Walk")
		state_machine.change_to("Patrol")
	
	#control del movimiento
	controlled_node.velocity = Vector2.ZERO
	
	
	controlled_node.velocity.y += 1600 * delta
	controlled_node.move_and_slide()
