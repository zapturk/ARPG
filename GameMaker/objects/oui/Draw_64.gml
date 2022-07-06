var playerHealth = global.playerHealth;
var playerHealthMax = global.playerHealthMax;
var playerHealthFrac = frac(playerHealth);
playerHealth -= playerHealthFrac;

for(var i = 1; i <= playerHealthMax; i++){
	var imageIndex = (i > playerHealth);
	if(i == playerHealth + 1){
		imageIndex += (playerHealthFrac > 0);
		imageIndex += (playerHealthFrac > 0.25);
		imageIndex += (playerHealthFrac > 0.5);
	}
	draw_sprite(sHart, imageIndex, 4 + ((i - 1) * 8), 2);
}