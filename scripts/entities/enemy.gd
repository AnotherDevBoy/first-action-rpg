extends Entity
class_name Enemy

var speed = 45
var should_chase_player = false
var player = null

func _ready() -> void:
	super._ready()
	
	$AnimatedSprite2D.play("idle")
	
	attack_component.damage = 5  # Set enemy damage
	attack_component.cooldown_time = 1.0  # Set attack cooldown time

func _physics_process(delta: float) -> void:
	deal_with_damage()
	
	if should_chase_player:
		position += (player.position - position)/speed
		$AnimatedSprite2D.play("walk")
		
		if (player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("idle")

func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	should_chase_player = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	should_chase_player = false

func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body is Player:
		attack_component.perform_attack(body)
		
func deal_with_damage():
	if player:
		attack_component.perform_attack(player)

func on_death():
	super._on_death()
	$AnimatedSprite2D.play("death")
