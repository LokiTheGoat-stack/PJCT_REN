extends Area2D
class_name TestProjectile

var direction: Vector2
var speed: float
var damage: float
var current_shooter

var counter_projectile: bool = false

func setup(dir:Vector2,spd:float,dmg:float,shooter):
	direction = dir
	speed = spd
	damage= dmg
	current_shooter = shooter
	rotation = direction.angle()
	visible = true
	await get_tree().create_timer(15.0).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if counter_projectile: 
		if body.is_in_group("Player"): return
		elif body.is_in_group("Enemies"):
			body.take_damage(damage * 2,current_shooter)
			queue_free()
		else: queue_free()
	else: 
		if body.is_in_group("Player"):
			if PlayerMovementStats.is_dash == false:
				body.take_damage(damage,current_shooter)
				queue_free()
			else:
				body.activate_slow_motion(0.3,0.2)
				body.stamina_gift()
				counter_projectile = true
				direction.x = - direction.x
				if speed < 1000: speed = 1000
				else: speed = speed * 3
		elif body.is_in_group("Enemies"): return
		else: queue_free()
