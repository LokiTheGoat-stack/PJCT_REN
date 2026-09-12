extends Node

@export var max_hp: float = 100
@export var current_hp: float = 100
@export var armor: bool = false
@export var defense: float = 50
@export var max_stamina: float = 100
@export var current_stamina: float = 100

@export var damage: float = 40
@export var critic_damage: float = 50

@export var is_death: bool = false
@export var parry_time: bool = false
@export var can_recive_damage: bool = true
@export var can_attack: bool = true
@export var can_play: bool = false

@export var parry_hitstun: float = 0.12

func set_all_default():
	current_hp = max_hp
	current_stamina = max_stamina
