extends CharacterBody2D
class_name Player

@onready var body: Sprite2D = $Ren_Sprites

#var states:PlayerStateNames = PlayerStateNames.new()
#var animations:PlayerAnimations = PlayerAnimations.new()

func set_facing_direction() -> void:
	if self.velocity.x < 0: body.flip_h = true
	elif self.velocity.x > 0: body.flip_h = false

func _process(_delta):
	set_facing_direction()
	
