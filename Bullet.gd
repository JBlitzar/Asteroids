extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2()
onready var screensize = get_viewport_rect().size
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func die():
	call_deferred("queue_free")

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
	velocity = move_and_slide(velocity)
	check_despawn()
