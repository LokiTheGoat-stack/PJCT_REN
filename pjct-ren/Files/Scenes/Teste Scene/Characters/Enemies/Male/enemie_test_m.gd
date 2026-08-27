extends CharacterBody2D
class_name MaleEnemieTest

@onready var body: Node2D = $Body
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision: CollisionShape2D = $Collision
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var waiting_timer: Timer = $WaitingTimer

@export var speed: float = 50
@export var hp: float = 100
@export var waypints: Array[Marker2D]


const MALE_SKIN_1 = preload("uid://bo061ym46bidc")
const MALE_SKIN_2 = preload("uid://cpv4t3p8xm5bt")
const MALE_SKIN_3 = preload("uid://dgh5wtg8v37hf")
const MALE_SKIN_4 = preload("uid://csrct844dwpkw")
const MALE_SKIN_5 = preload("uid://cq2gc13vclhk2")

var current_waypoint: int = 0
var can_change_scale: bool = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var patrol_mode: bool = true
var player: Node
var is_attack: bool = false

var min_distance: float = 15
var is_waiting: bool = false
var direction: Vector2
var current_distance: float

func _ready() -> void:
	add_to_group("Enemies")
	var skin_array: Array[CompressedTexture2D] = [MALE_SKIN_1,MALE_SKIN_2,MALE_SKIN_3,MALE_SKIN_4,MALE_SKIN_5]
	$Body/MaleSkin1.texture = skin_array[randi() % skin_array.size()]
	player = get_tree().get_first_node_in_group("Player")
	$Body/AttackArea/CollisionShape2D.disabled = false

func _process(delta: float) -> void:
	#cambiar la animacion detectando la velocidad
	if can_change_scale:
		if velocity.x == 0: animation_player.play("Idle")
		else: 
			if speed <= 50: animation_player.play("Walk")
			elif speed > 50: animation_player.play("Run")
	
	#detectar la direccion y voltear el sprite
	if can_change_scale:
		if velocity.x > 0:
			body.scale.x = -1
		elif velocity.x < 0:
			body.scale.x = 1
	if hp <= 0:
		$Body/AgroArea/CollisionPolygon2D.disabled = true
		$Body/AttackArea/CollisionShape2D.disabled = true
		is_attack = true
		is_dying()
		animation_player.play("Death")
		await animation_player.animation_finished
		queue_free()

func _physics_process(delta: float) -> void:
	#control del movimiento
	if not is_attack:
		if patrol_mode: 
			set_waypoint_direction()
			if is_waiting == false:
				velocity.x = direction.x * speed
				get_next_waypoint()
		else:
			direction = (player.global_position - global_position).normalized()
			velocity.x = direction.x * speed
	
	
	#control de gravedad
	velocity.y += 1600 * delta
	move_and_slide()

#actualizar la direccion si esta en modo patrulla
func set_waypoint_direction():
	var target_position: Vector2 = waypints[current_waypoint].global_position
	direction = target_position - global_position
	current_distance = direction.length()
	direction = direction.normalized()

func get_next_waypoint():
	if current_distance < min_distance:
		print("WERA")
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

#control del recivimiento de damage
func take_damage(damage, node):
	hp -= damage

#region SIGNALS
func _on_waiting_timer_timeout() -> void:
	is_waiting = false

func _on_agro_area_body_entered(body: Node2D) -> void:
	if not is_attack:
		patrol_mode = false
		speed = 100
func _on_agro_area_body_exited(body: Node2D) -> void:
	if not is_attack:
		speed = 50
		patrol_mode = true


func _on_attack_area_body_entered(body: Node2D) -> void:
	if is_attack == false:
		is_attack = true
		check_can_move(false)
		animation_player.play("Attack")
		await animation_player.animation_finished
		check_can_move(true)
		is_attack = false
	else:
		body.take_damage(30,self)
#endregion
