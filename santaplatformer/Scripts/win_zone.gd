extends Area2D


func _on_body_entered(body: Node2D) -> void:
	print(body.name)
	if(body.name == "Player"):
		print("You Win!")
		get_tree().change_scene_to_file("res://scenes/win_screen.tscn")
