extends Area2D
const SPEED = 10

var direction = -1
@onready var game_manager: Node = %GameManager
@onready var animation_player: AnimationPlayer = $AnimationPlayer



func _on_body_entered(body: Node2D) -> void:
	game_manager.add_point()
	animation_player.play("pickup")

func _process(delta: float) -> void:
	position.y += direction * SPEED * delta
