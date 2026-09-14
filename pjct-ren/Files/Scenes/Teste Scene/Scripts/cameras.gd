extends Node2D
class_name CameraDirector

@onready var path_camera: PhantomCamera2D = $PathCamera
@onready var center_camera: PhantomCamera2D = $CenterArea/CenterCamera
@onready var center_camera_2: PhantomCamera2D = $CenterArea2/CenterCamera2
@onready var group_camera: PhantomCamera2D = $GroupCamera

func _process(delta: float) -> void:
	#OFFSET de la camara
	if $"../Player".velocity.x > 0: change_camera_offset("x",50,delta)
	elif $"../Player".velocity.x < 0: change_camera_offset("x",-50,delta)
	if $"../Player".velocity.y > 0: change_camera_offset("y",-20,delta)
	elif $"../Player".velocity.y < 0: change_camera_offset("y",-30,delta)
	else: change_camera_offset("y",-50,delta)


func change_camera_offset(eje:String,value:float,delta):
	var tween = create_tween()
	match eje:
		"x": 
			$PathCamera.follow_offset.x = lerp($PathCamera.follow_offset.x,value,5.0 * delta)
		"y": 
			$PathCamera.follow_offset.y = lerp($PathCamera.follow_offset.y,value,10.0 * delta)
		_: pass


#region CENTER_CAMERA
func _on_center_area_body_entered(body: Node2D) -> void:
	GlobalParameters.current_camera = center_camera
	center_camera.set_priority(10)
func _on_center_area_body_exited(body: Node2D) -> void:
	GlobalParameters.current_camera = path_camera
	center_camera.set_priority(0)
#endregion

#region CENTER_CAMERA_2
func _on_center_area_2_body_entered(body: Node2D) -> void:
	center_camera_2.set_priority(10)
func _on_center_area_2_body_exited(body: Node2D) -> void:
	center_camera_2.set_priority(0)
#endregion


func _on_area_enemie_detect_body_entered(body: Node2D) -> void:
	GlobalParameters.current_camera = group_camera
	group_camera.set_priority(10)
	group_camera.append_follow_targets(body)
func _on_area_enemie_detect_body_exited(body: Node2D) -> void:
	GlobalParameters.current_camera = path_camera
	group_camera.erase_follow_targets(body)
	if group_camera.follow_targets.size() == 1:
		group_camera.set_priority(0)
