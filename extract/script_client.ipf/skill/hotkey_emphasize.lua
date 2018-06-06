-- hotkey_emphasize.lua


function SCR_ENEMY_IS_DOWN_STATE(skl)

	local dist = 100;
	return world.FrontSearchDownEnemy(dist);
end