extends EnemieStateBase

func die():
	$"../../Body/AttackArea".set_deferred("monitoring",false)
	$"../../Body/AgroArea".set_deferred("monitoring",false)
	controlled_node.body_collision.disabled = true
	controlled_node.is_attack = true
	controlled_node.velocity = Vector2.ZERO
	controlled_node.animation_machine.travel("Death")
	await controlled_node.animation_player.animation_finished
	controlled_node.queue_free()
