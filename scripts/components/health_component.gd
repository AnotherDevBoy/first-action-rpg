extends Node
class_name HealthComponent

@export var max_health: int = 100
var current_health: int

signal health_depleted

func _ready():
	current_health = max_health

func take_damage(amount: int):
	current_health -= amount
	
	print("Current health: ", current_health)

	if current_health <= 0:
		health_depleted.emit()
