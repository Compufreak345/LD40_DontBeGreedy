extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var mainMenu
var resumeButton
var paused = false
var loadedLevel
var hud
var levelMenu
var levelRunning = false
var healthLabel
func _ready():
	mainMenu = get_node("MainMenu")
	resumeButton = mainMenu.get_node("Resume")
	hud = get_node("HUD")
	healthLabel = hud.get_node("HealthLabel")
	levelMenu = get_node("LevelMenu")
	pause()
	set_process_input(true)
	
func update_health(value):
	healthLabel.set_text("Health:" + str(value))
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if !paused:
			pause()
		else:
			unpause()
		
func pause():
	get_tree().set_pause(true)
	mainMenu.show()
	hud.hide()
	levelMenu.hide()
	if loadedLevel != null && levelRunning:
		resumeButton.show()
	paused = true

func unpause():
	if loadedLevel != null && levelRunning:
		mainMenu.hide()
		levelMenu.hide()
		hud.show()
		get_tree().set_pause(false)
		paused = false

func clearLevel():
	if loadedLevel != null:
		loadedLevel.free()

func _on_Start_Level_1_pressed():
	levelRunning = false
	clearLevel()
	var scene = preload("res://Scenes/Level1.tscn")
	var node = scene.instance()
	loadedLevel = node
	loadedLevel.hide()
	add_child(node)
	mainMenu.hide()
	levelMenu.show()



func _on_Resume_pressed():
	unpause()


func _on_StartLevel_pressed():
	loadedLevel.show()
	levelRunning = true
	unpause()