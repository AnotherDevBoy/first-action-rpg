extends Node
class_name AttackComponent

@export var damage: int = 10
@export var cooldown_time: float = 1.0
var can_attack: bool = true

func perform_attack(target: Entity):
	if can_attack and target.health_component:
		target.health_component.take_damage(damage)
		print("Attacked ", target.name, " for ", damage, " damage.")
		_start_cooldown()

func _start_cooldown():
	can_attack = false
	await get_tree().create_timer(cooldown_time).timeout
	can_attack = true
