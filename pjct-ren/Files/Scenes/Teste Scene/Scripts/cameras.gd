extends Node2D
class_name CameraDirector

@onready var path_camera: PhantomCamera2D = $PathCamera
@onready var center_camera: PhantomCamera2D = $CenterArea/CenterCamera
@onready var center_camera_2: PhantomCamera2D = $CenterArea2/CenterCamera2
@onready var group_camera: PhantomCamera2D = $GroupCamera


#region CENTER_CAMERA
func _on_center_area_body_entered(body: Node2D) -> void:
	center_camera.set_priority(10)
func _on_center_area_body_exited(body: Node2D) -> void:
	center_camera.set_priority(0)
#endregion

#region CENTER_CAMERA_2
func _on_center_area_2_body_entered(body: Node2D) -> void:
	center_camera_2.set_priority(10)
func _on_center_area_2_body_exited(body: Node2D) -> void:
	center_camera_2.set_priority(0)
#endregion


func _on_area_enemie_detect_body_entered(body: Node2D) -> void:
	group_camera.set_priority(10)
	group_camera.append_follow_targets(body)
func _on_area_enemie_detect_body_exited(body: Node2D) -> void:
	group_camera.erase_follow_targets(body)
	if group_camera.follow_targets.size() == 1:
		group_camera.set_priority(0)
