extends Node2D

signal emit_roll_clicked()

enum State {NULL, ROLL, Q, RELIC}

var state = State.NULL

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func enable_relic():
	print("relic time")
	$AnimationPlayer.play("null-to-relic")
	enable_pressable()
	state = State.RELIC

func enable_roll():
	print("enabling")
	$AnimationPlayer.play("null-to-roll")
	enable_pressable()
	state = State.ROLL

func shut_display():
	$AnimationPlayer.play("to-null")

func relic_roll():
	print("relic dice")
	$AnimationPlayer.play("relic-to-null")
	$Button.visible = false

func roll():
	print("rolling")
	$AnimationPlayer.play("roll-to-null")
	$Button.visible = false

func enable_pressable():
	print("enabling pressable")
	$Button.visible = true

func _on_Button_pressed():
	match state:
		State.ROLL:
			emit_signal("emit_roll_clicked")
			roll()
		State.RELIC:
			emit_signal("emit_roll_clicked")
			relic_roll()
	pass # Replace with function body.
