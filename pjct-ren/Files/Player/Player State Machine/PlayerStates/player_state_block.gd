extends PlayerStateBase

@onready var mana_bar: TextureProgressBar = $"../../HUD/manaBar"

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_animation_play: bool = false
var last_state: String

func time_for_parry():
	PlayerStatsComponent.parry_time = true
	await get_tree().create_timer(0.2).timeout
	PlayerStatsComponent.parry_time = false

#region AWAYS_ON_FUNC
func on_physics_process(delta) -> void:
	controlled_node.velocity.x = 0
	
	#control de la caida de resistencia
	
	if PlayerStatsComponent.stamia > mana_bar.min_value:PlayerStatsComponent.stamia -= 50 * delta
	elif PlayerStatsComponent.stamia <= mana_bar.min_value:
		PlayerStatsComponent.stamia = 0
		mana_bar.modulate = Color(1.0, 0.0, 0.0)
		state_machine.change_to(last_state)
		is_animation_play = false 
	
	
	if is_animation_play == false: play_animation()
	
	# Si no estas en el piso cambiar al estado Fall
	if controlled_node.is_on_floor() == false:
		state_machine.change_to("PlayerStateFall")
		is_animation_play = false
	
	handle_gravity(delta)
	controlled_node.move_and_slide()

func on_input(event: InputEvent) -> void:
	#Cambiar a Idle
	if not Input.is_action_pressed("BLOCK"):
		state_machine.change_to(last_state)
		is_animation_play = false
		PlayerMovementStats.is_block = false
	elif Input.is_action_pressed("BLOCK"): PlayerMovementStats.is_block = true
#endregion

func play_animation() -> void: #control de animacion
	is_animation_play = true
	#$"../../AnimationPlayer".play("Block")

func handle_gravity(delta) -> void: #control de gravedad
	controlled_node.velocity.y += gravity * delta

func charge_last_state(name:String):
	last_state = name
