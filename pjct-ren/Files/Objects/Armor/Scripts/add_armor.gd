extends Area2D
class_name AddArmor

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("Idle")



func _on_body_entered(body: Node2D) -> void:
	PlayerStatsComponent.current_armor += 3
	if PlayerStatsComponent.current_armor > PlayerStatsComponent.max_armor: 
		PlayerStatsComponent.current_armor = PlayerStatsComponent.max_armor
	PlayerStatsComponent.armor = true
	body.ren_armor.visible = true
	queue_free()
