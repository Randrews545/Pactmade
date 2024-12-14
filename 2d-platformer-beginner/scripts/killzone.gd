extends Area2D

const SPEED = 10

var direction = -1

@onready var timer: Timer = $Timer
@onready var tiles: TileMapLayer = $"../TileMap/Mid"
@onready var tilemap: TileMap = $"../TileMap"

func _on_body_entered(body: Node2D) -> void:
	match body.name:
		"Player":
			print("You died!")
			Engine.time_scale = 0.5
			body.get_node("CollisionShape2D").queue_free()
			timer.start()
		"Mid":
			var tile = tilemap.local_to_map(tilemap.to_local(to_global(body.position)))
			tiles.erase_cell(tile)
			#var tilecords = body.get_cell_atlas_coords(tile)
			#var tileid = body.get_cell_source_id(tilecords)
			print(tile)
			#print(tilecords)
			#print(tileid)


func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
	
func _process(delta: float) -> void:
	position.y += direction * SPEED * delta
