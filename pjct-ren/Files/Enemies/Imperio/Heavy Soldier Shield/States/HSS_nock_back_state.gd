extends EnemieStateBase

var phantom_on: bool

func on_physics_process(delta: float) -> void:
	
	controlled_node.velocity.y += 1600 * delta
	controlled_node.move_and_slide()


func nock_back():
	$"../../Body/AttackArea".set_deferred("monitoring", false)
	$"../../Body/AgroArea".set_deferred("monitoring",false)
	controlled_node.is_block = false
	controlled_node.is_nockback = true
	
	if $"../../Body".scale.x > 0:
		controlled_node.velocity.x = -500
	elif $"../../Body".scale.x < 0:
		controlled_node.velocity.x = 500
	phantom_on = true
	phantom_animation()
	
	await get_tree().create_timer(0.2).timeout
	
	phantom_on = false
	controlled_node.velocity.x = 0
	
	await get_tree().create_timer(2.3).timeout
	
	controlled_node.is_attack = false
	$"../../Body/AttackArea".set_deferred("monitoring", true)
	$"../../Body/AgroArea".set_deferred("monitoring",true)
	controlled_node.is_block = true
	controlled_node.is_nockback = false
	controlled_node.animation_machine.travel("Idle")
	state_machine.change_to("Idle")


func phantom_animation():
	while true:
		await get_tree().create_timer(0.02).timeout
		add_phantom()
		if phantom_on == false: 
			break

func add_phantom():
	var tween: Tween = create_tween()
	var phantom: Sprite2D = Sprite2D.new()
	phantom.texture = load("res://icon.svg")
	#phantom.texture = controlled_node.ren_sprite.texture
	#phantom.hframes = controlled_node.ren_sprite.hframes
	#phantom.vframes = controlled_node.ren_sprite.vframes
	#phantom.frame = controlled_node.ren_sprite.frame
	#phantom.centered = true
	#if controlled_node.ren_sprite.flip_h: phantom.flip_h = true
	phantom.global_position = controlled_node.global_position
	phantom.modulate = Color.RED
	get_parent().add_child(phantom)
	phantom.z_index = 0
	tween.tween_property(phantom, "modulate", Color(1.0,1.0,1.0,0.0), 0.5)
	tween.tween_callback(phantom.queue_free)
	tween.tween_callback(tween.kill)
