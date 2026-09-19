extends Node
class_name SceneSounds

@onready var music_player: AudioStreamPlayer = $MusicPlayer

var is_calm: bool = true
var music_progresion: int = 0

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#TODOS ESTOS SCRIPTS SON PROVISIONALES
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

func _ready() -> void:
	music_player.play()
	pass

#region COMBAT
func _on_area_enemie_detect_body_entered(body: Node2D) -> void:
	if is_calm:
		is_calm = false
		music_player["parameters/switch_to_clip"] = "Transicion"
func _on_area_enemie_detect_body_exited(body: Node2D) -> void:
	await get_tree().create_timer(5.0).timeout
	var nodes_in_area: Array = $"../Player/AreaEnemieDetect".get_overlapping_bodies()
	if nodes_in_area.size() == 0:
		is_calm = true
		music_player["parameters/switch_to_clip"] = "Calma"
#endregion


func _on_inicio_plataformas_body_entered(body: Node2D) -> void:
	if music_progresion == 0: 
		music_progresion += 1
		music_player["parameters/switch_to_clip"] = "Trans2"


func _on_cuarto_inicio_body_entered(body: Node2D) -> void:
	if music_progresion == 1: 
		music_progresion += 1
		music_player["parameters/switch_to_clip"] = "Outro"
