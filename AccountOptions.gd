extends Panel

var subTypeArray = ["hasFreeSubs","hasTinkererSubs","hasMasterSubs"]
var contentArray = ["content-free","content-tinkerer","content-master"]
var subContent = ""
var MyUserInfo

var userEmail
var nextPayment

func _ready():
	var subtype
	$HTTPRequest.request_completed.connect(_on_request_completed)
	$HTTPRequest2.request_completed.connect(_on_request2_completed)
	$HTTPRequest3.request_completed.connect(_on_request3_completed)
	await Firebase.Auth.check_auth_file()
	var collection: FirestoreCollection = Firebase.Firestore.collection("UserData")
	var document_task: FirestoreTask = collection.get_doc(Firebase.Auth.auth.localid)
	var document: FirestoreDocument = await document_task.get_document
	var stripeid = document.doc_fields.stripeId
	await $HTTPRequest.request("https://api.stripe.com/v1/customers/"+stripeid, ["Authorization: Bearer rk_test_51OZyMHJFNNRPqPVNoU6TxyO3PFqMJZicsBQDtwVMcZvrIYNPbBZvlikPluY9HakhyWEVyLmnX5ma7Ix4fuuI0yXY009BS9fAbz","Content-Type: application/x-www-form-urlencoded"])
	await $HTTPRequest2.request("https://api.stripe.com/v1/subscriptions?customer="+str(stripeid)+"&status=active", ["Authorization: Bearer rk_test_51OZyMHJFNNRPqPVNoU6TxyO3PFqMJZicsBQDtwVMcZvrIYNPbBZvlikPluY9HakhyWEVyLmnX5ma7Ix4fuuI0yXY009BS9fAbz"])
	populate_subdata()


func populate_subdata():
	# UserData
	$MarginContainer/HBoxContainer/VBoxContainer3/Panel/MarginContainer/HBoxContainer/SubEmail.text = Global.userEmail
	# SubName
	pass

func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var json = JSON.parse_string(body.get_string_from_utf8())
		print(json)
	else:
		printerr(result)

func _on_request2_completed(result, response_code, headers, body):
	if response_code == 200:
		var json = JSON.parse_string(body.get_string_from_utf8())
		var subscriptionData = json["data"][0]  # The first subscription in the data array
		await $HTTPRequest3.request("https://api.stripe.com/v1/products/"+subscriptionData.items.data[0].plan.product, ["Authorization: Bearer rk_test_51OZyMHJFNNRPqPVNoU6TxyO3PFqMJZicsBQDtwVMcZvrIYNPbBZvlikPluY9HakhyWEVyLmnX5ma7Ix4fuuI0yXY009BS9fAbz"])
		var date = Time.get_datetime_dict_from_unix_time(subscriptionData.current_period_end)
		var subEndTime =  str(date.day).pad_zeros(2)+"/"+str(date.month).pad_zeros(2)+"/"+str(date.year)
		if subscriptionData.cancel_at_period_end == false:
			%NextSubCycle.text = "Next Payment: "+subEndTime
		else:
			%NextSubCycle.text = "Subscribtion Ends: "+subEndTime
		var subPrice = subscriptionData.items.data[0].plan.amount/100
		if subPrice == 0:
			subPrice = "0.00"
		else:
			%CurrentSubPrice.text = "£"+str(subPrice)+"/Month"
	else:
		printerr(result)

func _on_request3_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	%CurrentSubType.text = json.name[0].to_upper() + json.name.substr(1)

func _on_log_out_button_up():
	Firebase.Auth.logout()
	get_tree().change_scene_to_file("res://SplashScreen.tscn")


func _on_closeaccount_button_up():
	get_parent().hide()


func _on_delete_account_button_up():
	Firebase.Auth.delete_user_account()
	Firebase.Auth.logout()
	get_tree().change_scene_to_file("res://SplashScreen.tscn")


func _on_stripe_dashboard_button_up():
	var emailQuery = str(Global.userEmail).split("@")
	emailQuery = str(emailQuery[0]+"%40"+emailQuery[1])
	OS.shell_open("https://billing.stripe.com/p/login/test_3csg332IJ7jCgFOaEE?prefilled_email="+emailQuery)
