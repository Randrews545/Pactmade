extends CharacterBody2D


const SPEED = 1200.0
const JUMP_VELOCITY = -1650.0
const GRAVITY = Vector2(0,3000)
const SLIDE = 0.05
const BOUNCE_BOOST = 1.15
const BOUNCE_VERT = -900
const ICE_ACCELERATION = -30

@onready var touched_ice: Timer = $TouchedIce
@onready var movement_lockout: Timer = $MovementLockout
@onready var wall_bounce_lockout: Timer = $WallBounceLockout
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var pos : Vector2
@onready var old_pos : Vector2


var on_ice = false
var moving : bool
var time = Timer
var death_timer = Timer
var time_label = Label
var is_alive = true
var double_jump = 0



func _physics_process(delta: float) -> void:
	var tempVelocity;
	var collision;
	
	if is_alive:
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
					touched_ice.start()
					
			else:
				on_ice = false
		
		
		# Add the gravity.
		if not is_on_floor():
			velocity += GRAVITY * delta

		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			double_jump = 0
			
		if Input.is_action_just_pressed("jump") and not is_on_floor() and double_jump == 0:
			velocity.y = JUMP_VELOCITY
			double_jump = 2

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		
		var direction := Input.get_axis("move_left", "move_right")
		
		if direction > 0:
			animated_sprite_2d.flip_h = false
		elif direction < 0:
			animated_sprite_2d.flip_h = true
		
		if is_on_floor():
			if direction == 0 && !on_ice:
				animated_sprite_2d.play("idle")
			else:
				animated_sprite_2d.play("run")
		
		if((moving && on_ice) || !movement_lockout.is_stopped()):
			direction = 0.0

		if direction:
			velocity.x = direction * SPEED
		else:
			var deceleration = SPEED * SLIDE;
			if(on_ice) :
				deceleration = ICE_ACCELERATION
			velocity.x = move_toward(velocity.x, 0, deceleration)
		
		tempVelocity = velocity

		move_and_slide()
		
		if get_slide_collision_count() > 0:
			collision = get_slide_collision(0)
		if collision != null && collision.get_collider() is BOUNCE && wall_bounce_lockout.is_stopped() && !touched_ice.is_stopped():
			wall_bounce_lockout.start()
			movement_lockout.start()
			print("bounce")
			velocity = tempVelocity.bounce(collision.get_normal()) * BOUNCE_BOOST
			velocity.y = velocity.y + BOUNCE_VERT
		
		update_label_text()
	
func _ready():
	
	time_label = $"../Player/Camera2D/Label"
	time = 	$"../Player/Camera2D/Timer"
	death_timer = $DeathAnimTimer
	time.start()
	
func die():
	is_alive = false
	death_timer.start()
	animated_sprite_2d.play("death")
	
	
func _on_timer_timeout() -> void:
	die()

func update_label_text():
	time_label.text = str(ceil(time.time_left))

		
	
	


func _on_death_anim_timer_timeout() -> void:
	get_tree().reload_current_scene()


func _on_wall_bounce_lockout_timeout() -> void:
	wall_bounce_lockout.stop()


func _on_movement_lockout_timeout() -> void:
	movement_lockout.stop()


func _on_touched_ice_timeout() -> void:
	touched_ice.stop()
