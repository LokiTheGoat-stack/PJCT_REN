extends PlayerStateBase

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var movement_enabled = false

#region ALWAYS_ON_FUNC
func on_physics_process(delta) -> void:
	#Control de la direccion del personaje
	
	if (movement_enabled):
		controlled_node.velocity.x = Input.get_axis("LEFT", "RIGHT") * PlayerMovementStats.running_speed
	
	#if is_animation_play == false: play_animation()
	
	#Si no hay piso cambiar a Fall
	if controlled_node.is_on_floor() == false:
		controlled_node.animation_machine.travel("Fall_Down")
		state_machine.change_to("PlayerStateFall")
		$"../PlayerStateFall"._last_chance_to_jump()
	
	handle_gravity(delta)
	controlled_node.move_and_slide()

func on_input(event: InputEvent) -> void:
	#Si no esta caminando cambiar a Idle
	if not Input.is_action_pressed("LEFT") and not Input.is_action_pressed("RIGHT"):
		controlled_node.animation_machine.travel("Idle")
		state_machine.change_to("PlayerStateIdle")
	
	#Cambiar a Jump
	if Input.is_action_just_pressed("JUMP"): 
		controlled_node.animation_machine.travel("Jump_Up")
		controlled_node.velocity.y = PlayerMovementStats.jump_speed
		state_machine.change_to("PlayerStateJump")
		PlayerMovementStats.jump_count += 1
	
	#Cambiar a Dash
	if Input.is_action_just_pressed("DASH"):
		state_machine.change_to("PlayerStateDash")
		$"../PlayerStateDash".dash("PlayerStateWalk")
	
	#Cambiar a Attack
	if Input.is_action_just_pressed("ATTACK") and Input.is_action_pressed("LEFT"):
		state_machine.change_to("PlayerStateGroundAttack")
		$"../PlayerStateGroundAttack".start_attack(-1)
	if Input.is_action_just_pressed("ATTACK") and Input.is_action_pressed("RIGHT"):
		state_machine.change_to("PlayerStateGroundAttack")
		$"../PlayerStateGroundAttack".start_attack(1)
	
	#Cambiar a Block
	if Input.is_action_pressed("BLOCK"):
		state_machine.change_to("PlayerStateBlock")
#endregion

func play_footsteps(footstep: bool):
	if footstep:
		print('footsetp')
		$"../../Footstep_Sounds".play()
		footstep = false

func check_can_move(can_move: bool):
	movement_enabled = can_move

func handle_gravity(delta) -> void: #control de gravedad
	controlled_node.velocity.y += gravity * delta

func end():
	movement_enabled = false
