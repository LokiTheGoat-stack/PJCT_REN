extends PlayerStateBase

@onready var raycast_right: RayCast2D = $"../../PlayerRayCast/Wall_RayCast_Right"
@onready var raycast_left: RayCast2D = $"../../PlayerRayCast/Wall_RayCast_Left"

var gravity: float = 0.0
var is_on_wall = false
var wall_normal = Vector2.ZERO
var last_chance_to_jump: bool = false
var can_attack: bool = true

#control del delay del salto
func _last_chance_to_jump():
	last_chance_to_jump = true
	await get_tree().create_timer(0.09).timeout
	last_chance_to_jump = false

#region ALWAYS_ON_FUNC
func on_physics_process(delta):
	#control de direccion de la caida (Eje x,y)
	controlled_node.velocity.y += gravity * delta
	controlled_node.velocity.x = \
	Input.get_axis("LEFT","RIGHT") * PlayerMovementStats.in_air_speed
	
	#control de la gravedad durante la caida
	if controlled_node.velocity.y > 0:
		gravity = PlayerMovementStats.gravity_hig
	elif controlled_node.velocity.y == 0:
		gravity = PlayerMovementStats.gravity_low
	
	
	#if is_animation_play == false: play_animation()
	
	#control de colision del raycast
	raycast_left.target_position = Vector2(-15, 0)
	raycast_right.target_position = Vector2(15, 0)
	is_on_wall = false
	if raycast_left.is_colliding() and controlled_node.velocity.x < 0:
		is_on_wall = true
		wall_normal = Vector2.RIGHT
	elif raycast_right.is_colliding() and controlled_node.velocity.x > 0:
		is_on_wall = true
		wall_normal = Vector2.LEFT
	
	#si estas pegado a una pared y no estas tocando suelo cambiar a Wall_Slide
	if is_on_wall and not controlled_node.is_on_floor():
		$"../PlayerStateWall_Slide".wall_normal = wall_normal
		state_machine.change_to("PlayerStateWall_Slide")
		can_attack = true
	
	#si estas tocando el suelo cambiar a Walk o Idle
	if controlled_node.velocity.y >= 0 and controlled_node.is_on_floor():
		if Input.is_action_pressed("LEFT") or Input.is_action_pressed("RIGHT"):
			controlled_node.animation_machine.travel("Run")
			state_machine.change_to("PlayerStateWalk")
		else:
			controlled_node.animation_machine.travel("Idle")
			state_machine.change_to("PlayerStateIdle")
		PlayerMovementStats.jump_count = 0
		can_attack = true
	
	controlled_node.move_and_slide()

func on_input(event: InputEvent) -> void:
	#Si despues al caer saltas antes de los 0.09s, cambiar a Jump
	if Input.is_action_just_pressed("JUMP") and last_chance_to_jump == true:
		controlled_node.animation_machine.travel("Jump_Up") 
		controlled_node.velocity.y = PlayerMovementStats.jump_speed
		state_machine.change_to("PlayerStateJump")
		PlayerMovementStats.jump_count += 1
	
	#Hacer doble salto
	elif Input.is_action_just_pressed("JUMP") and PlayerMovementStats.jump_count == 1:
		controlled_node.animation_machine.travel("Jump_Up") 
		state_machine.change_to("PlayerStateJump")
		PlayerMovementStats.jump_count += 1
	
	#Cambiar a Dash
	if Input.is_action_just_pressed("DASH"):
		state_machine.change_to("PlayerStateDash")
		$"../PlayerStateDash".dash("PlayerStateFall")
	
	#Cambiar a Attack
	if Input.is_action_just_pressed("ATTACK") and can_attack == true:
		state_machine.change_to("PlayerStateAirAttack")
		$"../PlayerStateAirAttack".start_attack(0)
#endregion
