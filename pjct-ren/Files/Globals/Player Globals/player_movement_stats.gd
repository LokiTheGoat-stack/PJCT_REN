extends Node

@export var running_speed: float = 250
@export var running_acceleration: float = 1000.0
@export var running_decceleration: float = 15000.0
@export var crouched_speed: float = 300
@export var jump_speed: float = -500
@export var in_air_speed: float = 300
@export var gravity_low: float = 800.0
@export var gravity_hig: float = 1600.0
@export var gravity_release: float = 2000.0
@export var wall_jump_speed: float = 500.0
@export var wall_slide_speed: float = 50
@export var can_climbing: bool = true
@export var climbing_speed: float = 750.0
@export var automove_ledge_climb: Vector2 = Vector2(1250, -325)
@export var dash_speed: float = 1000.0
@export var dash_time: float = 0.1
@export var dash_cooldown: float = 0.5

@export var is_dash: bool = false
@export var is_block: bool = false 

@export var jump_count: int = 0
