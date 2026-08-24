extends PlayerStateBase

@onready var raycast_right: RayCast2D = $"../../PlayerRayCast/Wall_RayCast_Right"
@onready var raycast_left: RayCast2D = $"../../PlayerRayCast/Wall_RayCast_Left"
@onready var raycast_top: RayCast2D = $"../../PlayerRayCast/Top_RayCast"

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var valid_timer: bool = false
var is_animation_play: bool = false
var is_on_wall = false
var wall_normal = Vector2.ZERO

func on_physics_process(delta) -> void:
	controlled_node.velocity.y = PlayerMovementStats.jump_speed
	controlled_node.velocity.x = Input.get_axis("LEFT", "RIGHT") * PlayerMovementStats.in_air_speed
	
	if valid_timer == false: start_jump_timer()
	if is_animation_play == false: play_animation()
	
	raycast_left.target_position = Vector2(-15, 0)
	raycast_right.target_position = Vector2(15, 0)
	is_on_wall = false
	if raycast_left.is_colliding() and controlled_node.velocity.x < 0:
		is_on_wall = true
		wall_normal = Vector2.RIGHT
	elif raycast_right.is_colliding() and controlled_node.velocity.x > 0:
		is_on_wall = true
		wall_normal = Vector2.LEFT
	
	if raycast_top.is_colliding() and not controlled_node.is_on_floor():
		valid_timer = false
		state_machine.change_to("PlayerStateFall")
		is_animation_play = false
	elif is_on_wall and not controlled_node.is_on_floor():
		valid_timer = false
		$"../PlayerStateWall_Slide".wall_normal = wall_normal
		state_machine.change_to("PlayerStateWall_Slide")
		is_animation_play = false
	
	handle_gravity(delta)
	controlled_node.move_and_slide()

func play_animation() -> void:
	is_animation_play = true
	$"../../AnimationPlayer".play("Jump")

func handle_gravity(delta) -> void:
	controlled_node.velocity.y += gravity * delta

func start_jump_timer() -> void:
	valid_timer = true
	await get_tree().create_timer(0.3).timeout
	if valid_timer == true: state_machine.change_to("PlayerStateFall")
	valid_timer = false
	is_animation_play = false

func on_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("DASH"):
		state_machine.change_to("PlayerStateDash")
		$"../PlayerStateDash".dash("PlayerStateJump")
		is_animation_play = false
