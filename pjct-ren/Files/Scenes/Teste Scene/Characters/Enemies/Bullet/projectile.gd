extends Area2D
class_name TestProjectile

var direction: Vector2
var speed: float
var damage: float
var current_shooter

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
	if body.is_in_group("Player"):
		body.take_damage(damage,current_shooter)
		queue_free()
	else: queue_free()
