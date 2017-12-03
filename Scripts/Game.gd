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
var game
var losingScreen
var winningScreen
export var autoStart = false

func _ready():
	mainMenu = get_node("MainMenu")
	resumeButton = mainMenu.get_node("Resume")
	hud = get_node("HUD")
	healthLabel = hud.get_node("HealthLabel")
	levelMenu = get_node("LevelMenu")
	losingScreen = get_node("LosingScreen")
	winningScreen = get_node("WinningScreen")
	game = get_node("/root/GameData")
	pause()
	set_process_input(true)
	if autoStart:
		_on_Start_Level_1_pressed()
		_on_StartLevel_pressed()
	
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
		losingScreen.hide()
		winningScreen.hide()
		get_tree().set_pause(false)
		paused = false

func clearLevel():
	if loadedLevel != null:
		loadedLevel.free()

func initLevel(scene):
	levelRunning = false
	clearLevel()
	var node = scene.instance()
	loadedLevel = node
	loadedLevel.hide()
	add_child(node)
	losingScreen.hide()
	winningScreen.hide()
	mainMenu.hide()
	levelMenu.show()
func _on_Start_Level_1_pressed():
	initLevel(preload("res://Scenes/Level1.tscn"))



func _on_Resume_pressed():
	unpause()


func _on_StartLevel_pressed():
	fill_inventory()
	loadedLevel.show()
	levelRunning = true
	unpause()

func fill_inventory():
	game.clear_items()
	var items = levelMenu.get_node("Items")
	for item in items.get_children():
		if item.is_pressed:
			game.add_item(item.get_name())
			
func finish_level():
	winningScreen.show()
	pause()
	
func game_over():
	losingScreen.show()
	pause()
	

func _on_Start_Level_2_pressed():
	initLevel(preload("res://Scenes/Level2.tscn"))


func _on_Start_Level_3_pressed():
	initLevel(preload("res://Scenes/Level3.tscn"))
