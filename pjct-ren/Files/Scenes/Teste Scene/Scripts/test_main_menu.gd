extends CanvasLayer

func _ready() -> void:
	call_deferred("set_parameters")

func set_parameters():
	if get_tree().paused: get_tree().paused = false

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Files/Scenes/Teste Scene/provisional_scene.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
