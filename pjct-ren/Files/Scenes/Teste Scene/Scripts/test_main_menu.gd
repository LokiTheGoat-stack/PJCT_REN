extends CanvasLayer

func _ready() -> void:
	#llamar set_parameters cuando el nodo raiz este completamente cargado
	call_deferred("set_parameters")

func set_parameters(): 
	#parametros de iniciacion del menu preincipal (Musica, Animaciones, etc)
	if get_tree().paused: get_tree().paused = false

func _on_play_button_pressed() -> void: #funcionamiento de PLAY
	get_tree().change_scene_to_file("res://Files/Scenes/Teste Scene/provisional_scene.tscn")

func _on_exit_button_pressed() -> void: #funcionamiento de EXIT
	get_tree().quit()
