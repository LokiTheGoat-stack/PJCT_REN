extends PlayerStateBase

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_animation_play: bool = false
var combo_count: int = 0
var can_press_attack: bool = false
var direction_x: float
var speed: float = 0

#region AWAYS_ON_FUNC
func on_physics_process(delta) -> void:
	controlled_node.velocity.y = 20
	controlled_node.velocity.x = direction_x * speed
	
	handle_gravity(delta)
	controlled_node.move_and_slide()

func on_input(event: InputEvent) -> void:
	#Continuar Combo
	if Input.is_action_just_pressed("ATTACK") and can_press_attack == true:
		match combo_count:
			0:
				attack_1()
			1:
				attack_2()
			_: pass
		combo_count += 1
#endregion

#region ATTACK_FUNC
func start_attack(x:float): #activador inicial
	velocity(x,1000)
	attack_0()

func attack_0(): #control del ataque 0
	play_animation("Attack_0")
	await $"../../AnimationPlayer2".animation_finished
	can_press_attack = true
	await get_tree().create_timer(0.35).timeout
	if can_press_attack == true:
		can_press_attack = false
		state_machine.change_to("PlayerStateFall")
		combo_count = 0
		$"../PlayerStateFall".can_attack = false

func attack_1(): #control del ataque 1
	velocity(0,1000)
	can_press_attack = false
	play_animation("Attack_1")
	await $"../../AnimationPlayer2".animation_finished
	can_press_attack = true
	await get_tree().create_timer(0.35).timeout
	if can_press_attack == true:
		can_press_attack = false
		state_machine.change_to("PlayerStateFall")
		combo_count = 0
		$"../PlayerStateFall".can_attack = false

func attack_2(): #control del ataque 2
	velocity(0,2000)
	can_press_attack = false
	play_animation("Attack_2")
	await $"../../AnimationPlayer2".animation_finished
	can_press_attack = false
	state_machine.change_to("PlayerStateFall")
	combo_count = 0
	$"../PlayerStateFall".can_attack = false

func velocity(x:float, spd: float): #control de impulso
	if x != 0:
		direction_x = x
		speed = spd
	else:
		if $"../../Ren_Sprite".flip_h == true:
			direction_x = -1
			speed = spd
		else:
			direction_x = 1
			speed = spd
	await get_tree().create_timer(0.03).timeout
	speed = 0

#endregion

func play_animation(animation:String) -> void: #control de animacion
	is_animation_play = true
	#$"../../AnimationPlayer2".play(animation)

func handle_gravity(delta) -> void: #control de gravedad
	controlled_node.velocity.y += gravity * delta
