extends PlayerStateBase

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var min_speed: float = 100

#region ALWAYS_ON_FUNC
func on_physics_process(delta) -> void:
	#Control de la direccion del personaje
	
	controlled_node.velocity.x = Input.get_axis("LEFT", "RIGHT") * min_speed
	if min_speed < PlayerMovementStats.running_speed: min_speed += 500 * delta
	
	#Si no hay piso cambiar a Fall
	if controlled_node.is_on_floor() == false:
		min_speed = 0
		controlled_node.animation_machine.travel("Fall_Down")
		state_machine.change_to("PlayerStateFall")
		$"../PlayerStateFall"._last_chance_to_jump()
	
	handle_gravity(delta)
	controlled_node.move_and_slide()

func on_input(event: InputEvent) -> void:
	#Si no esta caminando cambiar a Idle
	if not Input.is_action_pressed("LEFT") and not Input.is_action_pressed("RIGHT"):
		min_speed = 0
		controlled_node.animation_machine.travel("Idle")
		state_machine.change_to("PlayerStateIdle")
	
	#Cambiar a Jump
	if Input.is_action_just_pressed("JUMP"):
		min_speed = 0
		PlayerMovementStats.jump_count += 1
		controlled_node.velocity.y = PlayerMovementStats.jump_speed
		controlled_node.animation_machine.travel("Jump_Up")
		state_machine.change_to("PlayerStateJump")
	
	if PlayerStatsComponent.stamia > 0:
		#Cambiar a Dash
		if Input.is_action_just_pressed("DASH"):
			min_speed = 0
			state_machine.change_to("PlayerStateDash")
			$"../PlayerStateDash".dash("PlayerStateWalk",false)
		
		#Cambiar a Attack
		if Input.is_action_just_pressed("ATTACK"):
			min_speed = 0
			state_machine.change_to("PlayerStateAttack")
			$"../PlayerStateAttack".on_enter(false)
		
		#Cambiar a Block
		if Input.is_action_pressed("BLOCK"):
			min_speed = 0
			$"../PlayerStateBlock".charge_last_state("PlayerStateWalk")
			state_machine.change_to("PlayerStateBlock")
			$"../PlayerStateBlock".time_for_parry()
#endregion


func handle_gravity(delta) -> void: #control de gravedad
	controlled_node.velocity.y += gravity * delta
