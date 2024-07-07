extends Node2D

var  speed = 40
var player_chase = false
var player = null

@onready var area_2d = $hitbox
@onready var timer = $Timer
@onready var area_ditection = $AreaDitection
@onready var animated_sprite_2d = AnimatedSprite2D

func _on_area_2d_body_entered(body):
	print("you lost hp")
	body.health -= 5
	if body.health == 0:
		timer.start()
		body.animated_sprite_2d.visible=false

func _on_timer_timeout():
	get_tree().reload_current_scene()
func _physics_process(_delta):
	if  player_chase :
		position += (player.position - position)/speed

func _on_area_ditection_body_entered(body):
	player = body
	player_chase = true

func _on_area_ditection_body_exited(_body):
	player = null
	player_chase = false
