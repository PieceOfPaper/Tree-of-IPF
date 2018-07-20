-- targetbuff.lua

t_buff_ui = {};
t_buff_ui["buff_group_cnt"] = 2;
t_buff_ui["slotsets"] = {};
t_buff_ui["slotlist"] = {};
t_buff_ui["captionlist"] = {};
t_buff_ui["slotcount"] = {};
t_buff_ui["txt_x_offset"] = 1;
t_buff_ui["txt_y_offset"] = 1;


function TARGETBUFF_ON_INIT(addon, frame)
 
	addon:RegisterMsg('TARGET_BUFF_ADD', 'TARGETBUFF_ON_MSG');
	addon:RegisterMsg('TARGET_BUFF_REMOVE', 'TARGETBUFF_ON_MSG');
	addon:RegisterMsg('TARGET_BUFF_UPDATE', 'TARGETBUFF_ON_MSG');
	addon:RegisterMsg('TARGET_SET', 'TARGETBUFF_ON_MSG');
	addon:RegisterMsg('TARGET_CLEAR', 'TARGETBUFF_ON_MSG');
	
	INIT_BUFF_UI(frame, t_buff_ui, "TARGET_BUFF_UPDATE");
end 

function TARGET_BUFF_UPDATE(frame, timer, argstr, argnum, passedtime)
	
	local handle= session.GetTargetHandle();
	BUFF_TIME_UPDATE(handle, t_buff_ui);
				
end

s_lsgmsg = "";
s_lasthandle = 0;

function TARGETBUFF_ON_MSG(frame, msg, argStr, argNum)
	
	local handle = session.GetTargetHandle();

	if msg == "TARGET_BUFF_ADD" then

		COMMON_BUFF_MSG(frame, "ADD", argNum, handle, t_buff_ui, argStr);
		
	elseif msg == "TARGET_BUFF_REMOVE" then
		COMMON_BUFF_MSG(frame, "REMOVE", argNum, handle, t_buff_ui, argStr);
		
	elseif msg == "TARGET_BUFF_UPDATE" then
	
		COMMON_BUFF_MSG(frame, "UPDATE", argNum, handle, t_buff_ui, argStr);
	
	elseif msg == "TARGET_SET" then
		if s_lsgmsg == msg and s_lasthandle == handle then
			return;
		end
		
		s_lsgmsg = msg;
		s_lasthandle = handle;
		
		COMMON_BUFF_MSG(frame, "CLEAR", argNum, handle, t_buff_ui);		
		COMMON_BUFF_MSG(frame, "SET", argNum, handle, t_buff_ui);
			
	elseif msg == "TARGET_CLEAR" then
		if s_lsgmsg == msg then
			return;
		end
				
		s_lsgmsg = msg;
	
		COMMON_BUFF_MSG(frame, "CLEAR", argNum, handle, t_buff_ui);
		
	end
	
	TARGET_BUFF_UPDATE(frame);
	
end 