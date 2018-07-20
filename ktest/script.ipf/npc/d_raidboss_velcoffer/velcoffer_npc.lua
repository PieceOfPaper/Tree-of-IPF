function SCR_VELCOFFER_MQ_START_IN_ENTER(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end


function SCR_VELCOPFFER_MQ_END(self)
    AddHelpByName(self, 'TUTO_REGEND_EQUIPMENT')
end