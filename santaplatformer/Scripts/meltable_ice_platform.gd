extends Node2D

var platform_scene = preload("res://Scenes/platform.tscn")
@onready var ice_platform: ICE = $ice_platform
@onready var pos : Vector2;

func _ready() -> void:
	pass
	#meltPlatform()



func meltPlatform():
	var instance = platform_scene.instantiate()
	add_child(instance)
	ice_platform.queue_free()
