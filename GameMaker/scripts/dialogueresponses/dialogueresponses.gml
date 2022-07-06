function DialogueResponses(response){
	switch(response){
		case 0:
			break;
		case 1:
			NewTextBox("You gave Response A!");
			break;
		case 2:
			NewTextBox("You gave Respose B! Any further response?", 0, ["3: Yes!", "0:No."]);
			break;
		case 3:
			NewTextBox("Thanks for your responses");
			break;
		default:
			break;
	}
}