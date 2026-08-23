extends StateBase

@onready var raycast_right: RayCast2D = $"../../PlayerRayCast/Wall_RayCast_Right"
@onready var raycast_left: RayCast2D = $"../../PlayerRayCast/Wall_RayCast_Left"

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_animation_play: bool = false
var is_on_wall = true
var wall_normal = Vector2.ZERO

func on_physics_process(delta) -> void:
	controlled_node.velocity.x = 0
	controlled_node.velocity.y = PlayerMovementStats.wall_slide_speed
	if is_animation_play == false: play_animation()
	
	raycast_left.target_position = Vector2(-15, 0)
	raycast_right.target_position = Vector2(15, 0)
	is_on_wall = false
	if raycast_left.is_colliding():
		is_on_wall = true
		wall_normal = Vector2.RIGHT
	elif raycast_right.is_colliding():
		is_on_wall = true
		wall_normal = Vector2.LEFT
	
	if controlled_node.is_on_floor():
		state_machine.change_to("PlayerStateIdle")
		is_animation_play = false
	elif not controlled_node.is_on_floor() and is_on_wall == false:
		state_machine.change_to("PlayerStateFall")
		is_animation_play = false
	
	handle_gravity(delta)
	controlled_node.move_and_slide()

func play_animation() -> void:
	is_animation_play = true
	$"../../PlayerSpriteJump".visible = true
	$"../../PlayerSpriteWalk".visible = false
	$"../../AnimationPlayer".play("Wall_Slide")

func handle_gravity(delta) -> void:
	controlled_node.velocity.y += gravity * delta

func on_input(event: InputEvent) -> void:
	if Input.is_action_pressed("LEFT") or Input.is_action_pressed("RIGHT"):
		state_machine.change_to("PlayerStateWalk")
		is_animation_play = false
	if Input.is_action_just_pressed("JUMP") and not controlled_node.is_on_floor(): 
		state_machine.change_to("PlayerStateWall_Jump")
		$"../PlayerStateWall_Jump".wall_normal = wall_normal
		PlayerMovementStats.jump_count = 1
		is_animation_play = false
