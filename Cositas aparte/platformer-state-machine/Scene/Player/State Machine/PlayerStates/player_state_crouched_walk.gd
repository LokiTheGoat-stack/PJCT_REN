extends StateBase

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_animation_play: bool = false

func on_physics_process(delta) -> void:
	controlled_node.velocity.x = Input.get_axis("LEFT", "RIGHT") * PlayerMovementStats.running_speed
	
	if is_animation_play == false: play_animation()
	
	if controlled_node.is_on_floor() == false:
		state_machine.change_to("PlayerStateFall")
		is_animation_play = false
	
	handle_gravity(delta)
	controlled_node.move_and_slide()

func play_animation() -> void:
	is_animation_play = true
	$"../../PlayerSpriteJump".visible = false
	$"../../PlayerSpriteWalk".visible = true
	$"../../AnimationPlayer".play("Crouched_Walk")

func handle_gravity(delta) -> void:
	controlled_node.velocity.y += gravity * delta

func on_input(event: InputEvent) -> void:
	if not Input.is_action_pressed("LEFT") and not Input.is_action_pressed("RIGHT"):
		state_machine.change_to("PlayerStateCrouchedIdle")
		is_animation_play = false
	if Input.is_action_just_pressed("JUMP"): 
		state_machine.change_to("PlayerStateJump")
		PlayerMovementStats.jump_count += 1
		is_animation_play = false
	if not Input.is_action_just_pressed("DOWN"):
		state_machine.change_to("PlayerStateIdle")
		is_animation_play = false
