extends PlayerStateBase

@onready var enemies: Node2D = $"../../../Enemies"
@onready var parry_camera: PhantomCamera2D = $"../../Ren_Sprite/ParryCamera/ParryCamera_1"
@onready var SHADER_MATERIAL = load("uid://tvndjc42kayr")
@onready var canvas_modulate: CanvasModulate = $"../../CanvasModulate"

const SHADED = preload("uid://4ovf7r7m6rx7")
const UNSHADED = preload("uid://dkardyj33mh5y")


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
	await set_canvas_color(true)
	start_parry()


func set_canvas_color(value:bool):
	var tween: Tween = create_tween()
	
	match value:
		true:
			SHADER_MATERIAL.shader = UNSHADED
			tween.tween_property(canvas_modulate,"color",Color(0.224, 0.224, 0.224),0.1)
		false:
			tween.tween_property(canvas_modulate,"color",Color(1.0, 1.0, 1.0),0.3)
			SHADER_MATERIAL.shader = SHADED
		_: pass

func parry_sound():
	controlled_node.sounds._parry()

func set_camera(value:bool):
	match value:
		true: parry_camera.set_priority(20)
		false: parry_camera.set_priority(0)
		_: pass

func start_parry():
	set_camera(true)
	await get_tree().create_timer(0.1).timeout
	controlled_node.animation_machine.travel("Parry")

func finish():
	set_canvas_color(false)
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
