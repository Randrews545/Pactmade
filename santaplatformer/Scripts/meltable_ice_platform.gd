extends Node2D

#var platform_scene = preload("res://Scenes/platform.tscn")
@onready var ice_platform: ICE = $ice_platform
@onready var animated_sprite_2d: AnimatedSprite2D = $ice_platform/AnimatedSprite2D

func _ready() -> void:
	pass
	#meltPlatform()



func meltPlatform():
	animated_sprite_2d.play("melt")


func _on_animated_sprite_2d_animation_finished() -> void:
	ice_platform.queue_free()
