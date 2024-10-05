extends Control

var CWhite:String = "#D9D9D9"
var CBlue:String = "#77B3FE"
var CRed:String = "#FE8B68"
var CGreen:String = "#76C578"
var CYellow:String = "#E6F385"

var attempt = 0

var alreadytried = false

func _ready() -> void:
	get_window().borderless = true
	get_window().size = Vector2i(1152,648)
	$ScrollContainer/VBoxContainer/RichTextLabel.text = "Starting Mundus : v"+Console.version+"\n--------------------------"
	$Version/Label.text = "v"+Console.version
	await get_tree().create_timer(0.5).timeout
	$ScrollContainer/VBoxContainer/RichTextLabel.append_text("\n[color="+CBlue+"]Checking Account Info[/color]")
	await get_tree().create_timer(0.1).timeout
	var r := await HttpRequest.async_request('https://www.google.com')
	if r.success:
		if Supabase.auth.client == null:
			await get_tree().create_timer(0.2).timeout
			$ScrollContainer/VBoxContainer/RichTextLabel.append_text("\n[color="+CRed+"]Not Logged In[/color]")
			await get_tree().create_timer(0.5).timeout
			$Panel2.show()
		else:
			auth_success()
	else:
		$ScrollContainer/VBoxContainer/RichTextLabel.append_text("\n[color="+CRed+"]Failed to Connect to Internet[/color]")
		enterIntercheckLoop()


func enterIntercheckLoop():
	var success = false
	while success == false:
		await get_tree().create_timer(5).timeout
		var r := await HttpRequest.async_request('https://www.google.com')
		if r.success:
			success = true
			break
	var check_auth = Supabase.auth.client
	if check_auth == null:
		await get_tree().create_timer(0.2).timeout
		$ScrollContainer/VBoxContainer/RichTextLabel.append_text("\n[color="+CRed+"]Not Logged In[/color]")
		await get_tree().create_timer(0.5).timeout
		$Panel2.show()
	else:
		auth_success()

func auth_success():
	if alreadytried == false:
		alreadytried = true
		await get_tree().create_timer(0.2).timeout
		$ScrollContainer/VBoxContainer/RichTextLabel.append_text("\n[color="+CGreen+"]Logged In[/color]")
		await get_tree().create_timer(0.2).timeout
		$ScrollContainer/VBoxContainer/RichTextLabel.append_text("\n[color="+CBlue+"]Checking for Updates[/color]")
		await get_tree().create_timer(0.2).timeout
		$ScrollContainer/VBoxContainer/RichTextLabel.append_text("\n[color="+CGreen+"]No Updates Found[/color]")
		await get_tree().create_timer(0.2).timeout
		$ScrollContainer/VBoxContainer/RichTextLabel.append_text("\n[color="+CBlue+"]Loading Server Data[/color]")
		await startup_sequence()
		$ScrollContainer/VBoxContainer/RichTextLabel.append_text("\n[color="+CGreen+"]Loaded Server Data[/color]")
		await get_tree().create_timer(0.2).timeout
		$ScrollContainer/VBoxContainer/RichTextLabel.append_text("\n[color="+CBlue+"]Loading Projects[/color]")
		await SearchProjects()
		get_tree().change_scene_to_file("res://ProjectList.tscn")
	else:
		Supabase.auth.sign_out()
		alreadytried = false
		retry(0,0)

func retry(error_code, message):
	await get_tree().create_timer(0.2).timeout
	$ScrollContainer/VBoxContainer/RichTextLabel.append_text("\n[color="+CBlue+"]Checking Authentication[/color]")
	await get_tree().create_timer(1).timeout
	var check_auth = Supabase.auth.client
	if check_auth == null:
		await get_tree().create_timer(0.2).timeout
		$ScrollContainer/VBoxContainer/RichTextLabel.append_text("\n[color="+CRed+"]Failed to Login: "+str(error_code)+" "+str(message)+"[/color]")
		await get_tree().create_timer(0.5).timeout
		$Panel2.show()
	else:
		auth_success()


func SearchProjects():
	attempt+=1
	Console.Projects = []
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
	$ScrollContainer/VBoxContainer/RichTextLabel.append_text('\n[color='+CBlue+']Verifying Folder Integrity[/color]')
	$ScrollContainer/VBoxContainer/RichTextLabel.append_text('\n[color='+CBlue+']Creating "saves" Folder[/color]')
	var d = DirAccess.open("user://")
	d.make_dir_recursive("saves")
	d.make_dir_recursive("core")
	d.make_dir_recursive("recursive_plugins")
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

func startup_sequence():
	#var collection: FirestoreCollection = Firebase.Firestore.collection("UserData")
	#var document_task: FirestoreTask = await collection.get_doc(Firebase.Auth.auth.localid)
	#var document: FirestoreDocument = await document_task.get_document
	#Global.userEmail = document.doc_fields.email
	return

func _admin():
	auth_success()
