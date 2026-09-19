extends PlayerStateBase

var timer: float
var impulse_time: float = 0.5
var can_move: bool = false
var _velocity

#region ALWAYS_ON_FUNC
func on_physics_process(delta) -> void:
	
	if can_move:
		controlled_node.velocity = _velocity
		#print(str(controlled_node.velocity))
	
	timer -= delta
	if timer <= 0:
		can_move = false
		controlled_node.animation_machine.travel("Fall_Down")
		state_machine.change_to("PlayerStateFall")
	
	controlled_node.move_and_slide()

#endregion

func start_impulse(direction:Vector2,speed:float):
	controlled_node.velocity = Vector2.ZERO
	_velocity = direction * speed
	timer = impulse_time
	can_move = true
