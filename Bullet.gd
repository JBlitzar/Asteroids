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

func wrap():
	if position.x > screensize.x:
		position.x = 10
	if position.y > screensize.y:
		position.y = 10
	if position.x < 0:
		position.x = screensize.x-10
	if position.y < 0:
		position.y = screensize.y-10
func _physics_process(_delta):
	velocity = move_and_slide(velocity)
	wrap()
