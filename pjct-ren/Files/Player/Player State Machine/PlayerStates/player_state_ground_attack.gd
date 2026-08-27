extends PlayerStateBase

# --- CONSTANTES ---
const gravity = 980.0

# --- EXPORTS ---
@export var attack_duration: float = 0.3      # Duración de cada golpe
@export var combo_window: float = 0.6        # Tiempo para encadenar el siguiente golpe
@export var attack_dash_speed: float = 800.0  # Velocidad del pequeño impulso
@export var attack_dash_duration: float = 0.1 # Duración del impulso

var combo_count: int = 0
var can_combo: bool = true
var current_direction: int = 1
var is_attacking: bool = false
var attack_timer: float = 0.0
var combo_timer: float = 0.0
var dash_timer: float = 0.0
var is_dashing: bool = false

func _ready():
	pass

#examinar parametros del estado
func on_enter():
	combo_count = 0
	can_combo = true
	is_attacking = true
	attack_timer = 0.0
	combo_timer = 0.0
	is_dashing = false
	var sprite = controlled_node.get_node("Ren_Sprite")
	if sprite:
		current_direction = -1 if sprite.flip_h else 1
	execute_attack(0)

#resetear parametros para salir
func on_exit():
	is_attacking = false
	can_combo = false
	combo_count = 0
	is_dashing = false

func on_physics_process(delta: float) -> void:
	#control de gravedad
	if not controlled_node.is_on_floor():
		controlled_node.velocity.y += gravity * delta
	
	#impulso del ataque
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
			controlled_node.velocity.x = 0
	else:
		controlled_node.velocity.x = 0
	
	#actualizacion de timers
	attack_timer -= delta
	combo_timer -= delta
	
	#verificar si expiro el combo para pasar a idle
	if attack_timer <= 0 and is_attacking:
		if combo_timer <= 0:
			finish_attack()
	
	controlled_node.move_and_slide()
	
	# si caes cambiar a fall
	if not controlled_node.is_on_floor():
		state_machine.change_to("PlayerStateFall")

func on_input(event: InputEvent) -> void:
	#solo procesar input si se ataca
	if not is_attacking:
		return
	
	#inputs del ataque
	if event is InputEventKey or event is InputEventJoypadButton:
		if Input.is_action_just_pressed("ATTACK"):
			#encadenar combo
			if can_combo and combo_timer > 0:
				combo_count += 1
				if combo_count <= 2:
					execute_attack(combo_count)
				else:
					#terminar combo
					finish_attack()
			else:
				#combo fallido
				finish_attack()


func execute_attack(attack_index: int):
	combo_timer = combo_window
	
	is_dashing = false
	controlled_node.velocity.x = 0
	
	match attack_index:
		0:
			controlled_node.animation_machine.travel("Attack_1")
			attack_duration = 0.3
			apply_dash(current_direction, attack_dash_speed)
		1:
			controlled_node.animation_machine.travel("Attack_2")
			attack_duration = 0.35
			apply_dash(current_direction, attack_dash_speed * 1.1)
		2:
			controlled_node.animation_machine.travel("Attack_3")
			attack_duration = 0.4
			apply_dash(current_direction, attack_dash_speed * 1.3)
		_:
			pass
	
	attack_timer = attack_duration
	
	if attack_index == 2:
		can_combo = false
		await get_tree().create_timer(attack_duration).timeout
		finish_attack()

func apply_dash(direction: int, speed: float):
	is_dashing = true
	controlled_node.velocity.x = direction * speed
	dash_timer = attack_dash_duration

func finish_attack(): #terminar combo
	is_attacking = false
	can_combo = false
	combo_count = 0
	is_dashing = false
	controlled_node.velocity.x = 0
	
	if controlled_node.is_on_floor():
		if Input.is_action_pressed("LEFT") or Input.is_action_pressed("RIGHT"):
			controlled_node.animation_machine.travel("Run")
			state_machine.change_to("PlayerStateWalk")
		else:
			state_machine.change_to("PlayerStateIdle")
	else:
		state_machine.change_to("PlayerStateFall")


func show_combo_effect():
	var label = Label.new()
	label.text = "x" + str(combo_count + 1) + " COMBO!"
	label.position = controlled_node.global_position - Vector2(0, 50)
	label.modulate = Color.YELLOW
	label.add_theme_font_size_override("font_size", 24)
	controlled_node.get_parent().add_child(label)
	
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 0.0, 0.8)
	tween.tween_callback(label.queue_free)
