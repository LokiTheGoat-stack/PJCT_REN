extends PlayerStateBase

@onready var raycast_right: RayCast2D = $"../../PlayerRayCast/Wall_RayCast_Right"
@onready var raycast_left: RayCast2D = $"../../PlayerRayCast/Wall_RayCast_Left"

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var valid_timer: bool = false
var can_fall: bool = false
var is_on_wall = false
var wall_normal = Vector2.ZERO
var climb: bool = false

#region ALWAYS_ON_FUNC
func on_physics_process(delta) -> void:
	#control de direccion del salto
	controlled_node.velocity.y += gravity * delta
	if not climb: controlled_node.velocity.x = wall_normal.x * PlayerMovementStats.wall_jump_speed
	else: controlled_node.velocity.x = 0
	
	#control de gravedad en el salto (Eje y)
	if controlled_node.velocity.y < 0:
		if can_fall == true:
			gravity = PlayerMovementStats.gravity_release
		else: gravity = PlayerMovementStats.gravity_low
	
	elif controlled_node.velocity.y > 0:
		can_fall = false
		controlled_node.animation_machine.travel("Fall_Down")
		state_machine.change_to("PlayerStateFall")
	
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
	
	#verifivar si se puede hacer Wall_Slide o si se llego a la tope para escalar
	if climb: new_climb_peak_verification()
	new_wall_slide_verification()
	
	handle_gravity(delta)
	controlled_node.move_and_slide()
	#endregion


func on_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("DASH"):
			state_machine.change_to("PlayerStateDash")
			$"../PlayerStateDash".dash("PlayerStateJump",false,false)


func new_wall_slide_verification(): #verifivar si se puede hacer Wall_Slide 
		await get_tree().create_timer(0.1).timeout
		if is_on_wall and not controlled_node.is_on_floor():
			$"../PlayerStateWall_Slide".wall_normal = wall_normal
			state_machine.change_to("PlayerStateWall_Slide")

func new_climb_peak_verification(): #verificar si ya no se puede escalar
	await get_tree().create_timer(0.05).timeout
	if not is_on_wall:
		can_fall = false
		controlled_node.animation_machine.travel("Fall_Down")
		state_machine.change_to("PlayerStateFall")

func handle_gravity(delta) -> void: #control de gravedad
	controlled_node.velocity.y += gravity * delta
