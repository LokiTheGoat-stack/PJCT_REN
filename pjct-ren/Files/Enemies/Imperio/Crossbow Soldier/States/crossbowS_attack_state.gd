extends EnemieStateBase

var direction: float
var current_attack: int = 0
var is_dash: bool

func on_physics_process(delta: float) -> void:
	
	controlled_node.velocity.x = 0
	
	controlled_node.velocity.y += 1600 * delta
	controlled_node.move_and_slide()


func start_attack():
	controlled_node.animation_machine.travel("Attack")

func shoot():
	var color: Color
	var number: int = randi() % 5 + 1
	if number <= 3:
		controlled_node.cant_block = false
		color = Color(0.0, 1.0, 0.424)
	else:
		controlled_node.cant_block = true
		color = Color(1.0, 0.0, 0.424)
	var bullet: Area2D = controlled_node.ENEMIES_PROJECTILE.instantiate()
	bullet.global_position = $"../../Body/Start".global_position
	get_parent().add_child(bullet)
	bullet.z_index = 10
	bullet.setup(
		(controlled_node.player.global_position - $"../../Body/Start".global_position).normalized(),
		150,
		30,
		controlled_node,
		true,
		color
	)

func attack_count():
	current_attack += 1
