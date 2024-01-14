extends Control

@export var reload = false:
	set (value):
		_reload
	get:
		_reload

var newProject = preload("res://NewProjectPanel.tscn")
var projectItem = preload("res://ProjectItem.tscn")
var items
var oldProject

func _ready():
	get_window().size = Vector2i(1152,648)
	get_window().borderless = false
	get_window().title = "Mundus - Project List"
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	for i in Console.Projects:
		var instance = projectItem.instantiate()
		instance.get_node("%ProjectName").text = i.split(",")[1]
		instance.get_node("%ProjectModDate").text = i.split(",")[5]
		instance.projectName =  i.split(",")[1]
		instance.projectFileName =  i.split(",")[0]
		instance.projectType =  i.split(",")[3]
		instance.projectMadeDate =  i.split(",")[2]
		instance.projectModDate =  i.split(",")[5]
		%ProjectGrid.add_child(instance)
	items = %ProjectGrid.get_children()
	oldProject = Console.projectSelected


func _process(delta):
	if Console.projectSelected == null:
		$VBoxContainer/HBoxContainer/Panel4/VBoxContainer/Panel/VBoxContainer/Button.disabled = true
		$VBoxContainer/HBoxContainer/Panel4/VBoxContainer/Panel/VBoxContainer/Button2.disabled = true
		$VBoxContainer/HBoxContainer/Panel4/VBoxContainer/Panel/VBoxContainer/Button3.disabled = true
		$VBoxContainer/HBoxContainer/Panel4/VBoxContainer/Panel/VBoxContainer/Button4.disabled = true
		$VBoxContainer/HBoxContainer/Panel4/VBoxContainer/Panel/VBoxContainer/Button5.disabled = true
	else:
		$VBoxContainer/HBoxContainer/Panel4/VBoxContainer/Panel/VBoxContainer/Button.disabled = false
		$VBoxContainer/HBoxContainer/Panel4/VBoxContainer/Panel/VBoxContainer/Button2.disabled = false
		#$VBoxContainer/HBoxContainer/Panel4/VBoxContainer/Panel/VBoxContainer/Button3.disabled = false
		#$VBoxContainer/HBoxContainer/Panel4/VBoxContainer/Panel/VBoxContainer/Button4.disabled = false
		$VBoxContainer/HBoxContainer/Panel4/VBoxContainer/Panel/VBoxContainer/Button5.disabled = false
	if oldProject != Console.projectSelected:
		change_info()


func _on_button_button_down():
	var instance = newProject.instantiate()
	self.add_child(instance)


func _on_line_edit_text_changed(new_text):
	if new_text != "":
		for i in items:
			if new_text.to_lower() in i.projectName.to_lower() or new_text.similarity(i.projectName) > 0.3:
				i.show()
			else:
				i.hide()
	else:
		for i in items:
			i.show()

func _reload(x):
	items = %ProjectGrid.get_children()
	for i in items:
		%ProjectGrid.remove_child(i)
	_ready()


func _on_button_3_button_down():
	_reload(null)


func _on_open_button_down():
	Console.projectSelected.OpenProject()


func _on_delete_button_down():
	Console.projectSelected.DeleteProject()

func _on_rename_button_down():
	$RenamePanel.show()

func _on_renamepanelclose_button_down():
	$RenamePanel.hide()
	$RenamePanel/Panel/VBoxContainer/LineEdit.text = ""

func _on_renamepaneldone_button_down():
	Console.projectSelected.projectName = $RenamePanel/Panel/VBoxContainer/LineEdit.text
	$RenamePanel.hide()
	$RenamePanel/Panel/VBoxContainer/LineEdit.text = ""
	oldProject = null
	Console.projectSelected.get_node("%ProjectName").text = Console.projectSelected.projectName


func change_info():
	if Console.projectSelected != null:
		%ProjectInfo.text = "Name: "+str(Console.projectSelected.projectName)+"\nRuleset: "+str(Console.projectSelected.projectType)+"\nDate Created: "+str(Console.projectSelected.projectMadeDate)+"\nModified On: "+str(Console.projectSelected.projectModDate)+"\nTags: "
	else:
		%ProjectInfo.text = "Name:\nRuleset:\nDate Created:\nModified On:\nTags: "
	oldProject = Console.projectSelected


func _on_button_button_up():
	Firebase.Auth.logout()
