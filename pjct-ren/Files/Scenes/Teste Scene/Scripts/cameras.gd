extends Node2D
class_name CameraDirector

@onready var follow_camera: PhantomCamera2D = $FollowCamera
@onready var group_camera: PhantomCamera2D = $GroupCamera

var current_camera: PhantomCamera2D

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#TODOS ESTOS SCRIPTS SON PROVISIONALES
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

func _ready() -> void:
	current_camera = follow_camera

func _process(delta: float) -> void:
	#OFFSET de la camara
	if $"../Player".velocity.x > 0: change_camera_offset("x",80,delta)
	elif $"../Player".velocity.x < 0: change_camera_offset("x",-80,delta)
	if $"../Player".velocity.y > 0: change_camera_offset("y",-20,delta)
	elif $"../Player".velocity.y < 0: change_camera_offset("y",-30,delta)
	else: change_camera_offset("y",-50,delta)


func change_camera_offset(eje:String,value:float,delta):
	var tween = create_tween()
	match eje:
		"x": 
			current_camera.follow_offset.x = lerp(follow_camera.follow_offset.x,value,5.0 * delta)
		"y": 
			current_camera.follow_offset.y = lerp(follow_camera.follow_offset.y,value,10.0 * delta)
		_: pass


func _on_area_enemie_detect_body_entered(body: Node2D) -> void:
	GlobalParameters.current_camera = group_camera
	group_camera.set_priority(10)
	group_camera.append_follow_targets(body)
func _on_area_enemie_detect_body_exited(body: Node2D) -> void:
	GlobalParameters.current_camera = follow_camera
	group_camera.erase_follow_targets(body)
	if group_camera.follow_targets.size() == 1:
		group_camera.set_priority(0)



func _on_inicio_plataformas_body_entered(body: Node2D) -> void:
	$"Inicio Plataformas/PathPlataformasInicio".set_priority(10)
	current_camera = $"Inicio Plataformas/PathPlataformasInicio"
func _on_inicio_plataformas_body_exited(body: Node2D) -> void:
	$"Inicio Plataformas/PathPlataformasInicio".set_priority(0)
	current_camera = follow_camera



func _on_cuarto_inicio_body_entered(body: Node2D) -> void:
	$CuartoInicio/CuartoCamera.set_priority(10)
func _on_cuarto_inicio_body_exited(body: Node2D) -> void:
	$CuartoInicio/CuartoCamera.set_priority(0)



func _on_impulsos_1_body_entered(body: Node2D) -> void:
	$Impulsos1/PhantomCamera2D.set_priority(10)
func _on_impulsos_1_body_exited(body: Node2D) -> void:
	$Impulsos1/PhantomCamera2D.set_priority(0)
