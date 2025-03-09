extends CharacterBody2D
class_name Entity

var health_component: HealthComponent
var attack_component: AttackComponent

func _ready():
	health_component = HealthComponent.new()
	attack_component = AttackComponent.new()
	
	add_child(health_component)
	add_child(attack_component)
	
	health_component.health_depleted.connect(_on_death)

func _on_death():
	print(name, " has died.")
	queue_free()

func attack(target: Entity):
	if attack_component:
		attack_component.perform_attack(target)
