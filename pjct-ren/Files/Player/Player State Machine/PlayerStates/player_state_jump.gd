extends PlayerStateBase

@onready var raycast_right: RayCast2D = $"../../PlayerRayCast/Wall_RayCast_Right"
@onready var raycast_left: RayCast2D = $"../../PlayerRayCast/Wall_RayCast_Left"
@onready var raycast_top: RayCast2D = $"../../PlayerRayCast/Top_RayCast"

var gravity: float = 0.0
var is_on_wall = false
var wall_normal = Vector2.ZERO
var jump_enabled: bool = false

#region ALWAYS_ON_FUNC
func on_physics_process(delta) -> void:
	#control de direccion del salto (Eje x, y)
	if jump_enabled:
		controlled_node.velocity.y += gravity * delta
		controlled_node.velocity.x = Input.get_axis("LEFT","RIGHT") * PlayerMovementStats.in_air_speed
		
	#control de gravedad en el salto (Eje y)
	if controlled_node.velocity.y < 0:
		if not Input.is_action_pressed("JUMP"):
			gravity = PlayerMovementStats.gravity_release
		else: gravity = PlayerMovementStats.gravity_low
	
	elif controlled_node.velocity.y > 0:
		check_can_jump(false)
		controlled_node.animation_machine.travel("Fall_Down")
		state_machine.change_to("PlayerStateFall")

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
	
	#si se toca techo cambiar a Fall
	if raycast_top.is_colliding() and not controlled_node.is_on_floor():
		check_can_jump(false)
		controlled_node.animation_machine.travel("Fall_Down")
		state_machine.change_to("PlayerStateFall")
	
	#si estas pegado a una pared y no estas tocando el suelo cambiar a Wall_Slide
	elif is_on_wall and not controlled_node.is_on_floor():
		check_can_jump(false)
		$"../PlayerStateWall_Slide".wall_normal = wall_normal
		state_machine.change_to("PlayerStateWall_Slide")
	
	controlled_node.move_and_slide()

func on_input(event: InputEvent) -> void:
	#Cambiar a Dash
	if Input.is_action_just_pressed("DASH"):
		check_can_jump(false)
		state_machine.change_to("PlayerStateDash")
		$"../PlayerStateDash".dash("PlayerStateJump")
	
	#Cambiar a Attack
	if Input.is_action_just_pressed("ATTACK"):
		check_can_jump(false)
		state_machine.change_to("PlayerStateAirAttack")
		$"../PlayerStateAirAttack".start_attack(0)
#endregion

func check_can_jump(can_jump:bool):
	jump_enabled = can_jump
	if can_jump: controlled_node.velocity.y = PlayerMovementStats.jump_speed

func play_animation() -> void: #control de animacion
	controlled_node.animation_machine.travel("Jump_Up")
