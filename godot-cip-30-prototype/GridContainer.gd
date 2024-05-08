extends GridContainer

var window = JavaScriptBridge.get_interface("window")
var console = JavaScriptBridge.get_interface("console")
var peps = window.paima.endpoints
var paimaWallet

# Called when the node enters the scene tree for the first time.
func _ready():
	var loginB = Button.new()
	loginB.text = "Paima login with wallet"
	loginB.pressed.connect(do_login)
	add_child(loginB)
	
	var checkWalletB = Button.new()
	checkWalletB.text = "Check wallet"
	checkWalletB.pressed.connect(doCheckWallet)
	add_child(checkWalletB)
	
	var submitB = Button.new()
	submitB.text = "Move to (0,1)"
	submitB.pressed.connect(doSubmit)
	add_child(submitB)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func doSubmit():
	if !paimaWallet:
		console.error("Wallet is not initialized")
		return
	console.log("performing doSubmit")
	peps.submitMoves(0,1).then(console.log, console.error)

var js_set_wallet = JavaScriptBridge.create_callback(_setWallet)
func _setWallet(args):
	print("setting wallet")
	var wallet = args[0]
	paimaWallet = wallet

func do_login():
	var walletInfo = buildInfo()
	console.log("do_login: wallet info: ", walletInfo)
	var vl = peps.userWalletLogin(walletInfo).then(js_set_wallet)
	console.log("vl: ", vl)
	prints("vl: ", vl)

func doCheckWallet():
	if !paimaWallet:
		console.warn("wallet not set")
	else:
		console.log("The wallet: ", paimaWallet)
	
func buildInfo():
	var pref = jsObj()
	pref.name = "godot"
	var info = jsObj()
	info.mode = 3 #todo: WalletMode.Cardano
	info.preferBatchedMode = true
	info.preference = pref
	return info
	
func jsObj():
	return JavaScriptBridge.create_object("Object")
	
var js_get_stats = JavaScriptBridge.create_callback(_getStats)
func _getStats(args):
	print("getting stats")
	var wallet = args[0]
	var res = peps.getUserStats(wallet.result.walletAddress).then(console.log)
	console.log("getStats: ", res)
