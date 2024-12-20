extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
		get_tree().change_scene_to_file("res://scenes/Game.tscn")
