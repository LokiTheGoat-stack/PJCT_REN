extends EnemieStateBase

func on_physics_process(delta: float) -> void:
	#si esta en modo espera cambiar a Idle
	if controlled_node.is_waiting:
		controlled_node.animation_machine.travel("Idle")
		state_machine.change_to("Idle")
	
	#control del movimiento
	set_waypoint_direction()
	controlled_node.velocity.x = controlled_node.direction.x * controlled_node.walk_speed
	get_next_waypoint()
	
	
	controlled_node.velocity.y += 1600 * delta
	controlled_node.move_and_slide()


#region WAYPOINTS_&_MOVEMENT
#actualizar la direccion si esta en modo patrulla
func set_waypoint_direction():
	var target_position: Vector2 = controlled_node.waypints[controlled_node.current_waypoint].global_position
	controlled_node.direction = target_position - controlled_node.global_position
	controlled_node.current_distance = controlled_node.direction.length()
	controlled_node.direction = controlled_node.direction.normalized()

#obtener proximo punto de ruta
func get_next_waypoint():
	if controlled_node.current_distance < controlled_node.min_distance:
		controlled_node.current_waypoint += 1
		controlled_node.velocity = Vector2.ZERO
		controlled_node.is_waiting = true
		controlled_node.waiting_timer.start()
		if controlled_node.current_waypoint >= controlled_node.waypints.size(): controlled_node.current_waypoint = 0
#endregion
