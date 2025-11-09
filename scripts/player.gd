extends CharacterBody2D

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var player: CharacterBody2D = $"."

@export var walk_speed = 450.0
@export var swim_speed = 7
@export var jump_power = -650

var is_swimming : bool = true


func _physics_process(_delta: float) -> void:
	
	#checks the variable is_swimming and runs the apropriate movement function
	if is_swimming:
		if_swimming()
	else:
		if_grounded()
	
	#changes the is_swimming var when test(space) button is pressed this is temporary
	if Input.is_action_just_pressed("test"):
		is_swimming = not is_swimming
		velocity = Vector2.ZERO

#is the function that works for left to right movement
func if_grounded():
	sprite_2d.play("walk")
	rotation = 0
	sprite_2d.flip_v = false
	var direction := Input.get_axis("grounded_left", "grounded_right")
	if direction:
		velocity.x = direction * walk_speed
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed)
	if not is_on_floor():
		velocity += get_gravity() * get_process_delta_time()
	else:
		if Input.is_action_just_pressed("swim"):
			velocity.y = jump_power
	move_and_slide()

#is the function that works for swimming movement
func if_swimming():
	sprite_2d.play("swim")
	#gets the positon of the mouse
	var mouse = get_global_mouse_position()
	
	#gets the distance from player to mouse
	var distance = (player.position - mouse).length()
	
	#if the mouse isent to close makes player rotate towards mouse
	if distance > 50:
		look_at(mouse)
	#if the mouse isent to close and swim(shift) button is pressed moves player towards mouse 
	if distance > 100 and Input.is_action_pressed("swim"):
		player.move_local_x(swim_speed)
	#else makes player stay still
	else:
		velocity = Vector2.ZERO
	#fixes player's sprite rotation
	if rotation <= -1.5 or rotation >= 1.5:
		sprite_2d.flip_v = true
	else:
		sprite_2d.flip_v = false
	move_and_slide()
