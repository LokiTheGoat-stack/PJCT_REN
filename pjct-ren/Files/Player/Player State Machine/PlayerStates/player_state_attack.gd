extends PlayerStateBase

const gravity = 980.0


@export var attack_1_duration: float = 0.4
@export var attack_2_duration: float = 0.4
@export var attack_3_duration: float = 0.4
@export var combo_window: float = 0.6        #tiempo para encadenar el siguiente golpe
@export var attack_dash_speed: float = 500.0  #velocidad del pequeño impulso
@export var attack_dash_duration: float = 0.1 #duración del impulso
@export var open_rate_trigger: float = 0.75 # % de tiempo omitido en la animacion

var combo_count: int = 0
var can_combo: bool = true
var current_direction: int = 1
var is_attacking: bool = false
var attack_timer: float = 0.0
var combo_timer: float = 0.0
var dash_timer: float = 0.0
var is_dashing: bool = false
var current_attack_duration: float = 0.0
var air_combo: bool

func _ready():
	pass

#examinar parametros del estado
func on_enter(air:bool):
	combo_count = 0
	can_combo = true
	is_attacking = true
	attack_timer = 0.0
	combo_timer = 0.0
	is_dashing = false
	air_combo = air
	var sprite = controlled_node.get_node("Ren_Sprite")
	if Input.is_action_pressed("LEFT"): current_direction = -1
	elif Input.is_action_pressed("RIGHT"): current_direction = 1
	elif $"../../Ren_Sprite".scale.x < 0: current_direction = -1
	elif $"../../Ren_Sprite".scale.x > 0: current_direction = 1
	execute_attack(0)

#resetear parametros para salir
func on_exit():
	is_attacking = false
	can_combo = false
	combo_count = 0
	is_dashing = false

func on_physics_process(delta: float) -> void:
	#control de gravedad
	if not air_combo: controlled_node.velocity.y += gravity * delta
	else: controlled_node.velocity.y = 20
	
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
			finish_attack(false)
	
	controlled_node.move_and_slide()
	
	# si caes cambiar a fall
	if not controlled_node.is_on_floor() and not air_combo:
		state_machine.change_to("PlayerStateFall")

func on_input(event: InputEvent) -> void:
	#solo procesar input si se ataca
	if not is_attacking:
		return
	
	#inputs del ataque
	if PlayerStatsComponent.stamia > 0:
		if Input.is_action_just_pressed("ATTACK"):
			if Input.is_action_pressed("LEFT"): current_direction = -1
			elif Input.is_action_pressed("RIGHT"): current_direction = 1
			if can_combo:
				can_combo = false
				print("combo false")
				combo_count += 1
				print("combo x" + str(combo_count))
				if combo_count <= 2:
					execute_attack(combo_count)
				else:
					print("El combo exede el max")
					finish_attack(true)
			else:
				print("can_combo o combo_timer no cumplen")
				finish_attack(false)
		
		elif Input.is_action_pressed("DASH"):
			if can_combo and combo_timer > 0:
				is_attacking = false
				can_combo = false
				combo_count = 0
				is_dashing = false
				controlled_node.velocity.x = 0
				
				state_machine.change_to("PlayerStateDash")
				$"../PlayerStateDash".dash("PlayerStateIdle",true)
		
		elif Input.is_action_pressed("BLOCK"):
			if can_combo and combo_timer > 0:
				is_attacking = false
				can_combo = false
				combo_count = 0
				is_dashing = false
				controlled_node.velocity.x = 0
				
				$"../PlayerStateBlock".charge_last_state("PlayerStateIdle")
				state_machine.change_to("PlayerStateBlock")
				$"../PlayerStateBlock".time_for_parry()


func execute_attack(attack_index: int):
	print("execute attack")
	combo_timer = combo_window
	is_dashing = false
	controlled_node.velocity.x = 0
	
	match attack_index:
		0:
			print("ataque 1")
			controlled_node.animation_machine.travel("Attack_1")
			current_attack_duration = attack_1_duration
		1:
			print("ataque 2")
			controlled_node.animation_machine.travel("Attack_2")
			current_attack_duration = attack_2_duration
		2:
			print("ataque 3")
			controlled_node.animation_machine.travel("Attack_3")
			current_attack_duration = attack_3_duration
		_:
			pass
	
	attack_timer = current_attack_duration
	_attack_timer_func()

func _attack_timer_func():
	await get_tree().create_timer(0.3).timeout
	print("combo true")
	can_combo = true 

func apply_dash(direction: int, speed: float):
	is_dashing = true
	controlled_node.velocity.x = current_direction * attack_dash_speed
	dash_timer = attack_dash_duration
	PlayerStatsComponent.stamia -= 5

func finish_attack(combo_finished:bool): #terminar combo
	print("FINISH")
	is_attacking = false
	can_combo = false
	combo_count = 0
	is_dashing = false
	controlled_node.velocity.x = 0
	
	if not combo_finished:
		if controlled_node.is_on_floor():
			if Input.is_action_pressed("LEFT") or Input.is_action_pressed("RIGHT"):
				controlled_node.animation_machine.travel("Run")
				state_machine.change_to("PlayerStateWalk")
			elif Input.is_action_pressed("DASH"):
				state_machine.change_to("PlayerStateDash")
				$"../PlayerStateDash".dash("PlayerStateIdle",true)
			elif Input.is_action_pressed("BLOCK"):
				$"../PlayerStateBlock".charge_last_state("PlayerStateIdle")
				state_machine.change_to("PlayerStateBlock")
				$"../PlayerStateBlock".time_for_parry()
			else:
				state_machine.change_to("PlayerStateIdle")
		else:
			state_machine.change_to("PlayerStateFall")
