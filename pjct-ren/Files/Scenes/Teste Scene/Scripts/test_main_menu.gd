extends CanvasLayer

func _ready() -> void:
	#llamar set_parameters cuando el nodo raiz este completamente cargado
	call_deferred("set_parameters")

func set_parameters(): 
	#parametros de iniciacion del menu preincipal (Musica, Animaciones, etc)
	if get_tree().paused: get_tree().paused = false

func _on_play_button_pressed() -> void: #funcionamiento de PLAY
	#get_tree().change_scene_to_file("res://Files/Scenes/Teste Scene/provisional_scene.tscn")
	$VBoxContainer/PlayButton.disabled = true
	$VBoxContainer/ExitButton.disabled = true
	
	$"../Cameras/MenuCamera2".set_priority(10)
	$"../Cameras/MenuCamera".set_priority(0)
	
	var tween = create_tween()
	tween.tween_property($Titulo,"modulate:a", 0.0,0.5)
	tween.parallel().tween_property($VBoxContainer/PlayButton,"modulate:a", 0.0,0.5)
	tween.parallel().tween_property($VBoxContainer/ExitButton,"modulate:a", 0.0,0.5)
	
	await get_tree().create_timer(2.5).timeout
	
	$"../Cameras/MenuCamera2".set_priority(0)
	var player = get_tree().get_first_node_in_group("Player")
	player.show_HUD(true)
	PlayerStatsComponent.can_play = true
	$"../PauseMenu".process_mode = Node.PROCESS_MODE_ALWAYS
	

func _on_exit_button_pressed() -> void: #funcionamiento de EXIT
	get_tree().quit()
