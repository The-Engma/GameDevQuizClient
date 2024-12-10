extends Control

@export_file("*.tscn") var server_scene
@export_file("*.tscn") var client_scene


func _on_client_button_pressed() -> void:
	get_tree().change_scene_to_file(client_scene)


func _on_server_button_pressed() -> void:
		get_tree().change_scene_to_file(server_scene)
