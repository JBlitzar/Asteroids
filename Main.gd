extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(PackedScene) var Asteroid
export(PackedScene) var Coin
var score = 0
var playingstate = false
var cap = 10
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$Spaceship.turnOff()

signal when_play
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func collectable():
	$Sounds/Coin.play()
	var chosen = (randi()%2)+1
	print(chosen)
	if chosen == 1:
		$Spaceship.supershoot()
	else:
		$Spaceship.fast()
	$Effecttimer.start()

func _on_SpawnTimer_timeout():
	if not playingstate or $AsteroidPit.get_child_count()>cap:
		return
	var asteroid = Asteroid.instance()
	var asteroid_loc = get_node("AsteroidPath/AsteroidSpawnLocation")
	asteroid_loc.offset = randi()
	var direction = asteroid_loc.rotation + PI / 2
	asteroid.position = asteroid_loc.position
	direction += rand_range(-PI / 4, PI / 4)
	asteroid.rotation = direction
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	asteroid.velocity = velocity.rotated(direction)
	var size = randi()%3+1
	asteroid.size = size
	if asteroid.position.distance_to($Spaceship.position) > 300:
		$AsteroidPit.add_child(asteroid)
func spaceship_die():
	score = 0
	playingstate = false;
	$UI/MainMenu.show()
	$Spaceship.turnOff()
	$UI/Score.hide()
	$Sounds/Spaceship_die.play()
	$Spaceship.reset()
	for child in $Bulletpit.get_children():
		child.call_deferred("queue_free")
	for child in $AsteroidPit.get_children():
		child.call_deferred("queue_free")
	for child in $CoinPit.get_children():
		child.call_deferred("queue_free")
func asteroid_die():
	score += 1
	$UI/Score.text = "Score: "+str(score)
	$Sounds/Asteroid_smallexplode.play()
func asteroid_bigdie():
	score += 1
	$UI/Score.text = "Score: "+str(score)
	$Sounds/Asteroid_bigexplode.play()
func _on_Button_pressed():
	yield(get_tree(), "idle_frame")
	$UI/Score.text = "Score: "+str(score)
	for child in $Bulletpit.get_children():
		child.queue_free()
	for child in $AsteroidPit.get_children():
		child.queue_free()
		print("queue")
	
	playingstate = true;
	$UI/MainMenu.hide()
	$Spaceship.turnOn()
	$UI/Score.show()
	emit_signal("when_play")


func _on_Effecttimer_timeout():
	$Spaceship.reset()


func _on_CoinTimer_timeout():
	if not playingstate or $CoinPit.get_child_count()>cap:
		return
	var coin = Coin.instance()
	var screenSize = get_viewport().get_visible_rect().size
	var rndX = rand_range(0, screenSize.x)
	var rndY = rand_range(0, screenSize.y)
	coin.position = Vector2(rndX, rndY)
	$CoinPit.add_child(coin)
