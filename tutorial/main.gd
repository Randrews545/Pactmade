extends Node2D

@onready var pink_piece : Sprite2D = $PinkPiece
@export var game_spaces : Array[Node]
var place : int = 1
var number_of_spaces : int
@onready var dice := $Dice
@onready var timer := $Timer

func _ready() -> void:
	number_of_spaces = game_spaces.size()
	print(number_of_spaces)

func _on_dice_dice_has_rolled(roll: Variant) -> void:
	print(roll)
	while roll != 0:
		var tween = create_tween()
		tween.tween_property(pink_piece, "position", game_spaces[place].position, 1)
		timer.start()
		await timer.timeout
		place += 1
		roll -= 1
