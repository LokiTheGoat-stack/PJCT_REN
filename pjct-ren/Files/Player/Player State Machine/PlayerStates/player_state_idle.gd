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
	#Cambiar a Walk
	if Input.is_action_pressed("LEFT") or Input.is_action_pressed("RIGHT"):
		state_machine.change_to("PlayerStateWalk")
		is_animation_play = false
	
	#Cambiar a Jump
	if Input.is_action_just_pressed("JUMP"): 
		state_machine.change_to("PlayerStateJump")
		PlayerMovementStats.jump_count += 1
		is_animation_play = false
	
	#Cambiar a Dash
	if Input.is_action_just_pressed("DASH"):
		state_machine.change_to("PlayerStateDash")
		$"../PlayerStateDash".dash("PlayerStateIdle")
		is_animation_play = false
	
	#Cambiar a Attack
	if Input.is_action_just_pressed("ATTACK"):
		state_machine.change_to("PlayerStateGroundAttack")
		$"../PlayerStateGroundAttack".start_attack(0)
		is_animation_play = false
	
	#Cambiar a Block
	if Input.is_action_pressed("BLOCK"):
		state_machine.change_to("PlayerStateBlock")
		is_animation_play = false
#endregion

func play_animation() -> void: #control de animacion
	is_animation_play = true
	$"../../AnimationPlayer".play("Idle")

func handle_gravity(delta) -> void: #control de gravedad
	controlled_node.velocity.y += gravity * delta
