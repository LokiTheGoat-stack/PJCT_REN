extends Node2D
class_name PlayerSounds

@onready var footstep_sounds: AudioStreamPlayer2D = $Footstep_Sounds
@onready var fall_sounds: AudioStreamPlayer2D = $Fall_Sounds

func play_2D_sound(sound:AudioStreamPlayer2D, volume:float, pitch:float):
	sound.volume_db = volume
	sound.pitch_scale = pitch
	sound.play()

func play_sound(sound:AudioStreamPlayer, volume:float, pitch:float):
	sound.volume_db = volume
	sound.pitch_scale = pitch
	sound.play()

#region SPECIFIC_SOUNDS
func footstep():
	footstep_sounds.play()

func fall():
	fall_sounds.play()

#endregion
