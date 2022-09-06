// get players health
var playerHealth = global.playerHealth;
var playerHealthMax = global.playerHealthMax;
var playerHealthFrac = frac(playerHealth);
var playerMoney = global.playerMoney;
playerHealth -= playerHealthFrac;

// Draw background
draw_sprite(sHudBG, 0, 0, 0);

// Draw number of keys
draw_sprite(sKeyGUI, 0, 70, -1);

draw_set_font(fMoney);
draw_set_color(c_black);
draw_text(80, -1, "x ");
draw_text(86, -1, "0");
draw_set_color(c_white);
// draw money icon
draw_sprite(sMoneyGUI, 0, 70, 7);

// Draw current money count
ones = playerMoney % 10;
tens = floor((playerMoney % 100) / 10);
hundreds = floor((playerMoney % 1000) / 100);

draw_set_font(fMoney);
draw_set_color(c_black);
draw_text(80, 7, hundreds);
draw_text(86, 7, tens);
draw_text(92, 7, ones);
draw_set_color(c_white);


for(var i = 1; i <= playerHealthMax; i++){
	var imageIndex = (i > playerHealth);
	if(i == playerHealth + 1){
		imageIndex += (playerHealthFrac > 0);
		imageIndex += (playerHealthFrac > 0.25);
		imageIndex += (playerHealthFrac > 0.5);
	}
	
	if(i < 6){
		draw_sprite(sHart, imageIndex, 120 + ((i - 1) * 8), 0);
	}
	else{
		draw_sprite(sHart, imageIndex, 120 + ((i - 6) * 8), 8);
	}
}