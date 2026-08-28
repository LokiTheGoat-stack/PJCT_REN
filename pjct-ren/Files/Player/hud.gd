extends CanvasLayer
class_name PlayerHUD

@onready var mana_bar: TextureProgressBar = $manaBar
@onready var exbar: TextureProgressBar = $exbar
@onready var hpbar: TextureProgressBar = $hpbar

var red_color: Color = Color(1.0, 0.0, 0.0)
var normal_color: Color = Color(1.0, 1.0, 1.0)
var yellow_color: Color = Color(1.0, 1.0, 0.0)
var umbral_color: float = 33


func _process(delta: float) -> void:
	#visuales
	mana_bar.value = PlayerStatsComponent.stamia
	hpbar.value = PlayerStatsComponent.current_hp
	
	#STAMINA
	if PlayerStatsComponent.stamia < mana_bar.max_value:
		PlayerStatsComponent.stamia += 20 * delta
		update_stamina_color()
	
	

func update_stamina_color():
	var rate = PlayerStatsComponent.stamia / mana_bar.max_value
	var umbral33 = 50 / mana_bar.max_value
	var umbral66 = 100 / mana_bar.max_value
	
	if rate < umbral33:
		var t = rate / umbral33
		mana_bar.modulate = red_color.lerp(yellow_color, t)
	elif rate < umbral66:
		var t = rate / umbral66
		mana_bar.modulate = yellow_color.lerp(normal_color, t)
	else:
		mana_bar.modulate = normal_color
	
