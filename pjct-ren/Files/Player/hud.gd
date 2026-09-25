extends CanvasLayer
class_name PlayerHUD

@onready var stamina_bar: TextureProgressBar = $StaminaBar
@onready var frenesi_bar: TextureProgressBar = $FrenesiBar
@onready var armor_bar: TextureProgressBar = $ArmorBar
@onready var health_bar: TextureProgressBar = $HealthBar


var red_color: Color = Color(1.0, 0.0, 0.0)
var normal_color: Color = Color(1.0, 1.0, 1.0)
var yellow_color: Color = Color(1.0, 1.0, 0.0)
var umbral_color: float = 33


func _process(delta: float) -> void:
	#visuales
	stamina_bar.value = PlayerStatsComponent.current_stamina
	health_bar.value = PlayerStatsComponent.current_hp
	frenesi_bar.value = PlayerStatsComponent.current_frenesi
	armor_bar.value = PlayerStatsComponent.current_armor
	
	#STAMINA
	if PlayerStatsComponent.current_stamina < PlayerStatsComponent.max_stamina:
		PlayerStatsComponent.current_stamina += 20 * delta
		update_stamina_color()
	
	#ARMOR
	if PlayerStatsComponent.current_armor <= 0:
		PlayerStatsComponent.armor = false
		PlayerStatsComponent.current_armor = 0
		$"..".ren_armor.visible = false


func _input(event: InputEvent) -> void:
	if PlayerStatsComponent.current_frenesi == 15 and\
	not PlayerStatsComponent.frenesi and Input.is_action_just_pressed("FRENESI"):
		PlayerStatsComponent.frenesi = true
		$"..".start_party()



func update_stamina_color():
	var rate = PlayerStatsComponent.current_stamina / PlayerStatsComponent.max_stamina
	var umbral33 = 50 / stamina_bar.max_value
	var umbral66 = 100 / stamina_bar.max_value
	
	if rate < umbral33:
		var t = rate / umbral33
		stamina_bar.modulate = red_color.lerp(yellow_color, t)
	elif rate < umbral66:
		var t = rate / umbral66
		stamina_bar.modulate = yellow_color.lerp(normal_color, t)
	else:
		stamina_bar.modulate = normal_color
	
