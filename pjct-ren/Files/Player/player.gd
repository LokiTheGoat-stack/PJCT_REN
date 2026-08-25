extends CharacterBody2D
class_name Player


@onready var body: Sprite2D = $Ren_Sprites

@onready var body2: Sprite2D = $TestPlayerSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: PlayerStateMachine = $StateMachine

#var states:PlayerStateNames = PlayerStateNames.new()
#var animations:PlayerAnimations = PlayerAnimations.new()

func set_facing_direction() -> void:
	#control de donde mira el personaje
	if self.velocity.x < 0:
		body.flip_h = true
		body2.flip_h = true
	elif self.velocity.x > 0:
		body.flip_h = false
		body2.flip_h = false

func _process(_delta):
	set_facing_direction()
	
	#detectar si el jugador murio
	if PlayerStatsComponent.is_death == true:
		state_machine.can_change = false
		state_machine.current_state = get_node("PlayerStateDeath")
		state_machine.state_start()
	
