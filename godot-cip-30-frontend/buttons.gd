extends GridContainer

class_name Buttons

var _godot_wallet
var _paima_middleware
var _window

func _init(godot_wallet, window):
	_godot_wallet = godot_wallet
	_window = window

# Called when the node enters the scene tree for the first time.
func _ready():
	prints("_ready buttons")
	if _godot_wallet:
		add_test_sign_button()
	if _window && _window.paima:
		print("init Paima")
		add_paima_game_buttons(_window)
#
func add_paima_game_buttons(window):
	_paima_middleware = PaimaMiddleware.new(window)
	var loginB = Button.new()
	loginB.text = "Paima login with wallet"
	loginB.pressed.connect(_paima_middleware.login)
	add_child(loginB)

func add_test_sign_button():
	var testSignB = Button.new()
	testSignB.text = "Test data sign"
	testSignB.pressed.connect(test_sing)
	add_child(testSignB)

func test_sing():
	const test_data = "godot-test"
	prints("Signing known test data: ", test_data)
	var sign_res = sign_data(test_data.to_utf8_buffer())
	prints("Test sig res key: ", sign_res.value._cose_key_hex())
	prints("Test sig res sig1: ", sign_res.value._cose_sig1_hex())

# TODO: add address to be CIP-30 compliant
func sign_data(pyload):
	return _godot_wallet.single_address_wallet.sign_data("", pyload);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
