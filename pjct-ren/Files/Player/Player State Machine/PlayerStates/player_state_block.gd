extends PlayerStateBase

@onready var stamina_bar: TextureProgressBar = $"../../HUD/StaminaBar"


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var last_state: String

func time_for_parry():
	PlayerStatsComponent.parry_time = true
	await get_tree().create_timer(0.2).timeout
	PlayerStatsComponent.parry_time = false

#region AWAYS_ON_FUNC
func on_physics_process(delta) -> void:
	controlled_node.velocity.x = 0
	
	#control de la caida de resistencia
	
	if PlayerStatsComponent.current_stamina > 0:PlayerStatsComponent.current_stamina -= 50 * delta
	elif PlayerStatsComponent.current_stamina <= 0:
		PlayerStatsComponent.current_stamina = 0
		stamina_bar.modulate = Color(1.0, 0.0, 0.0)
		match last_state:
			"PlayerStateIdle": controlled_node.animation_machine.travel("Idle")
			"PlayerStateWalk": controlled_node.animation_machine.travel("Run_Intro")
			_: pass
		state_machine.change_to(last_state)
	
	
	# Si no estas en el piso cambiar al estado Fall
	if controlled_node.is_on_floor() == false:
		state_machine.change_to("PlayerStateFall")
	
	handle_gravity(delta)
	controlled_node.move_and_slide()

func on_input(event: InputEvent) -> void:
	#Cambiar a Idle
	if not Input.is_action_pressed("BLOCK"):
		match last_state:
			"PlayerStateIdle": controlled_node.animation_machine.travel("Idle")
			"PlayerStateWalk": controlled_node.animation_machine.travel("Run")
			_: pass
		state_machine.change_to(last_state)
		PlayerMovementStats.is_block = false
	elif Input.is_action_pressed("BLOCK"): PlayerMovementStats.is_block = true
#endregion

func handle_gravity(delta) -> void: #control de gravedad
	controlled_node.velocity.y += gravity * delta

func charge_last_state(name:String):
	last_state = name
