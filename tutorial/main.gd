extends Node2D

@onready var pink_piece : Sprite2D = $PinkPiece
@export var game_spaces : Array[Node]
var place : int = 0
var number_of_spaces : int

func _ready() -> void:
	number_of_spaces = game_spaces.size()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_click") and place < number_of_spaces:
		var tween = create_tween()
		tween.tween_property(pink_piece, "position", game_spaces[place].position, 1)
		place += 1
	elif place >= number_of_spaces:
		print("Place is out of bounds")
