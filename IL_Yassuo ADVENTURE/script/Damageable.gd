extends Node

class_name Damageable

@export var health = 10

func hit(damage : int):
	health -= damage
	print("got hit")
	if (health <= 0):
		get_parent().get_parent().queue_free()
