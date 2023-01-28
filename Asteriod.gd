extends KinematicBody2D


onready var screensize = get_viewport_rect().size
var velocity = Vector2()
var Asteroid = load("res://Asteroid.tscn")

var size = 2
func _ready():
	self.scale = Vector2(size,size)
func quietly_die():
	call_deferred("queue_free")
func check_despawn():
	if position.x > screensize.x:
		quietly_die()
	if position.y > screensize.y:
		quietly_die()
	if position.x < 0:
		quietly_die()
	if position.y < 0:
		quietly_die()
func _physics_process(_delta):
	move_and_slide(velocity)
	check_despawn()
func spawn_mini_asteroid(new_size):
	var asteroid = Asteroid.instance()
	var direction = 0
	direction += rand_range(-PI / 4, PI / 4)
	asteroid.rotation = direction
	var vel = Vector2(rand_range(150.0, 250.0), 0.0)
	asteroid.velocity = vel.rotated(direction)
	asteroid.position = position
	asteroid.size = new_size
	get_node("/root/Main/AsteroidPit").add_child(asteroid)
func when_die():
	$Particles2D.emitting = true
	
	set_deferred("$CollisionShape2D.disabled", true)
	$Sprite.hide()
	set_deferred("$Area2D/CollisionShape2D2.disabled", true)
	$Timer.start()
	if size == 1:
		get_tree().root.get_child(0).asteroid_die()
		
	else:
		get_tree().root.get_child(0).asteroid_bigdie()
		yield(get_tree(), "idle_frame")
		for _i in range(size):
			spawn_mini_asteroid(size-1)
	


func _on_Area2D_body_entered(body):
	if body.collision_layer == 2:
		when_die()
		body.die()
	else:
		get_tree().root.get_child(0).spaceship_die()
		get_node("/root/Main/Spaceship").when_die()
		


func _on_Timer_timeout():
	yield(get_tree(), "idle_frame")
	queue_free()
