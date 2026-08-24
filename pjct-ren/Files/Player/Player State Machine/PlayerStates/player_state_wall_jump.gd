extends PlayerStateBase

@onready var raycast_right: RayCast2D = $"../../PlayerRayCast/Wall_RayCast_Right"
@onready var raycast_left: RayCast2D = $"../../PlayerRayCast/Wall_RayCast_Left"

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var valid_timer: bool = false
var is_animation_play: bool = false
var is_on_wall = false
var wall_normal = Vector2.ZERO

#region ALWAYS_ON_FUNC
func on_physics_process(delta) -> void:
	#control de direccion del salto
	controlled_node.velocity.y = PlayerMovementStats.jump_speed
	controlled_node.velocity.x = wall_normal.x * PlayerMovementStats.wall_jump_speed
	
	#control de colision del raycast
	raycast_left.target_position = Vector2(-15, 0)
	raycast_right.target_position = Vector2(15, 0)
	is_on_wall = false
	if raycast_left.is_colliding():
		is_on_wall = true
		wall_normal = Vector2.RIGHT
	elif raycast_right.is_colliding():
		is_on_wall = true
		wall_normal = Vector2.LEFT
	
	#verifivar si se puede hacer Wall_Slide
	new_verification()
	
	handle_gravity(delta)
	controlled_node.move_and_slide()
	if valid_timer == false: start_jump_timer()
	if is_animation_play == false: play_animation()
	#endregion

func new_verification(): #verifivar si se puede hacer Wall_Slide 
	await get_tree().create_timer(0.1).timeout
	if is_on_wall and not controlled_node.is_on_floor():
		$"../PlayerStateWall_Slide".wall_normal = wall_normal
		state_machine.change_to("PlayerStateWall_Slide")

func start_jump_timer() -> void: #control de duracion del salto
	valid_timer = true
	await get_tree().create_timer(0.3).timeout
	if valid_timer == true: state_machine.change_to("PlayerStateFall")
	valid_timer = false
	is_animation_play = false

func play_animation() -> void: #control de animaciones
	is_animation_play = true
	$"../../AnimationPlayer".play("Jump")

func handle_gravity(delta) -> void: #control de gravedad
	controlled_node.velocity.y += gravity * delta
