extends PlayerStateBase

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#region AWAYS_ON_FUNC
func on_physics_process(delta) -> void:
	controlled_node.velocity.x = 0
	
	#if is_animation_play == false: play_animation()
	
	# Si no estas en el piso cambiar al estado Fall
	if controlled_node.is_on_floor() == false:
		controlled_node.animation_machine.travel("Fall_Down")
		state_machine.change_to("PlayerStateFall")
	
	handle_gravity(delta)
	controlled_node.move_and_slide()

func on_input(event: InputEvent) -> void:
	#Cambiar a Walk
	if Input.is_action_pressed("LEFT") or Input.is_action_pressed("RIGHT"):
		controlled_node.animation_machine.travel("Run")
		state_machine.change_to("PlayerStateWalk")
	
	#Cambiar a Jump
	if Input.is_action_just_pressed("JUMP"):
		controlled_node.animation_machine.travel("Jump_Up")
		controlled_node.velocity.y = PlayerMovementStats.jump_speed
		state_machine.change_to("PlayerStateJump")
		PlayerMovementStats.jump_count += 1
	
	#Cambiar a Dash
	if Input.is_action_just_pressed("DASH"):
		state_machine.change_to("PlayerStateDash")
		$"../PlayerStateDash".dash("PlayerStateIdle")
	
	#Cambiar a Attack
	if Input.is_action_just_pressed("ATTACK"):
		state_machine.change_to("PlayerStateGroundAttack")
		$"../PlayerStateGroundAttack".start_attack(0)
	
	#Cambiar a Block
	if Input.is_action_pressed("BLOCK"):
		state_machine.change_to("PlayerStateBlock")
#endregion

func handle_gravity(delta) -> void: #control de gravedad
	controlled_node.velocity.y += gravity * delta
