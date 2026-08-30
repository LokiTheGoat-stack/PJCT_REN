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

func _ready() -> void:
	add_to_group("Player")

func _process(_delta):
	set_facing_direction()
	
	#detectar si el jugador murio
	if PlayerStatsComponent.is_death == true:
		state_machine.can_change = false
		state_machine.current_state = get_node("PlayerStateDeath")
		state_machine.state_start()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("PARTY") and phantom_on == false:
		phantom_on = true
		start_party()

func set_facing_direction() -> void:
	#control de donde mira el personaje
	if self.velocity.x < 0:
		ren_sprite.flip_h = true
	elif self.velocity.x > 0:
		ren_sprite.flip_h = false

#region BODY_CALL
func take_damage(damage, node): #control del damage
	await get_tree().create_timer(0.1).timeout
	if not PlayerMovementStats.is_dash and PlayerStatsComponent.can_recive_damage:
		if PlayerMovementStats.is_block and PlayerStatsComponent.stamia > 0:
			if damage < 30: PlayerStatsComponent.stamia -= damage * 1.5
			elif damage >= 30 and damage < 50: PlayerStatsComponent.stamia -= 40
			elif damage >= 50: PlayerStatsComponent.stamia -= 50
			PlayerStatsComponent.current_hp -= (damage * 10) / 100
		else: PlayerStatsComponent.current_hp -= damage
	if PlayerStatsComponent.parry_time: 
		node.take_damage(damage * 5, self)
		show_combo_effect(damage * 5,node)

func stamina_gift(): #aumento de stamina por parry
	PlayerStatsComponent.stamia += 50

func execute_parry():
	PlayerStatsComponent.can_recive_damage = false
	await activate_slow_motion(0.3,0.2)
	PlayerStatsComponent.can_recive_damage = true
#endregion

#region SIGNALS
#colision de los ataques
func _on_attack_area_body_entered(body: Node2D) -> void:
	$Sounds.flesh_slice()
	show_combo_effect(PlayerStatsComponent.damage,body)
	body.take_damage(PlayerStatsComponent.damage,self)
func _on_attack_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemie_Bullet") and area.can_parry:
		area.counter(self)
#endregion

#region USEFUL

func activate_slow_motion(duration:float, scale:float):
	var original_scale = Engine.time_scale
	Engine.time_scale = scale
	await get_tree().create_timer(duration,false).timeout
	Engine.time_scale = original_scale

func show_combo_effect(damage:int,target):
	var label = Label.new()
	label.text = str(int(damage))
	label.position = target.global_position - Vector2(0, 50)
	label.modulate = Color.YELLOW
	label.add_theme_font_size_override("font_size", 24)
	get_parent().add_child(label)
	
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 0.0, 0.8)
	tween.tween_callback(label.queue_free)

#endregion

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
