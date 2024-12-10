extends Control

var score = 0
var doubleOrLoose = false
var topScore = 0
var topUser


func _process(delta: float) -> void:
	if $QuizPanel.quiz_complete:
		$QuizPanel.quiz_complete = false
		rpc("final_score", AuthenticationCredentials.user, score)
	if Input.is_action_pressed("show_chat"):
		$Chat.show()
	if Input.is_action_pressed("hide_chat"):
		$Chat.hide()

func _on_quiz_panel_answered(is_answer_correct):
	if is_answer_correct:
		rpc_id(get_multiplayer_authority(),"answered", AuthenticationCredentials.user)
		if doubleOrLoose:
			score = score + 2
			doubleOrLoose = false
		else:
			score = score + 1
		$QuizPanel/ScoreVar.text = str(score)
	else:
		if doubleOrLoose:
			score = score - 1
			doubleOrLoose = false
			$QuizPanel/ScoreVar.text = str(score)
		rpc_id(get_multiplayer_authority(),"missed", AuthenticationCredentials.user)
		
	lock_answers()
 

@rpc
func answered(user):
	pass


@rpc
func missed(user):
	pass
	
@rpc
func final_score(user, score):
	pass
	
@rpc
func addPlayer():
	pass
	
@rpc
func evaluateScores(scores):
	print("In evaluateScores. I just received this:")
	print(scores)
	topScore = 0
	for k in scores.keys():
		var dict_user = k["name"]
		var dict_score = scores[k]
		print("*******In compare loop")
		print(dict_user)
		print(dict_score)
		print(topScore)
		if topScore < dict_score:
			topScore = dict_score
			topUser = dict_user
	print("--------")
	print(topScore)
	print(topUser)
	$QuizPanel/QuestionLabel.text = str(topUser, " with a score of ", topScore, "!")
	

func lock_answers():
	for answer in $QuizPanel.answer_container.get_children():
		answer.disabled = true
		$QuizPanel/DoubleOrLoose.show()

func _on_double_or_loose_pressed() -> void:
	doubleOrLoose = true
