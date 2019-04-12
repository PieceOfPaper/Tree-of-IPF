
function C_GSCP_SOUND(actor, obj, soundName)

	imcSound.PlaySoundEvent(soundName);

end

function C_GSP_SHOCKWAVE(actor, obj, intensity, time, freq, range)

	world.ShockWave(actor, 2, range, intensity, time, freq, 0);

end

function C_GSP_EFFECT(actor, obj, effectName, scale, nodeName)

	effect.PlayActorEffect(actor, effectName, nodeName, lifeTime, scale);

end

function PLAY_SOUND_EVENT(soundName)
	imcSound.PlaySoundEvent(soundName);
end

