extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var time = Timer
var time_label = Label



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
	
	if is_on_floor():
		if direction == 0 :
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("jump")
	

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	update_label_text()
	
func _ready():
	#var timeout = preload("res://scripts/killzone.gd")
	
	time_label = $"../Player/Camera2D/Label"
	time = 	$"../Player/Camera2D/Timer"
	
	time.start()
	
	#var instance = timeout.instantiate()
	#add_child(instance)
	
func _on_timer_timeout() -> void:
	
	get_tree().reload_current_scene()

func update_label_text():
	time_label.text = str(ceil(time.time_left))
	
