-- toolskill_effect.lua

function C_SKL_MAKE_LINKEFT(actor, obj, x, y, z, angle, length, linkID, height, waveLength, duration)

	local rx, ry, rz = GetAroundPosByPos(x, y, z, angle, length);
	actor:MakeSkillLinkEffect(x, y, z, rx, ry, rz, linkID, height, waveLength, duration);
	
end

function C_SKL_MAKE_LINKEFT_NODE(actor, obj, node, angle, length, linkID, height, waveLength, duration)
	local pos = actor:GetPos();
	local rx, ry, rz = GetAroundPosByPos(pos.x, pos.y, pos.z, angle, length);
	actor:MakeSkillLinkEffect_Node(node, rx, ry, rz, linkID, height, waveLength, duration);
end

