extends CanvasLayer
class_name DeathMenu

var player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func start():
	$"../PauseMenu".process_mode = Node.PROCESS_MODE_DISABLED
	get_tree().paused = true

func _on_check_point_pressed() -> void:
	if visible:
		visible = false
		PlayerStatsComponent.current_hp = PlayerStatsComponent.max_hp
		PlayerStatsComponent.current_stamina = PlayerStatsComponent.max_stamina
		player.global_position = GlobalParameters.current_checkpoint.global_position
		get_tree().paused = false
		player.state_machine.can_change = true
		player.state_machine.change_to("PlayerStateIdle")
		$"../PauseMenu".process_mode = Node.PROCESS_MODE_ALWAYS


func _on_main_menu_pressed() -> void:
	if visible:
		if visible: get_tree().change_scene_to_file("res://Files/Scenes/Teste Scene/provisional_scene.tscn")
