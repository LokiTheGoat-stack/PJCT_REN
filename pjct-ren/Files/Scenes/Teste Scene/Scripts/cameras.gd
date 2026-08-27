extends Node2D
class_name CameraDirector

@onready var path_camera: PhantomCamera2D = $PathCamera
@onready var center_camera: PhantomCamera2D = $CenterArea/CenterCamera
@onready var total_camera: PhantomCamera2D = $TotalArea/TotalCamera
@onready var center_camera_2: PhantomCamera2D = $CenterArea2/CenterCamera2


func _on_center_area_body_entered(body: Node2D) -> void:
	center_camera.set_priority(10)


func _on_center_area_body_exited(body: Node2D) -> void:
	center_camera.set_priority(0)


func _on_center_area_2_body_entered(body: Node2D) -> void:
	center_camera_2.set_priority(10)


func _on_center_area_2_body_exited(body: Node2D) -> void:
	center_camera_2.set_priority(0)
