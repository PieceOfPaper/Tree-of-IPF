
-- ���ƿ� ����

LIKE_IT_FROM_POSE_NAME = "DOUBLEGUNS"
LIKE_IT_TO_POSE_NAME = "BOW1"

function PLAY_LIKE_IT_DIRECTION(frompc, topc, fromname, toname)

	local fromPoseCls = GetClass("Pose", LIKE_IT_FROM_POSE_NAME);
	local toPoseCls = GetClass("Pose", LIKE_IT_TO_POSE_NAME);

	if frompc == nil or topc == nil or fromPoseCls == nil or toPoseCls == nil then
		return; 
	end

	if IsDead(topc) == 1 then
		return;
	end

	LookAt(frompc,topc)
	PlayPose(frompc, fromPoseCls.ClassID)
	sleep(300)

	MslThrow(frompc, "I_like_force#Dummy_bufficon", 1.0, 0, 0, 0, 0,     1,     0,       100,       1.0, "None", 1.0,        0.0, topc,"Bip01 Head");
	PlayEffect(frompc, 'F_sys_like3#Bip01 Pelvis', 2.0);

	sleep(1000)
	
	PlayAnim(frompc,'STD');

	if IsPoseableCondition(topc) == 1.0 then
		LookAt(topc,frompc)
	end
	
	
	PlayEffect(topc, 'F_sys_like#Dummy_bufficon', 2.0);
	PlayEffect(topc, 'F_sys_like2#Bip01 Pelvis', 2.0);
	if IsPoseableCondition(topc) == 1.0 then
		PlayPose(topc, toPoseCls.ClassID)
	end
	
	
	BroadcastSysMsg(topc, "{Name}Like{Who}", 1, "Name", fromname, "Who", toname);
	sleep(600)

	if IsPoseableCondition(topc) == 1.0 then
		PlayAnim(topc,'STD');
	end

end


function PLAY_LIKE_IT_DIRECTION_SEND(pc, fromname, toname)

	local fromPoseCls = GetClass("Pose", LIKE_IT_FROM_POSE_NAME);

	if pc == nil or fromPoseCls == nil then
		return
	end	

	local x,y,z = GetPos(pc)
	PlayPose(pc, fromPoseCls.ClassID)
	MslThrow(pc, "I_like_force#Dummy_bufficon", 1.0, x-200, y, z-200, 0,     3.5,     0,       100,       1.0, "None", 1.0,        0.0);
	PlayEffect(pc, 'F_sys_like3#Bip01 Pelvis', 2.0);
		
	BroadcastSysMsg(pc, "{Name}Like{Who}", 1, "Name", fromname, "Who", toname);
	
	sleep(1000)
	PlayAnim(pc,'STD');
end


function PLAY_LIKE_IT_DIRECTION_RECEIVE(pc, fromname, toname)

	local toPoseCls = GetClass("Pose", LIKE_IT_TO_POSE_NAME);


	if pc == nil or toPoseCls == nil then
		return
	end

	if IsDead(topc) == 1 then
		return;
	end

	if IsPoseableCondition(pc) == 1.0 then
		PlayPose(pc, toPoseCls.ClassID)
	end

	PlayEffect(pc, 'F_sys_like#Dummy_bufficon', 2.0);
	PlayEffect(pc, 'F_sys_like2#Bip01 Pelvis', 2.0);
	BroadcastSysMsg(pc, "{Name}Like{Who}", 1, "Name", fromname, "Who", toname);

	sleep(1000)
	if IsPoseableCondition(pc) == 1.0 then
		PlayAnim(pc,'STD');
	end

end