extends CharacterBody2D
class_name HeavySoldierShield

#region VAR
@onready var body: Node2D = $Body
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_machine: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]
@onready var agro_collision: CollisionShape2D = $Body/AgroArea/CollisionPolygon2D
@onready var attack_collision: CollisionShape2D = $Body/AttackArea/CollisionShape2D
@onready var body_collision: CollisionShape2D = $Collision
@onready var waiting_timer: Timer = $WaitingTimer
@onready var state_machine: EnemieStateMachine = $StateMachine

@export var walk_speed: float = 30
@export var run_speed: float = 45
@export var hp: float = 600
@export var attack_damage: float = 60
@export var waypints: Array[Marker2D]

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var current_waypoint: int = 0
var player: Node
var is_attack: bool = false
var is_block: bool = true
var is_nockback: bool = false
var can_damage: bool
var can_parry_me: bool = false
var run_away: bool = false

var min_distance: float = 25
var is_waiting: bool = false
var direction: Vector2
var current_distance: float


#endregion

func _ready() -> void:
	add_to_group("Enemies")
	player = get_tree().get_first_node_in_group("Player")
	$Body/AttackArea/CollisionShape2D.disabled = false

#region PROCESS
func _process(delta: float) -> void:
	#si no se mueve asegurar animacion idle
	#if velocity.x == 0: animation_machine.travel("Idle")
	
	#detectar la direccion y voltear el sprite
	if is_nockback:
		if player.global_position.x < global_position.x:
				body.scale.x = -1
		else:
				body.scale.x = 1
	elif run_away:
		if velocity.x > 0:
				body.scale.x = -1
		elif velocity.x < 0:
				body.scale.x = 1
	else:
		if velocity.x < 0:
			body.scale.x = -1
		elif velocity.x > 0:
			body.scale.x = 1
	
	
	if hp <= 0:
		state_machine.change_to("Death")
		$StateMachine/Death.die()

#endregion

#region USEFUL
func take_damage(damage, node):
	var damage_count: float = 0
	if is_block:
		damage_count = (damage * 5) / 100
		hp -= (damage * 5) / 100
	elif can_parry_me:
		damage_count = damage 
		hp -= damage
		player.activate_slow_motion(0.1,0.2)
		state_machine.change_to("NockBack")
		$StateMachine/NockBack.nock_back()
	elif is_nockback:
		damage_count = damage * 3
		hp -= damage * 3
	elif not is_block:
		damage_count = damage
		hp -= damage
	player.show_combo_effect(damage_count,self)

func _can_parry_me(can_parry:bool):
	can_parry_me = can_parry
	#if PlayerStatsComponent.parry_time:
	#	player.execute_parry()
	#	player.stamina_gift()

#endregion

#region SIGNALS
func _on_waiting_timer_timeout() -> void:
	is_waiting = false


func _on_agro_area_body_entered(body: Node2D) -> void:
	if not is_attack:
		animation_machine.travel("Run")
		state_machine.change_to("Agro")
func _on_agro_area_body_exited(body: Node2D) -> void:
	if not is_attack:
		animation_machine.travel("Idle")
		state_machine.change_to("Idle")


func _on_attack_area_body_entered(body: Node2D) -> void:
	if is_attack == false:
		state_machine.change_to("Attack")
		$StateMachine/Attack.start_attack()
	if can_damage: body.take_damage(attack_damage,self)
#endregion
