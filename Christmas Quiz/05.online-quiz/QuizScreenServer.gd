extends Control


@export_file("*.json") var database_file = "res://02.sending-and-receiving-data/FakeDatabase.json"
@export var turn_delay_in_seconds = 5.0

@onready var database = JSON.parse_string(FileAccess.open(database_file,FileAccess.READ).get_as_text())
@onready var quiz_panel = $QuizPanel
@onready var timer = $Timer
@onready var wait_label = $WaitLabel

#var final_scores = {}
var numPlayers = 0

func _process(delta: float) -> void:
	pass

func _ready():
	timer.start(3.0)
	await(timer.timeout)
	generate_new_question()

@rpc("any_peer")
func final_score(user, score):
	var the_user = database[user]
	AuthenticationCredentials.final_scores[the_user] = score

	print(AuthenticationCredentials.final_scores)
	await get_tree().create_timer(1).timeout
	rpc("evaluateScores", AuthenticationCredentials.final_scores)

@rpc("any_peer")
func answered(user):
	quiz_panel.rpc("update_winner", database[user]["name"])
	timer.start(turn_delay_in_seconds)
	wait_label.rpc("wait", turn_delay_in_seconds)

@rpc("any_peer")
func missed(user):
	quiz_panel.rpc("player_missed", database[user]["name"])
	timer.start(turn_delay_in_seconds)
	wait_label.rpc("wait", turn_delay_in_seconds)
		
@rpc("any_peer","call_local")
func send_score():
	pass
	
@rpc("call_local")
func addPlayer():
	numPlayers = numPlayers + 1
	
@rpc
func evaluateScores(scores):
	pass

func _on_timer_timeout():
	generate_new_question()

func getPlayerScores():
	pass

func generate_new_question():
	var max_index = quiz_panel.available_questions.size() -1
	var question_index = randi_range(0, max_index)
	quiz_panel.rpc("update_question", question_index)
	quiz_panel.update_question(question_index)
