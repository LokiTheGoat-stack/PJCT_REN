extends PlayerStateBase

var interlude_type: String
var is_agarre: bool = false
var up: bool = false
var agarre_direction: Vector2

func start():
	start_interlude()

func start_interlude(): 
	match interlude_type:
		"climb": climb()
		"agarre":agarre()
		_: pass

func climb(): #si se salta pegado a una pared hacer climb antes que wall slide
	controlled_node.velocity = Vector2.ZERO
	controlled_node.animation_machine.travel("Jump_Up")
	controlled_node.velocity.y = -600
	$"../PlayerStateWall_Jump".climb = true
	state_machine.change_to("PlayerStateWall_Jump")
	PlayerMovementStats.jump_count = 1

func agarre():
	controlled_node.velocity = Vector2.ZERO
	up = true


#region ALWAYS_ON_FUNC
func on_physics_process(delta: float) -> void:
	if up:
		match agarre_direction:
			Vector2.RIGHT:
				if controlled_node.bottom_ray_cast_left.is_colliding():
					controlled_node.velocity = Vector2(0,-350)
				elif not controlled_node.ground_raycast_r.is_colliding():
					controlled_node.velocity = Vector2(-350,0)
				else:
					up = false
					controlled_node.velocity = Vector2.ZERO
					controlled_node.animation_machine.travel("Idle")
					state_machine.change_to("PlayerStateIdle")
			Vector2.LEFT:
				if controlled_node.bottom_ray_cast_right.is_colliding():
					controlled_node.velocity = Vector2(0,-350)
				elif not controlled_node.ground_raycast_l.is_colliding():
					controlled_node.velocity = Vector2(350,0)
				else:
					up = false
					controlled_node.velocity = Vector2.ZERO
					controlled_node.animation_machine.travel("Idle")
					state_machine.change_to("PlayerStateIdle")
			_: pass
	
	controlled_node.move_and_slide()

func on_input(event: InputEvent) -> void:
	if is_agarre and \
	(Input.is_action_pressed("LEFT") or \
	Input.is_action_pressed("RIGHT") or \
	Input.is_action_pressed("JUMP")):
		is_agarre = false
		up = true
#endregion
