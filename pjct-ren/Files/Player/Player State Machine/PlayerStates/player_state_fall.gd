extends PlayerStateBase

@onready var raycast_right: RayCast2D = $"../../PlayerRayCast/Wall_RayCast_Right"
@onready var raycast_left: RayCast2D = $"../../PlayerRayCast/Wall_RayCast_Left"

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_animation_play: bool = false
var is_on_wall = false
var wall_normal = Vector2.ZERO
var last_chance_to_jump: bool = false

func _last_chance_to_jump():
	last_chance_to_jump = true
	await get_tree().create_timer(0.09).timeout
	last_chance_to_jump = false

func on_physics_process(delta):
	controlled_node.velocity.y = 425
	controlled_node.velocity.x = \
	Input.get_axis("LEFT", "RIGHT") * PlayerMovementStats.in_air_speed
	
	if is_animation_play == false: play_animation()
	
	raycast_left.target_position = Vector2(-15, 0)
	raycast_right.target_position = Vector2(15, 0)
	is_on_wall = false
	if raycast_left.is_colliding() and controlled_node.velocity.x < 0:
		is_on_wall = true
		print("Left Colliding")
		wall_normal = Vector2.RIGHT
	elif raycast_right.is_colliding() and controlled_node.velocity.x > 0:
		is_on_wall = true
		print("Right Colliding")
		wall_normal = Vector2.LEFT
	
	if is_on_wall and not controlled_node.is_on_floor():
		$"../PlayerStateWall_Slide".wall_normal = wall_normal
		state_machine.change_to("PlayerStateWall_Slide")
		is_animation_play = false
	
	if controlled_node.velocity.y >= 0 and controlled_node.is_on_floor():
		if Input.is_action_pressed("LEFT") or Input.is_action_pressed("RIGHT"):
			state_machine.change_to("PlayerStateWalk")
		else: state_machine.change_to("PlayerStateIdle")
		PlayerMovementStats.jump_count = 0
		is_animation_play = false
	
	handle_gravity(delta)
	controlled_node.move_and_slide()

func play_animation() -> void:
	is_animation_play = true
	$"../../AnimationPlayer".play("Fall")

func handle_gravity(delta) -> void:
	controlled_node.velocity.y += gravity * delta

func on_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("JUMP") and last_chance_to_jump == true: 
		state_machine.change_to("PlayerStateJump")
		PlayerMovementStats.jump_count += 1
		is_animation_play = false
	elif Input.is_action_just_pressed("JUMP") and PlayerMovementStats.jump_count == 1: 
		state_machine.change_to("PlayerStateJump")
		PlayerMovementStats.jump_count += 1
		is_animation_play = false
	if Input.is_action_just_pressed("DASH"):
		state_machine.change_to("PlayerStateDash")
		$"../PlayerStateDash".dash("PlayerStateFall")
		is_animation_play = false
