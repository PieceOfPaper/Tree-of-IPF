


function CARTMENU_ON_INIT(addon, frame)
	addon:RegisterMsg('RINGCOMMANDSELECT', 'REQ_UNRIDE');	
end 


function REQ_UNRIDE(frame, ctrl)

	control.UnRideCart();
end