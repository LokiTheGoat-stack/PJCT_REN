extends PlayerStateBase

var x_velocity: float = 0
var direction: Vector2 = Vector2.ZERO
var can_dash: bool = true

#region AWAYS_ON_FUNC
func on_physics_process(delta) -> void:
	if x_velocity != 0:
		controlled_node.velocity = direction * x_velocity
	
	controlled_node.move_and_slide()
#endregion

#activacion manual del Dash
func dash(state_name: String) -> void:
	if can_dash == true:
		can_dash = false
		if controlled_node.velocity.x == 0: no_velocity()
		else: with_velocity()
	else: state_machine.change_to(state_name)

#region DIRECTION_CONTROL
func no_velocity():
	if $"../../TestPlayerSprite".flip_h == true:
		direction = Vector2.LEFT
		x_velocity = PlayerMovementStats.dash_speed
	else:
		direction = Vector2.RIGHT
		x_velocity = PlayerMovementStats.dash_speed
	$"../../AnimationPlayer".play("Dash")
	finish_dash()

func with_velocity():
	if controlled_node.velocity.x < 0:
		direction = Vector2.LEFT
		x_velocity = PlayerMovementStats.dash_speed
	elif controlled_node.velocity.x > 0:
		direction = Vector2.RIGHT
		x_velocity = PlayerMovementStats.dash_speed
	$"../../AnimationPlayer".play("Dash")
	finish_dash()
#endregion

func finish_dash():
	await get_tree().create_timer(PlayerMovementStats.dash_time).timeout
	controlled_node.velocity = Vector2.ZERO
	x_velocity = 0
	direction = Vector2.ZERO
	
	#cambio de estado segun la situacion
	if controlled_node.is_on_floor():
		state_machine.change_to("PlayerStateIdle")
	else: state_machine.change_to("PlayerStateFall")
	
	#cooldown
	await get_tree().create_timer(PlayerMovementStats.dash_cooldown).timeout
	can_dash = true
