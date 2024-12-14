extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var on_ice = false
@onready var pos : Vector2;
@onready var old_pos : Vector2;
var moving : bool;



func _physics_process(delta: float) -> void:
	
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
	
	if(moving && on_ice):
		direction = 0.0

	if direction:
		velocity.x = direction * SPEED
	else:
		var deceleration = SPEED * 0.1;
		if(on_ice) :
			deceleration = -20
		velocity.x = move_toward(velocity.x, 0, deceleration)

	move_and_slide()
	

		
	
	
