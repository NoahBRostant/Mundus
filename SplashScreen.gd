extends Control

var CWhite:String = "#D9D9D9"
var CBlue:String = "#77B3FE"
var CRed:String = "#FE8B68"
var CGreen:String = "#76C578"
var CYellow:String = "#E6F385"

var attempt = 0

func _ready():
	await get_tree().create_timer(0.5).timeout
	$ScrollContainer/VBoxContainer/RichTextLabel.append_text("\n[color="+CBlue+"]Checking for Updates[/color]")
	await get_tree().create_timer(1).timeout
	$ScrollContainer/VBoxContainer/RichTextLabel.append_text("\n[color="+CGreen+"]No Updates Found[/color]")
	await get_tree().create_timer(0.2).timeout
	$ScrollContainer/VBoxContainer/RichTextLabel.append_text("\n[color="+CBlue+"]Loading Projects[/color]")
	await SearchProjects()
	get_tree().change_scene_to_file("res://ProjectList.tscn")

func SearchProjects():
	attempt+=1
	if attempt > 3:
		failedSavesFolder()
	var files = []
	var directories = []
	var dir = DirAccess.open("user:///saves")

	if dir:
		dir.list_dir_begin()
		_add_dir_contents(dir, files, directories)
	else:
		$ScrollContainer/VBoxContainer/RichTextLabel.append_text("\n[color="+CRed+"]An error occurred when trying to access the path.[/color]")
		await get_tree().create_timer(0.5).timeout
		verifyFolders()
	print(files)
	for i in files:
		if "data.save" in i:
			var f = FileAccess.open(i,FileAccess.READ)
			Console.Projects.append(f.get_line())
	await get_tree().create_timer(0.3).timeout
	$ScrollContainer/VBoxContainer/RichTextLabel.append_text("\n[color="+CGreen+"]Projects Loaded[/color]")
	await get_tree().create_timer(0.5).timeout


func _add_dir_contents(dir: DirAccess, files: Array, directories: Array):
	var file_name = dir.get_next()

	while (file_name != ""):
		var path = dir.get_current_dir() + "/" + file_name

		if dir.current_is_dir():
			print("Found directory: "+path)
			#$VBoxContainer/RichTextLabel.append_text("\n[color="+CWhite+"]Found directory: "+path+"[/color]")
			var subDir = DirAccess.open(path)
			subDir.list_dir_begin()
			directories.append(path)
			_add_dir_contents(subDir, files, directories)
		else:
			print("Found File: "+path)
			$ScrollContainer/VBoxContainer/RichTextLabel.append_text("\n[color="+CWhite+"]Found File: "+path+"[/color]")
			files.append(path)

		file_name = dir.get_next()

	dir.list_dir_end()

func verifyFolders():
	$ScrollContainer/VBoxContainer/RichTextLabel.append_text('\n[color='+CBlue+']Creating "saves" Folder[/color]')
	var d = DirAccess.open("user://")
	d.make_dir_recursive("saves")
	d.open("user:///saves")
	if d:
		$ScrollContainer/VBoxContainer/RichTextLabel.append_text('\n[color='+CGreen+']Successfuly Created "saves" Folder[/color]')
		await get_tree().create_timer(2).timeout
		SearchProjects()
	else:
		failedSavesFolder()

func failedSavesFolder():
	$ScrollContainer/VBoxContainer/RichTextLabel.append_text('\n[color='+CRed+']Failed to create "saves" Folder[/color]')
	$ScrollContainer/VBoxContainer/RichTextLabel.append_text('\n[color='+CRed+']Aborting...[/color]')
	await get_tree().create_timer(999999999999999999).timeout

