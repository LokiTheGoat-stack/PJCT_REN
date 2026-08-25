extends Node2D
class_name CameraDirector

@onready var path_camera: PhantomCamera2D = $PathCamera
@onready var center_camera: PhantomCamera2D = $CenterArea/CenterCamera
@onready var total_camera: PhantomCamera2D = $TotalArea/TotalCamera


func _on_center_area_body_entered(body: Node2D) -> void:
	center_camera.set_priority(10)


func _on_center_area_body_exited(body: Node2D) -> void:
	center_camera.set_priority(0)


func _on_total_area_body_entered(body: Node2D) -> void:
	total_camera.set_priority(10)


func _on_total_area_body_exited(body: Node2D) -> void:
	total_camera.set_priority(0)
