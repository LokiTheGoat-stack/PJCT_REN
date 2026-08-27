extends CharacterBody2D
class_name Player


@onready var body: Sprite2D = $Ren_Sprites
@onready var ren_sprite: Sprite2D = $Ren_Sprite
@onready var body2: Sprite2D = $TestPlayerSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_machine: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]
@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var sounds: PlayerSounds = $Sounds


var phantom_on: bool = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("PARTY") and phantom_on == false:
		phantom_on = true
		start_party()

#region PARTY_MODE
func start_party():
	animated_color()
	phantom_animation()

func animated_color():
	var tween: Tween = create_tween()
	tween.tween_method(change_tone, 0.0, 1.0, 2.0)
	tween.set_loops()

func change_tone(value: float):
	var hsv = Color.from_hsv(value, 0.8, 0.9)
	ren_sprite.modulate = hsv
	$"../Tileset".modulate = hsv

func phantom_animation():
	while true:
		await get_tree().create_timer(0.06).timeout
		add_phantom()
		if phantom_on == false: 
			break

func add_phantom():
	var tween: Tween = create_tween()
	var phantom: Sprite2D = Sprite2D.new()
	phantom.texture = ren_sprite.texture
	phantom.hframes = ren_sprite.hframes
	phantom.vframes = ren_sprite.vframes
	phantom.frame = ren_sprite.frame
	phantom.centered = true
	if ren_sprite.flip_h: phantom.flip_h = true
	phantom.global_position = global_position
	phantom.modulate = ren_sprite.modulate
	get_parent().add_child(phantom)
	phantom.z_index = 0
	tween.tween_property(phantom, "modulate", Color(1.0,1.0,1.0,0.0), 0.5)
	tween.tween_callback(phantom.queue_free)
	tween.tween_callback(tween.kill)
#endregion

func set_facing_direction() -> void:
	#control de donde mira el personaje
	if self.velocity.x < 0:
		ren_sprite.flip_h = true
	elif self.velocity.x > 0:
		ren_sprite.flip_h = false

func _process(_delta):
	set_facing_direction()
	
	#detectar si el jugador murio
	if PlayerStatsComponent.is_death == true:
		state_machine.can_change = false
		state_machine.current_state = get_node("PlayerStateDeath")
		state_machine.state_start()
	
