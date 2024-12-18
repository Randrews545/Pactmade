extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -900.0
const GRAVITY = Vector2(0,1200)

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var on_ice = false
@onready var pos : Vector2;
@onready var old_pos : Vector2;
var moving : bool;
var time = Timer
var time_label = Label



func _physics_process(delta: float) -> void:
	var tempVelocity;
	var collision;
	
	#set pos to current position
	pos = global_position;
	if pos - old_pos:
		moving = true;
	else:
		moving = false;
		
	#create old pos from pos
	old_pos = pos;
	
	#Determine if player is on ice platform
	if(get_last_slide_collision() != null):
#		print(get_last_slide_collision().get_collider() is ICE)
		if(get_last_slide_collision().get_collider() is ICE):
				#print("a")
				on_ice = true
		else:
			on_ice = false
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity += GRAVITY * delta

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
	
	if(moving && on_ice):
		direction = 0.0

	if direction:
		velocity.x = direction * SPEED
	else:
		var deceleration = SPEED * 0.1;
		if(on_ice) :
			deceleration = -20
		velocity.x = move_toward(velocity.x, 0, deceleration)
	
	tempVelocity = velocity

	move_and_slide()
	
	
	if get_slide_collision_count() > 0:
		collision = get_slide_collision(0)
	if collision != null && collision.get_collider() is BOUNCE:
		print("bounce")
		velocity = tempVelocity.bounce(collision.get_normal())
		velocity.y = velocity.y - 300
	
	update_label_text()
	
func _ready():
	
	time_label = $"../Player/Camera2D/Label"
	time = 	$"../Player/Camera2D/Timer"
	
	time.start()
	
	
func _on_timer_timeout() -> void:
	
	get_tree().reload_current_scene()

func update_label_text():
	time_label.text = str(ceil(time.time_left))

		
	
	
