extends Node
class_name SceneSounds

@onready var music_player: AudioStreamPlayer = $MusicPlayer

var is_calm: bool = true

func _ready() -> void:
	music_player.play()


func _on_center_area_body_entered(body: Node2D) -> void:
	if is_calm:
		music_player["parameters/switch_to_clip"] = "Transicion"
		is_calm = false


func _on_center_area_body_exited(body: Node2D) -> void:
	if not is_calm:
		music_player["parameters/switch_to_clip"] = "Calma"
		is_calm = true


func _on_center_area_2_body_entered(body: Node2D) -> void:
	if is_calm:
		music_player["parameters/switch_to_clip"] = "Transicion"
		is_calm = false
