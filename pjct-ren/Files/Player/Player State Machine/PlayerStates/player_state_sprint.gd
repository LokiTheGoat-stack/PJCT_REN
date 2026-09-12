extends PlayerStateBase

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var phantom_on: bool = false

#region ALWAYS_ON_FUNC
func on_physics_process(delta) -> void:
	#Control de la direccion del personaje
	
	controlled_node.velocity.x = Input.get_axis("LEFT", "RIGHT") * (PlayerMovementStats.running_speed * 1.5)
	
	#Si no hay piso cambiar a Fall
	if not controlled_node.is_on_floor() and controlled_node.velocity.y > 0:
		print("walk_fall")
		controlled_node.animation_machine.travel("Fall_Down")
		state_machine.change_to("PlayerStateFall")
		$"../PlayerStateFall"._last_chance_to_jump()
		phantom_on = false
	
	
	handle_gravity(delta)
	controlled_node.move_and_slide()

func on_input(event: InputEvent) -> void:
	#Si no esta caminando cambiar a Idle
	if not Input.is_action_pressed("LEFT") and not Input.is_action_pressed("RIGHT"):
		controlled_node.animation_machine.travel("Idle")
		state_machine.change_to("PlayerStateIdle")
		phantom_on = false
	
	#Cambiar a Jump
	if Input.is_action_just_pressed("JUMP"):
		print("walk_jump")
		PlayerMovementStats.jump_count += 1
		controlled_node.velocity.y = PlayerMovementStats.jump_speed
		$"../PlayerStateJump".x_speed = PlayerMovementStats.in_air_speed * 2
		controlled_node.animation_machine.travel("Jump_Up")
		state_machine.change_to("PlayerStateJump")
		phantom_on = false
	
	if PlayerStatsComponent.current_stamina > 0:
		#Cambiar a Dash
		if Input.is_action_just_pressed("DASH"):
			state_machine.change_to("PlayerStateDash")
			$"../PlayerStateDash".dash("PlayerStateWalk",false,true)
			phantom_on = false
		
		#Cambiar a Attack
		if Input.is_action_just_pressed("ATTACK") and PlayerStatsComponent.can_attack:
			state_machine.change_to("PlayerStateAttack")
			$"../PlayerStateAttack".on_enter(false,"normal")
			phantom_on = false
		
		#Cambiar a Block
		if Input.is_action_pressed("BLOCK") and PlayerStatsComponent.can_attack:
			$"../PlayerStateBlock".charge_last_state("PlayerStateWalk")
			state_machine.change_to("PlayerStateBlock")
			$"../PlayerStateBlock".time_for_parry()
			phantom_on = false
#endregion

func phantom_animation():
	while true:
		await get_tree().create_timer(0.02).timeout
		add_phantom()
		if phantom_on == false: 
			break

func add_phantom():
	var tween: Tween = create_tween()
	var phantom: Sprite2D = Sprite2D.new()
	phantom.texture = controlled_node.ren_sprite.texture
	phantom.hframes = controlled_node.ren_sprite.hframes
	phantom.vframes = controlled_node.ren_sprite.vframes
	phantom.frame = controlled_node.ren_sprite.frame
	phantom.centered = true
	phantom.scale.x = controlled_node.ren_sprite.scale.x
	if controlled_node.ren_sprite.flip_h: phantom.flip_h = true
	phantom.global_position = controlled_node.global_position
	phantom.modulate = Color(0.27, 0.27, 0.27, 1.0)
	controlled_node.get_parent().add_child(phantom)
	phantom.z_index = 0
	tween.tween_property(phantom, "modulate", Color(1.0,1.0,1.0,0.0), 0.2)
	tween.tween_callback(phantom.queue_free)
	tween.tween_callback(tween.kill)

func handle_gravity(delta) -> void: #control de gravedad
	controlled_node.velocity.y += gravity * delta
