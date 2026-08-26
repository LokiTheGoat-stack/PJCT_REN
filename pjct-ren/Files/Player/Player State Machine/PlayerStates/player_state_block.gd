extends PlayerStateBase

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_animation_play: bool = false

#region AWAYS_ON_FUNC
func on_physics_process(delta) -> void:
	controlled_node.velocity.x = 0
	
	if is_animation_play == false: play_animation()
	
	# Si no estas en el piso cambiar al estado Fall
	if controlled_node.is_on_floor() == false:
		state_machine.change_to("PlayerStateFall")
		is_animation_play = false
	
	handle_gravity(delta)
	controlled_node.move_and_slide()

func on_input(event: InputEvent) -> void:
	#Cambiar a Idle
	if not Input.is_action_pressed("BLOCK"):
		state_machine.change_to("PlayerStateIdle")
		is_animation_play = false
#endregion

func play_animation() -> void: #control de animacion
	is_animation_play = true
	#$"../../AnimationPlayer".play("Block")

func handle_gravity(delta) -> void: #control de gravedad
	controlled_node.velocity.y += gravity * delta
