local s_componentMgr = {};
function REGISTER_COMPONENT(key, component)
    s_componentMgr[key] = component;
end

function GET_COMPONENT(key)
    return s_componentMgr[key];
end

function COMPONENT_CALLBACK_EVENT_SCRIPT(parent, ctrl, callBackFuncPropName)
    local callbackFuncName = ctrl:GetUserValue(callBackFuncPropName);
    local CallBackFunc = _G[callbackFuncName];
    if CallBackFunc ~= nil then
        return CallBackFunc(parent, ctrl);
    end
end