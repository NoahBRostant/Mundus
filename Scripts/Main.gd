extends Control

var projectName = ""
var projectType = ""

var tab = preload("res://Scenes/ContentTabButton.tscn")

var startguide = preload("res://Scenes/StartGuide.tscn")

var tabdict = []


func _ready():
	get_window().borderless = false
	get_window().title = "Mundus - World Builder"
	get_window().min_size = Vector2i(1000,600)
	$Control2/HBoxContainer/HSplitContainer/VBoxContainer3/HBoxContainer/Label.text = "Mundus_"+Console.verState+"_v"+Console.version
	await get_tree().create_timer(0.1).timeout
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	#TabCalculate()
	if Console.hasGlobalMenu == true:
		%MenuBar.hide()
		var File = DisplayServer.global_menu_add_item("File","New Article",_on_file_id_pressed(0))
	%ProjectName.text = Global.projectName
	projectType = Global.projectType
	if projectType == "DnD5e":
		$Control2/HBoxContainer/HSplitContainer/VBoxContainer/HBoxContainer/DnDLogo.show()
	elif projectType == "Pathfinder":
		$Control2/HBoxContainer/HSplitContainer/VBoxContainer/HBoxContainer/PathfinderLogo.show()
	var tablist = %ContentPanel.get_children()
	for i in tablist:
		printerr(i)
		var tempdict = {
			"title":i.title,
			"image":i.img,
			"saved":i.saved,
			"tabid":tablist.find(i)
		}
		tabdict.append(tempdict)
	print(tabdict)
	for i in tabdict:
		var instance = tab.instantiate()
		instance.title = i["title"]
		instance.img = i["image"]
		instance.tabid = i["tabid"]
		$Control2/HBoxContainer/HSplitContainer/VBoxContainer/HBoxContainer/ScrollContainer/ReorderableHBox.add_child(instance)


func _on_file_id_pressed(id):
	if id == 0:
		pass
	elif id == 1:
		pass
	elif id == 2:
		pass
	elif id == 3:
		pass
	elif id == 4:
		pass
	elif id == 5:
		pass
	elif id == 6:
		pass
	elif id == 7:
		pass
	elif id == 8:
		pass
	elif id == 9:
		pass
	elif id == 10:
		get_tree().change_scene_to_file("res://Scenes/ProjectList.tscn")
	elif id == 11:
		get_tree().quit()

func _on_help_id_pressed(id):
	if id == 0:
		$About.show()
	elif id == 1:
		pass
	elif id == 2:
		pass
	elif id == 3:
		OS.shell_open("https://github.com/NoahBRostant/Mundus")
	elif id == 4:
		OS.shell_open("https://mundusworldbuilder.webflow.io/")
	elif id == 5:
		var inst = startguide.instantiate()
		Console.tabidint += 1
		inst.tabid = Console.tabidint
		%ContentPanel.add_child(inst)

#func add_content_article()


func _on_accountoptions_button_up():
	$AccountOptions.show()


func _on_closeaccount_button_up():
	$AccountOptions.hide()
	$AddFileTree.hide()

func openfile():
	var fileoopen = Console.filetoopen
	

func _on_aboutclose_button_down() -> void:
	$About.hide()
