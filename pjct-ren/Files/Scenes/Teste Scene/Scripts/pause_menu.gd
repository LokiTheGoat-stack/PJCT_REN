extends CanvasLayer

func _input(event: InputEvent) -> void:
	#control de apertura y cierre del menu de pausa
	if not visible and Input.is_action_just_pressed("PAUSE"):
		visible = true
		get_tree().paused = true
	elif visible and Input.is_action_just_pressed("PAUSE"):
		visible = false
		get_tree().paused = false


func _on_resume_button_pressed() -> void: #funcionamiento de RESUME
	if visible:
		visible = false
		get_tree().paused = false


func _on_main_button_pressed() -> void: #funcionamiento de MAIN_MENU
	if visible: get_tree().change_scene_to_file("res://Files/Scenes/Teste Scene/test_main_menu.tscn")
