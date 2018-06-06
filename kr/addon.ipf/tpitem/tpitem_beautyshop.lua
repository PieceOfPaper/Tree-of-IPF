function TPITEM_INIT_BEAUTY_SHOP_TAB(parent, ctrl)

end

function TPITEM_BEUTYSHOP_GO_SHOP(parent, ctrl)
    pc.ReqExecuteTx_Item('GO_BEAUTYSHOP', '0', '0');
    ui.CloseFrame('tpitem');
end