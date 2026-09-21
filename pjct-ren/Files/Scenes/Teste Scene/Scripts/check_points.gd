extends Node2D
class_name CheckPoints


func _on_intro_body_entered(body: Node2D) -> void:
	GlobalParameters.current_checkpoint = $Intro/Marker2D

func _on_sky_body_entered(body: Node2D) -> void:
	GlobalParameters.current_checkpoint = $Sky/Marker2D

func _on_dash_body_entered(body: Node2D) -> void:
	GlobalParameters.current_checkpoint = $Dash/Marker2D

func _on_wall_jump_body_entered(body: Node2D) -> void:
	GlobalParameters.current_checkpoint = $WallJump/Marker2D

func _on_all_body_entered(body: Node2D) -> void:
	GlobalParameters.current_checkpoint = $All/Marker2D

func _on_all_2_body_entered(body: Node2D) -> void:
	GlobalParameters.current_checkpoint = $All2/Marker2D

func _on_impulse_body_entered(body: Node2D) -> void:
	GlobalParameters.current_checkpoint = $Impulse/Marker2D

func _on_impulse_2_body_entered(body: Node2D) -> void:
	GlobalParameters.current_checkpoint = $Impulse2/Marker2D
