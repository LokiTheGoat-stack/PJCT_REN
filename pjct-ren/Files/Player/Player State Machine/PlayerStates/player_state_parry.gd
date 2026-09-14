extends PlayerStateBase

@onready var enemies: Node2D = $"../../../Enemies"
@onready var parry_camera_1: PhantomCamera2D = $"../../Ren_Sprite/ParryCamera/ParryCamera_1"
@onready var parry_camera_2: PhantomCamera2D = $"../../Ren_Sprite/ParryCamera/ParryCamera_2"

var target
var attack_damage

#region ALWAYS_ON_FUNC


#endregion

func parry(damage:float, node):
	stop_enemies(true)
	target = node
	attack_damage = damage
	if node.global_position.x > controlled_node.global_position.x:
		controlled_node.ren_sprite.scale.x = 1
	elif node.global_position.x < controlled_node.global_position.x:
		controlled_node.ren_sprite.scale.x = -1
	start_parry()

func start_parry():
	controlled_node.sounds._parry()
	parry_camera_1.set_priority(20)
	await get_tree().create_timer(0.1).timeout
	controlled_node.animation_machine.travel("Parry")
	await controlled_node.activate_slow_motion(0.3,0.07)
	parry_camera_2.set_priority(30)
	parry_camera_1.set_priority(0)
	await get_tree().create_timer(0.4).timeout
	parry_camera_2.set_priority(0)
	finish()

func finish():
	controlled_node.animation_machine.travel("Idle")
	state_machine.change_to("PlayerStateIdle")
	PlayerStatsComponent.can_recive_damage = true

func damage():
	target.take_damage(attack_damage * 5, target, PlayerStatsComponent.parry_hitstun, GlobalParameters.HIT)

func stop_enemies(value:bool):
	match value:
		true:
			for i in enemies.get_children():
				i.process_mode = Node.PROCESS_MODE_DISABLED
		false:
			for i in enemies.get_children():
				i.process_mode = Node.PROCESS_MODE_INHERIT
		_: pass
