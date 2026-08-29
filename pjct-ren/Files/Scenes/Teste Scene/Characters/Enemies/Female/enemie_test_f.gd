extends CharacterBody2D
class_name FemaleEnemieTest

@onready var body: Node2D = $Body
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision: CollisionShape2D = $Collision
@onready var waiting_timer: Timer = $WaitingTimer
@onready var attack_timer: Timer = $"Attack Timer"

@export var speed: float = 50
@export var hp: float = 100
@export var waypints: Array[Marker2D]

const PROJECTILE = preload("uid://d37kn8mjhxirj")

const FEMALE_SKIN_1 = preload("uid://dft003h5lsjl0")
const FEMALE_SKIN_2 = preload("uid://do3q4u5kjyes5")
const FEMALE_SKIN_3 = preload("uid://1g14cyvhhib4")
const FEMALE_SKIN_4 = preload("uid://7p613nru8ba")
const FEMALE_SKIN_5 = preload("uid://desqa3m5ukxul")

var current_waypoint: int = 0
var can_change_scale: bool = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var patrol_mode: bool = true
var player: Node

var min_distance: float = 15
var is_waiting: bool = false
var direction: Vector2
var current_distance: float

var dying: bool = false
var dying_position: Vector2

func _ready() -> void:
	add_to_group("Enemies")
	var skin_array: Array[CompressedTexture2D] = [FEMALE_SKIN_1,FEMALE_SKIN_2,FEMALE_SKIN_3,FEMALE_SKIN_4,FEMALE_SKIN_5]
	$Body/MaleSkin1.texture = skin_array[randi() % skin_array.size()]
	player = get_tree().get_first_node_in_group("Player")

func _process(delta: float) -> void:
	#cambiar la animacion detectando la velocidad
	if patrol_mode:
		if velocity.x == 0: animation_player.play("Idle")
		else: 
			if speed <= 50: animation_player.play("Walk")
			elif speed > 50: animation_player.play("Run")
	
	#detectar la direccion y voltear el sprite
	if patrol_mode:
		if velocity.x > 0:
			body.scale.x = -1
		elif velocity.x < 0:
			body.scale.x = 1
	elif not patrol_mode:
		if player.global_position.x > global_position.x:
			body.scale.x = -1
		elif player.global_position.x < global_position.x:
			body.scale.x = 1
	
	if hp <= 0:
		dying = true
		$Body/AgroArea/CollisionPolygon2D.disabled = true
		patrol_mode = false
		is_dying()
		animation_player.play("Death")
		await animation_player.animation_finished
		queue_free()

func _physics_process(delta: float) -> void:
	#control del movimiento
	if not dying:
		if patrol_mode: 
			set_waypoint_direction()
			if is_waiting == false:
				velocity.x = direction.x * speed
				get_next_waypoint()
		else: velocity = Vector2.ZERO
	else: velocity = Vector2.ZERO
	
	#control de gravedad
	if not dying: velocity.y += 1600 * delta
	move_and_slide()

#actualizar la direccion si esta en modo patrulla
func set_waypoint_direction():
	var target_position: Vector2 = waypints[current_waypoint].global_position
	direction = target_position - global_position
	current_distance = direction.length()
	direction = direction.normalized()

func get_next_waypoint():
	if current_distance < min_distance:
		current_waypoint += 1
		velocity = Vector2.ZERO
		is_waiting = true
		waiting_timer.start()
		if current_waypoint >= waypints.size(): current_waypoint = 0

#funciones conectadas a animaciones
func check_can_move(can_move:bool):
	can_change_scale = can_move
	if can_move == false: velocity = Vector2.ZERO
func is_dying():
	check_can_move(false)
	collision.disabled = true

#control del recivimiento de damage
func take_damage(damage, node):
	hp -= damage

#region SIGNALS
func _on_waiting_timer_timeout() -> void:
	is_waiting = false

func _on_attack_timer_timeout() -> void:
	attack()

func _on_agro_area_body_entered(body: Node2D) -> void:
	patrol_mode = false
	animation_player.play("Idle")
	check_can_move(false)
	attack_timer.start()
func _on_agro_area_body_exited(body: Node2D) -> void:
	attack_timer.stop()
	patrol_mode = true
	check_can_move(true)
#endregion

#funciones de ataque
func attack():
	animation_player.play("Attack")
	await animation_player.animation_finished
	animation_player.play("Idle")
func shoot():
	var bullet: Area2D = PROJECTILE.instantiate()
	bullet.global_position = $Body/Start.global_position
	get_parent().add_child(bullet)
	bullet.z_index = 10
	bullet.setup(
		(player.global_position - $Body/Start.global_position).normalized(),
		150,
		30,
		self
	)
