extends PlayerStateBase

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_animation_play: bool = false

#region ALWAYS_ON_FUNC
func on_physics_process(delta) -> void:
	#Control de la direccion del personaje
	controlled_node.velocity.x = Input.get_axis("LEFT", "RIGHT") * PlayerMovementStats.running_speed
	
	if is_animation_play == false: play_animation()
	
	#Si no hay piso cambiar a Fall
	if controlled_node.is_on_floor() == false:
		state_machine.change_to("PlayerStateFall")
		$"../PlayerStateFall"._last_chance_to_jump()
		is_animation_play = false
	
	handle_gravity(delta)
	controlled_node.move_and_slide()

func on_input(event: InputEvent) -> void:
	#Si no esta caminando cambiar a Idle
	if not Input.is_action_pressed("LEFT") and not Input.is_action_pressed("RIGHT"):
		state_machine.change_to("PlayerStateIdle")
		is_animation_play = false
	
	#Cambiar a Jump
	if Input.is_action_just_pressed("JUMP"): 
		state_machine.change_to("PlayerStateJump")
		PlayerMovementStats.jump_count += 1
		is_animation_play = false
	
	#Cambiar a Dash
	if Input.is_action_just_pressed("DASH"):
		state_machine.change_to("PlayerStateDash")
		$"../PlayerStateDash".dash("PlayerStateWalk")
		is_animation_play = false
#endregion

func play_animation() -> void: #Control de animacion
	is_animation_play = true
	$"../../AnimationPlayer".play("Walk")

func handle_gravity(delta) -> void: #control de gravedad
	controlled_node.velocity.y += gravity * delta
