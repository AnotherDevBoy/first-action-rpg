extends Entity
class_name Player

# Define the enum for direction
enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

# Declare a variable to store the current direction
var current_direction: Direction = Direction.DOWN
var is_attacking = false

var enemies_in_range: Array = []

const speed = 100

func _ready() -> void:
	super._ready()
	
	$AnimatedSprite2D.play("front_idle")
	
	health_component.current_health = health_component.max_health
	attack_component.damage = 40
	attack_component.cooldown_time = 3

func _input(event):
	if event.is_action_pressed("attack") and !is_attacking:
		is_attacking = true
		on_attack()

func _physics_process(delta: float) -> void:
	if is_attacking:
		return
	
	move()

func move() -> void:
	if Input.is_action_pressed("ui_right"):
		current_direction = Direction.RIGHT
		play_movement_animation(true)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_direction = Direction.LEFT
		play_movement_animation(true)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_direction = Direction.DOWN
		play_movement_animation(true)
		velocity.x = 0
		velocity.y = speed
	elif Input.is_action_pressed("ui_up"):
		current_direction = Direction.UP
		play_movement_animation(true)
		velocity.x = 0
		velocity.y = -speed
	else:
		play_movement_animation(false)
		velocity.x = 0
		velocity.y = 0
		
	move_and_slide()
	
func play_movement_animation(isMoving: bool) -> void:
	if current_direction == Direction.RIGHT:
		$AnimatedSprite2D.flip_h = false
		if isMoving:
			$AnimatedSprite2D.play("side_walk")
		elif !isMoving:
			$AnimatedSprite2D.play("side_idle")
	elif current_direction == Direction.LEFT:
		$AnimatedSprite2D.flip_h = true
		if isMoving:
			$AnimatedSprite2D.play("side_walk")
		else:
			$AnimatedSprite2D.play("side_idle")
	elif current_direction == Direction.DOWN:
		if isMoving:
			$AnimatedSprite2D.play("front_walk")
		else:
			$AnimatedSprite2D.play("front_idle")
	elif current_direction == Direction.UP:
		if isMoving:
			$AnimatedSprite2D.play("back_walk")
		else:
			$AnimatedSprite2D.play("back_idle")

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body is Enemy:
		enemies_in_range.append(body)
		print("Enemy entered: ", body.name)
	

func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body is Enemy:
		enemies_in_range.erase(body)
		print("Enemy exited: ", body.name)

func on_attack() -> void:
	for enemy in enemies_in_range:
		if enemy is Enemy:  # Ensure it's an enemy
			attack_component.perform_attack(enemy)
	
	play_attack_animation()

func play_attack_animation() -> void:
	if current_direction == Direction.RIGHT:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("side_attack")
	elif current_direction == Direction.LEFT:
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("side_attack")
	elif current_direction == Direction.DOWN:
		$AnimatedSprite2D.play("front_attack")
	elif current_direction == Direction.UP:
		$AnimatedSprite2D.play("back_attack")

func on_death():
	super._on_death()
	$AnimatedSprite2D.play("death")


func _on_animated_sprite_2d_animation_finished() -> void:
	if is_attacking:
		is_attacking = false


func _on_animated_sprite_2d_animation_looped() -> void:
	if is_attacking:
		is_attacking = false
