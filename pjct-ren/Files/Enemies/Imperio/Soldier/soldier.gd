extends CharacterBody2D
class_name Soldier

#region VAR
@onready var body: Node2D = $Body
@onready var body_sprite: Sprite2D = $Body/MaleSkin1
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_machine: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]
@onready var agro_collision: CollisionShape2D = $Body/AgroArea/CollisionPolygon2D
@onready var attack_collision: CollisionShape2D = $Body/AttackArea/CollisionShape2D
@onready var body_collision: CollisionShape2D = $Collision
@onready var state_machine: EnemieStateMachine = $StateMachine
@onready var waiting_timer: Timer = $WaitingTimer

@export var walk_speed: float = 50
@export var run_speed: float = 100
@export var hp: float = 100
@export var attack_damage: float = 25.0
@export var waypints: Array[Marker2D]

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var current_waypoint: int = 0
var player: Node
var is_attack: bool = false
var cant_block: bool = false
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
	
	#detectar la direccion y voltear el sprite
	if not run_away:
		if velocity.x < 0:
			body.scale.x = 1
		elif velocity.x > 0:
			body.scale.x = -1
	else:
		if velocity.x > 0:
			body.scale.x = 1
		elif velocity.x < 0:
			body.scale.x = -1
	
	if hp <= 0:
		state_machine.change_to("Death")
		$StateMachine/Death.die()

#endregion

#region USEFUL
func take_damage(damage, node):
	var damage_count: float = 0
	damage_count = damage
	hp -= damage
	damage_effect(damage)
	player.show_combo_effect(damage_count,self)

func _can_parry_me(can_parry:bool):
	if PlayerStatsComponent.parry_time and can_parry_me:
		can_damage = false
		take_damage(attack_damage * 5, self)
		player.show_combo_effect(attack_damage * 5,self)
		player.execute_parry()
		player.stamina_gift()
	else: can_parry_me = can_parry

func damage_effect(damage:float):
	player.sounds.flesh_slice()
	if damage > 10: player.shake_camera("player_hit")
	elif damage <= 10: player.shake_camera("player_small_hit")
	elif damage > 100: player.shake_camera("player_critical_hit")
	change_shader_parameters(Color.WHITE,1,1)
	await  player.activate_slow_motion(0.09,0.001)
	await get_tree().create_timer(0.08).timeout
	body.visible = false
	await get_tree().create_timer(0.03).timeout
	body.visible = true
	await get_tree().create_timer(0.08).timeout
	change_shader_parameters(Color.WHITE,0,1)

func change_shader_parameters(color:Color, mix:float, alpha:float):
	var sprite_material = body_sprite.material
	sprite_material.set_shader_parameter("Color", color)
	sprite_material.set_shader_parameter("Mix", mix)
	sprite_material.set_shader_parameter("Alpha", alpha)

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
	if can_damage:
		body.take_damage(attack_damage,self,preload("uid://buokwrn26gvmp"))
		
#endregion
