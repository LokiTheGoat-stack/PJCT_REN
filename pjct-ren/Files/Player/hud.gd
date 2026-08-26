extends CanvasLayer
class_name PlayerHUD

@onready var mana_bar: TextureProgressBar = $manaBar
@onready var exbar: TextureProgressBar = $exbar
@onready var hpbar: TextureProgressBar = $hpbar

func _process(delta: float) -> void:
	hpbar.value = PlayerStatsComponent.current_hp
