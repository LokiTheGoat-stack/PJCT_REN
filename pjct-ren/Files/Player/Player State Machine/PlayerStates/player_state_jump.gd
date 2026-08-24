extends PlayerStateBase

@onready var raycast_right: RayCast2D = $"../../PlayerRayCast/Wall_RayCast_Right"
@onready var raycast_left: RayCast2D = $"../../PlayerRayCast/Wall_RayCast_Left"
@onready var raycast_top: RayCast2D = $"../../PlayerRayCast/Top_RayCast"

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var valid_timer: bool = false
var is_animation_play: bool = false
var is_on_wall = false
var wall_normal = Vector2.ZERO

#region ALWAYS_ON_FUNC
func on_physics_process(delta) -> void:
	#control de direccion del salto (Eje x,y)
	controlled_node.velocity.y = PlayerMovementStats.jump_speed
	controlled_node.velocity.x = Input.get_axis("LEFT","RIGHT") * PlayerMovementStats.in_air_speed
	
	#control del tipo de salto
	if valid_timer == false and PlayerMovementStats.jump_count == 1: start_jump_timer()
	elif valid_timer == false and PlayerMovementStats.jump_count == 2: doble_jump_timer()
	if is_animation_play == false: play_animation()
	
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
		valid_timer = false
		state_machine.change_to("PlayerStateFall")
		is_animation_play = false
	
	#si estas pegado a una pared y no estas tocando el suelo cambiar a Wall_Slide
	elif is_on_wall and not controlled_node.is_on_floor():
		valid_timer = false
		$"../PlayerStateWall_Slide".wall_normal = wall_normal
		state_machine.change_to("PlayerStateWall_Slide")
		is_animation_play = false
	
	handle_gravity(delta)
	controlled_node.move_and_slide()

func on_input(event: InputEvent) -> void:
	#Cambiar a Dash
	if Input.is_action_just_pressed("DASH"):
		state_machine.change_to("PlayerStateDash")
		$"../PlayerStateDash".dash("PlayerStateJump")
		is_animation_play = false
#endregion

func play_animation() -> void: #control de animacion
	is_animation_play = true
	$"../../AnimationPlayer".play("Jump")

func handle_gravity(delta) -> void: #control de gravedad
	controlled_node.velocity.y += gravity * delta

#JUMP_FUNC se encarga de gestionar el tipo de salto
#region JUMP_FUNC
func start_jump_timer() -> void:
	valid_timer = true
	await get_tree().create_timer(0.2).timeout
	if Input.is_action_pressed("JUMP"):
		extend_jump()
	else:
		if valid_timer == true: state_machine.change_to("PlayerStateFall")
		valid_timer = false
		is_animation_play = false

func extend_jump():
	await get_tree().create_timer(0.14).timeout
	if valid_timer == true: state_machine.change_to("PlayerStateFall")
	valid_timer = false
	is_animation_play = false

func doble_jump_timer():
	valid_timer = true
	await get_tree().create_timer(0.3).timeout
	if valid_timer == true: state_machine.change_to("PlayerStateFall")
	valid_timer = false
	is_animation_play = false
#endregion
