extends Area2D
class_name TestProjectile

var direction: Vector2
var speed: float
var damage: float
var current_shooter

var counter_projectile: bool = false
var can_parry: bool
var player

func _ready() -> void:
	add_to_group("Enemie_Bullet")

func setup(dir:Vector2,spd:float,dmg:float,shooter,parry:bool):
	direction = dir
	speed = spd
	damage= dmg
	current_shooter = shooter
	can_parry = parry
	rotation = direction.angle()
	visible = true
	await get_tree().create_timer(15.0).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func counter(body):
	counter_projectile = true
	player = body
	player.activate_slow_motion(0.3,0.2)
	player.stamina_gift()
	direction = (current_shooter.global_position - global_position).normalized()
	if speed < 1000: speed = 1000
	else: speed = speed * 3

func _on_body_entered(body: Node2D) -> void:
	if counter_projectile: 
		if body.is_in_group("Player"): return
		elif body.is_in_group("Enemies"):
			body.take_damage(damage * 2,current_shooter)
			player.show_combo_effect(damage * 2, current_shooter)
			queue_free()
		else: queue_free()
	else: 
		if body.is_in_group("Player"):
			await get_tree().create_timer(0.2).timeout
			if not PlayerMovementStats.is_dash and not counter_projectile:
				body.take_damage(damage,current_shooter)
				queue_free()
		elif body.is_in_group("Enemies"): return
		else: queue_free()
