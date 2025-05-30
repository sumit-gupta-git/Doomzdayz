extends Area2D

enum PowerUp {
	SHIELD,
	LIFE,
	TRIPLE,
	WAVE,
	SCORE
}

@export var CurrAction = PowerUp.SHIELD

@onready var _player = get_tree().current_scene.get_node("GameScene/Player/CharacterBody2D")
@onready var _gameManager = get_tree().current_scene.get_node("GameScene/GameManager")

func _ready() -> void:
	add_to_group("powerup")
	connect("body_entered", _on_body_entered)
	$AnimatedSprite2D.play("live")

func _process(delta: float) -> void:
	match CurrAction:
		PowerUp.SHIELD: $AnimatedSprite2D.play("shield")
		PowerUp.LIFE: $AnimatedSprite2D.play("live")
		PowerUp.TRIPLE: $AnimatedSprite2D.play("triple")
		PowerUp.WAVE: $AnimatedSprite2D.play("wave")
		PowerUp.SCORE: $AnimatedSprite2D.play("score")

func _physics_process(delta: float) -> void:
	position.y += 40 * delta

func setType(type: int):
	match type:
		0: CurrAction = PowerUp.SHIELD
		1: CurrAction = PowerUp.LIFE
		2: CurrAction = PowerUp.TRIPLE
		3: CurrAction = PowerUp.WAVE
		4: CurrAction = PowerUp.SCORE	
	
func _on_body_entered(body):
	if body.is_in_group("player"):
		apply_powerup(body)
	
func apply_powerup(player):
	match CurrAction:

		PowerUp.SHIELD: handleShield()
		PowerUp.LIFE : handleLives()
		PowerUp.TRIPLE : handleTripleShoot()
		PowerUp.WAVE : handleWave()
		PowerUp.SCORE : handleScore()
		
	queue_free()  # Remove power-up after collection

func handleLives():
	_player.Lives += 1

func handleTripleShoot():
	_player.tripleShoot()


func handleShield():
	_player.handleShield()

	
func handleScore():
	_gameManager.handleMulti()
	
func handleWave():
	var children = get_tree().current_scene.get_node("GameScene").get_children()
	
	_player.get_node("Shockwave").startAnim()
	
	for i in children :
		if i.is_in_group("enemies"):
			var ipos = i.global_position
			var playerpos = _player.global_position
			if ipos.x > playerpos.x - float(400) and ipos.x < playerpos.x +float(400):
				if ipos.y > playerpos.y - float(400) and ipos.y < playerpos.y +float(400):
					i.queue_free()
