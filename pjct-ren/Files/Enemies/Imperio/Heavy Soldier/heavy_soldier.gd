extends CharacterBody2D
class_name HeavySoldier

#region VAR
@onready var body: Node2D = $Body
@onready var body_sprite: Polygon2D = $Body/RArm
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_machine: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]
@onready var agro_collision: CollisionShape2D = $Body/AgroArea/CollisionPolygon2D
@onready var attack_collision: CollisionShape2D = $Body/AttackArea/CollisionShape2D
@onready var body_collision: CollisionShape2D = $Collision
@onready var waiting_timer: Timer = $WaitingTimer
@onready var state_machine: EnemieStateMachine = $StateMachine

@export var walk_speed: float = 30
@export var run_speed: float = 85
@export var hp: float = 600
@export var attack_damage: float = 60
@export var waypints: Array[Marker2D]

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var current_waypoint: int = 0
var player: Node
var is_attack: bool = false
var cant_block: bool = false
var can_damage: bool
var can_parry_me: bool = false
var run_away: bool = false
var player_in: bool = false

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
			body.scale.x = -1
		elif velocity.x > 0:
			body.scale.x = 1
	else:
		if velocity.x > 0:
				body.scale.x = -1
		elif velocity.x < 0:
				body.scale.x = 1
	
	if hp <= 0:
		state_machine.change_to("Death")
		$StateMachine/Death.die()

#endregion

#region USEFUL
func take_damage(damage, node, hitstun, HIT_sprite):
	var damage_count: float = 0
	damage_count = damage
	hp -= damage
	damage_effect(damage, hitstun, HIT_sprite)
	player.show_combo_effect(damage_count,self)

func _can_parry_me(can_parry:bool):
	can_parry_me = can_parry

func parry():
	if PlayerStatsComponent.parry_time and can_parry_me and player_in:
		can_damage = false
		take_damage(attack_damage * 5, self, PlayerStatsComponent.parry_hitstun, GlobalParameters.HIT)
		#player.show_combo_effect(attack_damage * 5,self)
		player.execute_parry()
		player.stamina_gift()

func damage_effect(damage:float, hitstun, HIT_sprite: Texture2D):
	player.sounds.flesh_slice()
	if damage > 10: player.shake_camera("player_hit")
	elif damage <= 10: player.shake_camera("player_small_hit")
	elif damage > 100: player.shake_camera("player_critical_hit")
	change_shader_parameters(Color.WHITE,1,1)
	GlobalParameters.hit_effect(self,HIT_sprite)
	await  player.activate_slow_motion(hitstun,0.001)
	await get_tree().create_timer(0.08).timeout
	body.visible = false
	await get_tree().create_timer(0.03).timeout
	body.visible = true
	await get_tree().create_timer(0.08).timeout
	change_shader_parameters(Color.WHITE,0,1)

func change_shader_parameters(color:Color, mix:float, alpha:float):
	GlobalParameters.change_shader_parameters(color,mix,alpha,body_sprite)

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
	player_in = true
	if is_attack == false:
		state_machine.change_to("Attack")
		$StateMachine/Attack.start_attack()
	if can_damage:
		if can_parry_me and PlayerStatsComponent.parry_time: 
			parry()
		else: body.take_damage(attack_damage,self,GlobalParameters.HIT,0.012)

func _on_attack_area_body_exited(body: Node2D) -> void:
	player_in = false
#endregion
