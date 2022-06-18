/// @desc Essential Entity Setup

z = 0;
flash = 0;
lifted = 0;
thrown = false;
uFlash = shader_get_uniform(shWhiteFlash, "flash");

if(entityRespawns){
	// this Creates a spawner if one dose not exist
	createspawner(self, entityToSpawn);	
}

if(collisionMap == -1){
	collisionMap = layer_tilemap_get_id(layer_get_id("Col"));
}