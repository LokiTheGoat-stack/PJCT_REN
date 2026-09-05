extends EnemieStateBase

var direction: float
var current_attack: int = 0
var is_dash: bool

func on_physics_process(delta: float) -> void:
	
	if current_attack == 1 and not controlled_node.is_nockback:
		current_attack = 0
		$"../../Body/AttackArea".set_deferred("monitoring", false)
		$"../../Body/AgroArea".set_deferred("monitoring",false)
		controlled_node.is_block = true
		controlled_node.run_away = true
		controlled_node.animation_machine.travel("Walk")
		state_machine.change_to("RunAway")
		$"../RunAway".off_timer()
	
	if not is_dash: controlled_node.velocity.x = 0
	
	controlled_node.velocity.y += 1600 * delta
	controlled_node.move_and_slide()


func start_attack():
	controlled_node.is_block = false
	controlled_node.is_attack = true
	controlled_node.animation_machine.travel("Attack")

func dash(speed:float):
	is_dash = true
	controlled_node.velocity.x = $"../../Body".scale.x * speed
	await get_tree().create_timer(0.08).timeout
	is_dash = false

func damage(value:bool):
	controlled_node.can_damage = value

func attack_count():
	current_attack += 1
