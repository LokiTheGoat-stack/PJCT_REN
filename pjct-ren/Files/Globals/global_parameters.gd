extends Node

var SCREAM_SHAKE = preload("uid://ch7xh4i15k5gq")
var TEST_CAMERA_NOISE = preload("uid://wq361cmc5ng")

var current_camera: PhantomCamera2D
var player_camera: Camera2D

func hit_effect(target:Node,sprite:Texture2D):
	
	var effect: Sprite2D = Sprite2D.new()
	effect.texture = sprite
	effect.global_position = target.global_position
	target.get_parent().add_child(effect)
	target.z_index = 10
	await get_tree().create_timer(0.2).timeout
	effect.queue_free()
