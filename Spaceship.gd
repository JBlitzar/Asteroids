extends KinematicBody2D


export (int) var ogspeed = 200
export (float) var rotation_speed = 0.05
var bulletscale = 1;
var bulletamt = 1;
var rotation_dir = 0
var velocity = Vector2(0,0)
var friction = 0.99
var spread = 0.5
var angularvelocity = 0
onready var screensize = get_viewport_rect().size
export var shootingspeed = 250
export(PackedScene) var Bullet
var controlslocked = true
var speed = 200;
var angularfriction = 0.9
func wrap():
	if position.x > screensize.x:
		position.x = 0
	if position.y > screensize.y:
		position.y= 0
	if position.x < 0:
		position.x = screensize.x
	if position.y < 0:
		position.y = screensize.y


func get_input():
	rotation_dir = 0
	if Input.is_action_pressed("ui_right"):
		rotation_dir += 1
	if Input.is_action_pressed("ui_left"):
		rotation_dir -= 1
	if Input.is_action_pressed("ui_down"):
		velocity = Vector2(-speed, 0).rotated(rotation)
	if Input.is_action_pressed("ui_up"):
		velocity = Vector2(speed, 0).rotated(rotation)
	if Input.is_action_just_pressed("ui_accept"):
		for i in range(bulletamt):
			var indexrotation = i-(bulletamt/2)
			add_bullet(indexrotation*spread)
func add_bullet(rot_offset):
	get_node("/root/Main/Sounds/Pew").play()
	var bullet = Bullet.instance()
	bullet.velocity = Vector2(shootingspeed,0).rotated(rotation+rot_offset)
	bullet.position = position + Vector2(100,0).rotated(rotation+rot_offset)
	bullet.rotation = rotation+rot_offset
	bullet.scale = Vector2(bulletscale,bulletscale ) 
	get_node("/root/Main/Bulletpit").call_deferred("add_child", bullet)

func _physics_process(delta):
	if not controlslocked:
		get_input()
	angularvelocity += rotation_dir * rotation_speed * delta * angularfriction
	rotation += angularvelocity
	velocity = move_and_slide(velocity)
	velocity *= friction
	wrap()

func _on_Bounding_Box_body_entered(_body):
	pass # Replace with function body.
func turnOff():
	self.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	self.position = get_viewport_rect().size/2
func turnOn():
	self.show()
	$CollisionShape2D.set_deferred("disabled", false)

func _on_Main_when_play():
	controlslocked = false
func when_die():
	controlslocked = true
func reset():
	speed = ogspeed
	bulletscale = 1
	bulletamt = 1
func fast():
	speed *= 1.7
func supershoot():
	bulletscale = 2
	bulletamt = 5
