extends CanvasLayer

var player
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _input(event: InputEvent) -> void:
	#control de apertura y cierre del menu de pausa
	if not visible and Input.is_action_just_pressed("PAUSE"):
		visible = true
		player.process_mode = Node.PROCESS_MODE_DISABLED
		get_tree().paused = true
	elif visible and Input.is_action_just_pressed("PAUSE"):
		visible = false
		player.process_mode = Node.PROCESS_MODE_ALWAYS
		get_tree().paused = false


func _on_resume_button_pressed() -> void: #funcionamiento de RESUME
	if visible:
		visible = false
		get_tree().paused = false


func _on_main_button_pressed() -> void: #funcionamiento de MAIN_MENU
	if visible: get_tree().change_scene_to_file("res://Files/Scenes/Teste Scene/test_main_menu.tscn")
