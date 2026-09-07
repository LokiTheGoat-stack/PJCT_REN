extends EnemieStateBase

func die():
	controlled_node.agro_collision.disabled = true
	controlled_node.attack_collision.disabled = true
	controlled_node.body_collision.disabled = true
	controlled_node.is_attack = true
	controlled_node.velocity = Vector2.ZERO
	controlled_node.animation_machine.travel("Death")
	await controlled_node.animation_player.animation_finished
	controlled_node.queue_free()
