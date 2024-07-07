extends CharacterBody2D

const SPEED = 150
const ACCEL = 1500
const FRICTION = 1000

var input = Vector2.ZERO
var check_attack = false

@export var damage = 5
@export var health = 10

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var area_2d = $Area2D
@onready var collision_shape_2d = $Area2D/CollisionShape2D

func _physics_process(delta):
	attack()
	player_movement(delta)

func get_input():
	var input_vector = Vector2.ZERO

	input_vector.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	input_vector.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	
	return input_vector.normalized()

func player_movement(delta):
	input = get_input()
	if input == Vector2.ZERO:
		if velocity.length() > (FRICTION * delta):
			velocity -= velocity.normalized() * (FRICTION * delta)
		elif check_attack== false :
			velocity = Vector2.ZERO
			animated_sprite_2d.play("idle")
	else:
		velocity += input * ACCEL * delta
		velocity = velocity.limit_length(SPEED)
		animated_sprite_2d.play("run")
		if input.x<0:
			if animated_sprite_2d.flip_h != true:
				collision_shape_2d.position.x=collision_shape_2d.position.x*-1
				animated_sprite_2d.flip_h=true
		elif input.x>0:
			if animated_sprite_2d.flip_h != false:
				collision_shape_2d.position.x=collision_shape_2d.position.x*-1
				animated_sprite_2d.flip_h=false

	move_and_slide()

func attack():
	if Input.is_action_just_pressed("attack"):
		check_attack=true
		animated_sprite_2d.play("attack")
		await get_tree().create_timer(0.1).timeout
		area_2d.monitoring=true
		await get_tree().create_timer(0.5).timeout
		area_2d.monitoring=false
		check_attack=false

func _on_area_2d_area_entered(area):
	for child in area.get_children():
		if child is Damageable:
			child.hit(damage)
