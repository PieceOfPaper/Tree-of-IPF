
function AddAllStats(pc, amount)
	pc.STR_BM = pc.STR_BM + amount;
	pc.DEX_BM = pc.DEX_BM + amount;
	pc.INT_BM = pc.INT_BM + amount;
	pc.CON_BM = pc.CON_BM + amount;
end


function SCR_AddAllStats1_PIECE4_ENTER(pc)
	pc.STR_BM = pc.STR_BM + 1;
	pc.DEX_BM = pc.DEX_BM + 1;
	pc.INT_BM = pc.INT_BM + 1;
	pc.CON_BM = pc.CON_BM + 1;
end

function SCR_AddAllStats1_PIECE4_LEAVE(pc)
	pc.STR_BM = pc.STR_BM - 1;
	pc.DEX_BM = pc.DEX_BM - 1;
	pc.INT_BM = pc.INT_BM - 1;
	pc.CON_BM = pc.CON_BM - 1;
end


-- CHAR1_LOW1
function SET_CHAR1_LOW1_PIECE2_ENTER(pc)

	pc.ArdorBrave_BM = pc.ArdorBrave_BM + 1;

end

function SET_CHAR1_LOW1_PIECE2_LEAVE(pc)

	pc.ArdorBrave_BM = pc.ArdorBrave_BM - 1;

end

-- CHAR1_LOW2
function SET_CHAR1_LOW2_PIECE3_ENTER(pc)

	pc.ShiningShield_BM = pc.ShiningShield_BM + 1;

end

function SET_CHAR1_LOW2_PIECE3_LEAVE(pc)

	pc.ShiningShield_BM = pc.ShiningShield_BM - 1;

end

-- CHAR1_LOW3
function SET_CHAR1_LOW3_PIECE3_ENTER(pc)

	AddAllStats(pc, 5);
	pc.ContinuousVictory_BM = pc.ContinuousVictory_BM + 1;

end

function SET_CHAR1_LOW3_PIECE3_LEAVE(pc)

	AddAllStats(pc, -5);
	pc.ContinuousVictory_BM = pc.ContinuousVictory_BM - 1;

end

-- CHAR2_LOW1
function SET_CHAR2_LOW1_PIECE2_ENTER(pc)

	pc.WhisperFire_BM = pc.WhisperFire_BM + 1;

end

function SET_CHAR2_LOW1_PIECE2_LEAVE(pc)

	pc.WhisperFire_BM = pc.WhisperFire_BM - 1;

end

-- CHAR2_LOW2
function SET_CHAR2_LOW2_PIECE3_ENTER(pc)

	pc.Presence_BM = pc.Presence_BM + 1;

end

function SET_CHAR2_LOW2_PIECE3_LEAVE(pc)

	pc.Presence_BM = pc.Presence_BM - 1;

end

-- CHAR2_LOW3
function SET_CHAR2_LOW3_PIECE3_ENTER(pc)

	AddAllStats(pc, 5);
	pc.DebuffAddDmg_BM = pc.DebuffAddDmg_BM + 10;

end

function SET_CHAR2_LOW3_PIECE3_LEAVE(pc)

	AddAllStats(pc, -5);
	pc.DebuffAddDmg_BM = pc.DebuffAddDmg_BM - 10;

end

-- CHAR3_LOW1
function SET_CHAR3_LOW1_PIECE2_ENTER(pc)

	pc.BreezeFix_BM = pc.BreezeFix_BM + 1;

end

function SET_CHAR3_LOW1_PIECE2_LEAVE(pc)

	pc.BreezeFix_BM = pc.BreezeFix_BM - 1;

end

-- CHAR3_LOW2
function SET_CHAR3_LOW2_PIECE3_ENTER(pc)

	pc.ShockAddDmg_BM = pc.ShockAddDmg_BM + 15;

end

function SET_CHAR3_LOW2_PIECE3_LEAVE(pc)

	pc.ShockAddDmg_BM = pc.ShockAddDmg_BM - 15;

end

-- CHAR3_LOW3
function SET_CHAR3_LOW3_PIECE3_ENTER(pc)

	AddAllStats(pc, 5);
	pc.MistWind_BM = pc.MistWind_BM + 30;

end

function SET_CHAR3_LOW3_PIECE3_LEAVE(pc)

	AddAllStats(pc, -5);
	pc.MistWind_BM = pc.MistWind_BM - 30;

end

--------------------------------------------------
-- CHAR1_1
function SET_CHAR1_1_PIECE2_ENTER(pc)

	pc.STR_BM = pc.STR_BM + 1;

end

function SET_CHAR1_1_PIECE2_LEAVE(pc)

	pc.STR_BM = pc.STR_BM - 1;

end

function SET_CHAR1_1_PIECE4_ENTER(pc)

	AddAllStats(pc, 3);
	pc.OverHeat_BM = pc.OverHeat_BM - 20;

end

function SET_CHAR1_1_PIECE4_LEAVE(pc)

	AddAllStats(pc, -3);
	pc.OverHeat_BM = pc.OverHeat_BM + 20;

end

function SET_CHAR1_1_PIECE6_ENTER(pc)

	AddAllStats(pc, 3);
	pc.IronWill_BM = pc.IronWill_BM + 1;

end

function SET_CHAR1_1_PIECE6_LEAVE(pc)

	AddAllStats(pc, -3);
	pc.IronWill_BM = pc.IronWill_BM - 1;

end

function SET_CHAR1_1_PIECE7_ENTER(pc)

	pc.GuardDelay_BM = pc.GuardDelay_BM - 200;

end

function SET_CHAR1_1_PIECE7_LEAVE(pc)

	pc.GuardDelay_BM = pc.GuardDelay_BM + 200;

end

-- CHAR1_2
function SET_CHAR1_2_PIECE2_ENTER(pc)

	pc.STR_BM = pc.STR_BM + 1;
	pc.DebuffAddDmg_BM = pc.DebuffAddDmg_BM + 2;
end

function SET_CHAR1_2_PIECE2_LEAVE(pc)

	pc.STR_BM = pc.STR_BM - 1;
	pc.DebuffAddDmg_BM = pc.DebuffAddDmg_BM - 2;

end

function SET_CHAR1_2_PIECE4_ENTER(pc)

	AddAllStats(pc, 3);
	pc.FortitudeEndure_BM = pc.FortitudeEndure_BM + 1;

end

function SET_CHAR1_2_PIECE4_LEAVE(pc)

	AddAllStats(pc, -3);
	pc.FortitudeEndure_BM = pc.FortitudeEndure_BM - 1;

end

function SET_CHAR1_2_PIECE6_ENTER(pc)

	AddAllStats(pc, 3);
	pc.PowerKill_BM = pc.PowerKill_BM + 1;

end

function SET_CHAR1_2_PIECE6_LEAVE(pc)

	AddAllStats(pc, -3);
	pc.PowerKill_BM = pc.PowerKill_BM - 1;

end

function SET_CHAR1_2_PIECE7_ENTER(pc)

	pc.AddGuardImpactTime_BM = pc.AddGuardImpactTime_BM + 500;

end

function SET_CHAR1_2_PIECE7_LEAVE(pc)

	pc.AddGuardImpactTime_BM = pc.AddGuardImpactTime_BM - 500;

end

function SET_CHAR1_3_PIECE2_ENTER(pc)

	pc.STR_BM = pc.STR_BM + 1;
	pc.DEX_BM = pc.DEX_BM + 1;
end

function SET_CHAR1_3_PIECE2_LEAVE(pc)

	pc.STR_BM = pc.STR_BM - 1;
	pc.DEX_BM = pc.DEX_BM - 1;
end


function SET_CHAR1_3_PIECE3_ENTER(pc)

	pc.STR_BM = pc.STR_BM + 1;
	pc.DEX_BM = pc.DEX_BM + 1;
	pc.DebuffAddDmg_BM = pc.DebuffAddDmg_BM + 5;
end

function SET_CHAR1_3_PIECE3_LEAVE(pc)

	pc.STR_BM = pc.STR_BM + 1;
	pc.DEX_BM = pc.DEX_BM + 1;
	pc.DebuffAddDmg_BM = pc.DebuffAddDmg_BM - 5;
end



function SET_CHAR1_4_PIECE2_ENTER(pc)

	AddAllStats(pc, 1);
end

function SET_CHAR1_4_PIECE2_LEAVE(pc)

	AddAllStats(pc, -1);
end


function SET_CHAR1_4_PIECE3_ENTER(pc)

	AddAllStats(pc, 1);
	pc.DebuffAddDmg_BM = pc.DebuffAddDmg_BM + 8;
end

function SET_CHAR1_4_PIECE3_LEAVE(pc)

	AddAllStats(pc, 1);
	pc.DebuffAddDmg_BM = pc.DebuffAddDmg_BM - 8;
end


-- CHAR2_1
function SET_CHAR2_1_PIECE2_ENTER(pc)

	pc.ADD_FIRE_BM = pc.ADD_FIRE_BM + 5;

end

function SET_CHAR2_1_PIECE2_LEAVE(pc)

	pc.ADD_FIRE_BM = pc.ADD_FIRE_BM - 5;

end

function SET_CHAR2_1_PIECE4_ENTER(pc)

	pc.DebuffAddFire_BM = pc.DebuffAddFire_BM + 50;

end

function SET_CHAR2_1_PIECE4_LEAVE(pc)

	pc.DebuffAddFire_BM = pc.DebuffAddFire_BM - 50;

end

function SET_CHAR2_1_PIECE6_ENTER(pc)

	pc.CriticalFireDebuff_BM = pc.CriticalFireDebuff_BM + 1;

end

function SET_CHAR2_1_PIECE6_LEAVE(pc)

	pc.CriticalFireDebuff_BM = pc.CriticalFireDebuff_BM - 1;

end

-- CHAR2_2
function SET_CHAR2_2_PIECE2_ENTER(pc)

	pc.ADD_ICE_BM = pc.ADD_ICE_BM + 5;

end

function SET_CHAR2_2_PIECE2_LEAVE(pc)

	pc.ADD_ICE_BM = pc.ADD_ICE_BM - 5;

end

function SET_CHAR2_2_PIECE4_ENTER(pc)

	pc.DebuffAddIce_BM = pc.DebuffAddIce_BM + 50;

end

function SET_CHAR2_2_PIECE4_LEAVE(pc)

	pc.DebuffAddIce_BM = pc.DebuffAddIce_BM - 50;

end

function SET_CHAR2_2_PIECE6_ENTER(pc)

	pc.CriticalIceDebuff_BM = pc.CriticalIceDebuff_BM + 1;

end

function SET_CHAR2_2_PIECE6_LEAVE(pc)

	pc.CriticalIceDebuff_BM = pc.CriticalIceDebuff_BM - 1;

end

-- CHAR3_1
function SET_CHAR3_1_PIECE2_ENTER(pc)

	AddAllStats(pc, 3);
	pc.DebuffAddDmg_BM = pc.DebuffAddDmg_BM + 10;

end

function SET_CHAR3_1_PIECE2_LEAVE(pc)

	AddAllStats(pc, -3);
	pc.DebuffAddDmg_BM = pc.DebuffAddDmg_BM - 10;

end

function SET_CHAR3_1_PIECE4_ENTER(pc)

	AddAllStats(pc, 3);
	pc.RapidFix_BM = pc.RapidFix_BM + 1;

end

function SET_CHAR3_1_PIECE4_LEAVE(pc)

	AddAllStats(pc, -3);
	pc.RapidFix_BM = pc.RapidFix_BM - 1;

end

function SET_CHAR3_1_PIECE6_ENTER(pc)

	AddAllStats(pc, 3);
	pc.KillingShot_BM = pc.KillingShot_BM + 10;

end

function SET_CHAR3_1_PIECE6_LEAVE(pc)

	AddAllStats(pc, -3);
	pc.KillingShot_BM = pc.KillingShot_BM - 10;

end

-- CHAR3_2
function SET_CHAR3_2_PIECE2_ENTER(pc)

	AddAllStats(pc, 3);
	pc.Intension_BM = pc.Intension_BM + 10;

end

function SET_CHAR3_2_PIECE2_LEAVE(pc)

	AddAllStats(pc, -3);
	pc.Intension_BM = pc.Intension_BM - 10;

end

function SET_CHAR3_2_PIECE4_ENTER(pc)

	AddAllStats(pc, 3);
	pc.AimingHold_BM = pc.AimingHold_BM + 1;

end

function SET_CHAR3_2_PIECE4_LEAVE(pc)

	AddAllStats(pc, -3);
	pc.AimingHold_BM = pc.AimingHold_BM - 1;

end

function SET_CHAR3_2_PIECE6_ENTER(pc)

	AddAllStats(pc, 3);
	pc.PrudenceMaxDmg_BM = pc.PrudenceMaxDmg_BM + 20;

end

function SET_CHAR3_2_PIECE6_LEAVE(pc)

	AddAllStats(pc, -3);
	pc.PrudenceMaxDmg_BM = pc.PrudenceMaxDmg_BM - 20;

end

-- ALL_1
function SET_ALL_1_PIECE2_ENTER(pc)

	pc.STR_BM = pc.STR_BM + 10;

end

function SET_ALL_1_PIECE2_LEAVE(pc)

	pc.STR_BM = pc.STR_BM - 10;

end

function SET_ALL_1_PIECE4_ENTER(pc)

	pc.RHP_BM = pc.RHP_BM + 2;

end

function SET_ALL_1_PIECE4_LEAVE(pc)

	pc.RHP_BM = pc.RHP_BM - 2;

end

-- ALL_2
function SET_ALL_2_PIECE2_ENTER(pc)

	pc.DEX_BM = pc.DEX_BM + 10;

end

function SET_ALL_2_PIECE2_LEAVE(pc)

	pc.DEX_BM = pc.DEX_BM - 10;

end

function SET_ALL_2_PIECE4_ENTER(pc)

	pc.CRTATK_BM = pc.CRTATK_BM + 25;

end

function SET_ALL_2_PIECE4_LEAVE(pc)

	pc.CRTATK_BM = pc.CRTATK_BM - 25;

end

-- ALL_3
function SET_ALL_3_PIECE2_ENTER(pc)

	pc.INT_BM = pc.INT_BM + 10;

end

function SET_ALL_3_PIECE2_LEAVE(pc)

	pc.INT_BM = pc.INT_BM - 10;

end

function SET_ALL_3_PIECE4_ENTER(pc)

	pc.RSP_BM = pc.RSP_BM + 2;

end

function SET_ALL_3_PIECE4_LEAVE(pc)

	pc.RSP_BM = pc.RSP_BM - 2;

end

-- ALL_4
function SET_ALL_4_PIECE2_ENTER(pc)

	pc.STR_BM = pc.STR_BM + 20;

end

function SET_ALL_4_PIECE2_LEAVE(pc)

	pc.STR_BM = pc.STR_BM - 20;

end

function SET_ALL_4_PIECE4_ENTER(pc)

	pc.RHP_BM = pc.RHP_BM + 4;

end

function SET_ALL_4_PIECE4_LEAVE(pc)

	pc.RHP_BM = pc.RHP_BM - 4;

end

-- ALL_5
function SET_ALL_5_PIECE2_ENTER(pc)

	pc.DEX_BM = pc.DEX_BM + 20;

end

function SET_ALL_5_PIECE2_LEAVE(pc)

	pc.DEX_BM = pc.DEX_BM - 20;

end

function SET_ALL_5_PIECE4_ENTER(pc)

	pc.CRTATK_BM = pc.CRTATK_BM + 35;

end

function SET_ALL_5_PIECE4_LEAVE(pc)

	pc.CRTATK_BM = pc.CRTATK_BM - 35;

end

-- ALL_6
function SET_ALL_6_PIECE2_ENTER(pc)

	pc.INT_BM = pc.INT_BM + 20;

end

function SET_ALL_6_PIECE2_LEAVE(pc)

	pc.INT_BM = pc.INT_BM - 20;

end

function SET_ALL_6_PIECE4_ENTER(pc)

	pc.RSP_BM = pc.RSP_BM + 4;

end

function SET_ALL_6_PIECE4_LEAVE(pc)

	pc.RSP_BM = pc.RSP_BM - 4;

end


-- set_Armor01_192--
function SCR_Armor01_192_PIECE2_ENTER(pc)
	pc.SR_BM = pc.SR_BM + 1;
end

function SCR_Armor01_192_PIECE2_LEAVE(pc)
	pc.SR_BM = pc.SR_BM - 1;
end

function SCR_Armor01_192_PIECE3_ENTER(pc)
	pc.MHP_BM = pc.MHP_BM + 20;
end

function SCR_Armor01_192_PIECE3_LEAVE(pc)
	pc.MHP_BM = pc.MHP_BM - 20;
end

function SCR_Armor01_192_PIECE4_ENTER(pc)
	pc.MSP_BM = pc.MSP_BM + 10;
end

function SCR_Armor01_192_PIECE4_LEAVE(pc)
	pc.MSP_BM = pc.MSP_BM - 10;
end


-- set_Armor01_193 --
function SCR_Armor01_193_PIECE2_ENTER(pc)
	pc.MHP_BM = pc.MHP_BM + 30;
end

function SCR_Armor01_193_PIECE2_LEAVE(pc)
	pc.MHP_BM = pc.MHP_BM - 30;
end

function SCR_Armor01_193_PIECE3_ENTER(pc)
	pc.MSP_BM = pc.MSP_BM + 15;
end

function SCR_Armor01_193_PIECE3_LEAVE(pc)
	pc.MSP_BM = pc.MSP_BM - 15;
end

function SCR_Armor01_193_PIECE4_ENTER(pc)
	pc.DEF_BM = pc.DEF_BM + 1;
end

function SCR_Armor01_193_PIECE4_LEAVE(pc)
	pc.DEF_BM = pc.DEF_BM - 1;
end


-- set_Armor01_194--
function SCR_Armor01_194_PIECE2_ENTER(pc)
	pc.MSP_BM = pc.MSP_BM + 20;
end

function SCR_Armor01_194_PIECE2_LEAVE(pc)
	pc.MSP_BM = pc.MSP_BM - 20;
end

function SCR_Armor01_194_PIECE3_ENTER(pc)
	pc.MHP_BM = pc.MHP_BM + 40;
end

function SCR_Armor01_194_PIECE3_LEAVE(pc)
	pc.MHP_BM = pc.MHP_BM - 40;
end

function SCR_Armor01_194_PIECE4_ENTER(pc)
	pc.MaxSta_BM = pc.MaxSta_BM + 3;
end

function SCR_Armor01_194_PIECE4_LEAVE(pc)
	pc.MaxSta_BM = pc.MaxSta_BM - 3;
end


-- set_D201 --
function SCR_D201_PIECE2_ENTER(pc)
	pc.Forester_Atk_BM = pc.Forester_Atk_BM + 5;
end

function SCR_D201_PIECE2_LEAVE(pc)
	pc.Forester_Atk_BM = pc.Forester_Atk_BM - 5;
end

function SCR_D201_PIECE3_ENTER(pc)
	pc.DR_BM = pc.DR_BM + 20;
end

function SCR_D201_PIECE3_LEAVE(pc)
	pc.DR_BM = pc.DR_BM - 20;
end


-- set_D202--
function SCR_D202_PIECE2_ENTER(pc)
	pc.MSP_BM = pc.MSP_BM + 20;
end

function SCR_D202_PIECE2_LEAVE(pc)
	pc.MSP_BM = pc.MSP_BM - 20;
end

function SCR_D202_PIECE3_ENTER(pc)
	pc.RSP_BM = pc.RSP_BM + 1;
end

function SCR_D202_PIECE3_LEAVE(pc)
	pc.RSP_BM = pc.RSP_BM - 1;
end


-- set_D203 --
function SCR_D203_PIECE2_ENTER(pc)
	pc.DEF_BM = pc.DEF_BM + 2;
end

function SCR_D203_PIECE2_LEAVE(pc)
	pc.DEF_BM = pc.DEF_BM - 2;
end

function SCR_D203_PIECE3_ENTER(pc)
	pc.Dark_Atk_BM = pc.Dark_Atk_BM + 6;
end

function SCR_D203_PIECE3_LEAVE(pc)
	pc.Dark_Atk_BM = pc.Dark_Atk_BM - 6;
end


-- set_D301 --
function SCR_D301_PIECE2_ENTER(pc)
	pc.ResPoison_BM = pc.ResPoison_BM + 10;
end

function SCR_D301_PIECE2_LEAVE(pc)
	pc.ResPoison_BM = pc.ResPoison_BM - 10;
end

function SCR_D301_PIECE3_ENTER(pc)
	pc.MHP_BM = pc.MHP_BM + 100;
end

function SCR_D301_PIECE3_LEAVE(pc)
	pc.MHP_BM = pc.MHP_BM - 100;
end

function SCR_D301_PIECE4_ENTER(pc)
	pc.DEF_BM = pc.DEF_BM + 3;
end

function SCR_D301_PIECE4_LEAVE(pc)
	pc.DEF_BM = pc.DEF_BM - 3;
end


-- set_D302 --
function SCR_D302_PIECE2_ENTER(pc)
	pc.Widling_Atk_BM = pc.Widling_Atk_BM + 8;
end

function SCR_D302_PIECE2_LEAVE(pc)
	pc.Widling_Atk_BM = pc.Widling_Atk_BM - 8;
end

function SCR_D302_PIECE3_ENTER(pc)
	pc.CRTHR_BM = pc.CRTHR_BM + 100;
end

function SCR_D302_PIECE3_LEAVE(pc)
	pc.CRTHR_BM = pc.CRTHR_BM - 100;
end

function SCR_D302_PIECE4_ENTER(pc)
	pc.MSPD_BM = pc.MSPD_BM + 1;
end

function SCR_D302_PIECE4_LEAVE(pc)
	pc.MSPD_BM = pc.MSPD_BM - 1;
end


-- set_D401 --
function SCR_D401_PIECE2_ENTER(pc)
	pc.MHP_BM = pc.MHP_BM + 100;
end

function SCR_D401_PIECE2_LEAVE(pc)
	pc.MHP_BM = pc.MHP_BM - 100;
end

function SCR_D401_PIECE3_ENTER(pc)
    AddAllStats(pc, 1);
end

function SCR_D401_PIECE3_LEAVE(pc)
    AddAllStats(pc, -1);
end

function SCR_D401_PIECE4_ENTER(pc)
	pc.DR_BM = pc.DR_BM + 40;
end

function SCR_D401_PIECE4_LEAVE(pc)
	pc.DR_BM = pc.DR_BM - 40;
end


-- set_C1_03_Q --
function SCR_C1_03_Q_PIECE2_ENTER(pc)
	pc.ResDark_BM = pc.ResDark_BM + 25;
end

function SCR_C1_03_Q_PIECE2_LEAVE(pc)
	pc.ResDark_BM = pc.ResDark_BM - 25;
end

function SCR_C1_03_Q_PIECE3_ENTER(pc)
    pc.Holy_Atk_BM = pc.Holy_Atk_BM + 6;
end

function SCR_C1_03_Q_PIECE3_LEAVE(pc)
    pc.Holy_Atk_BM = pc.Holy_Atk_BM - 6;
end

function SCR_C1_03_Q_PIECE4_ENTER(pc)
	pc.MHP_BM = pc.MHP_BM + 50;
end

function SCR_C1_03_Q_PIECE4_LEAVE(pc)
	pc.MHP_BM = pc.MHP_BM - 50;
end


-- set_C201--
function SCR_C201_PIECE2_ENTER(pc)
	pc.ResLightning_BM = pc.ResLightning_BM + 40;
end

function SCR_C201_PIECE2_LEAVE(pc)
	pc.ResLightning_BM = pc.ResLightning_BM - 40;
end

function SCR_C201_PIECE3_ENTER(pc)
	pc.MSPD_BM = pc.MSPD_BM + 1;
end

function SCR_C201_PIECE3_LEAVE(pc)
	pc.MSPD_BM = pc.MSPD_BM - 1;
end


-- set_C202 --
function SCR_C202_PIECE2_ENTER(pc)
	pc.Poison_Atk_BM = pc.Poison_Atk_BM + 10;
end

function SCR_C202_PIECE2_LEAVE(pc)
	pc.Poison_Atk_BM = pc.Poison_Atk_BM - 10;
end

function SCR_C202_PIECE3_ENTER(pc)
	pc.MHP_BM = pc.MHP_BM + 100;
end

function SCR_C202_PIECE3_LEAVE(pc)
	pc.MHP_BM = pc.MHP_BM - 100;
end


-- set_C203 --
function SCR_C203_PIECE2_ENTER(pc)
	pc.ResDark_BM = pc.ResDark_BM + 50;
end

function SCR_C203_PIECE2_LEAVE(pc)
	pc.ResDark_BM = pc.ResDark_BM - 50;
end

function SCR_C203_PIECE3_ENTER(pc)
	pc.Paramune_Atk_BM = pc.Paramune_Atk_BM + 10;
end

function SCR_C203_PIECE3_LEAVE(pc)
	pc.Paramune_Atk_BM = pc.Paramune_Atk_BM - 10;
end


-- set_C204 --
function SCR_C204_PIECE2_ENTER(pc)
	pc.MSP_BM = pc.MSP_BM + 40;
end

function SCR_C204_PIECE2_LEAVE(pc)
	pc.MSP_BM = pc.MSP_BM - 40;
end

function SCR_C204_PIECE3_ENTER(pc)
	pc.ATK_BM = pc.ATK_BM + 10;
end

function SCR_C204_PIECE3_LEAVE(pc)
	pc.ATK_BM = pc.ATK_BM - 10;
end


-- set_C205--
function SCR_C205_PIECE2_ENTER(pc)
	pc.MHP_BM = pc.MHP_BM + 120;
end

function SCR_C205_PIECE2_LEAVE(pc)
	pc.MHP_BM = pc.MHP_BM - 120;
end

function SCR_C205_PIECE3_ENTER(pc)
	pc.ResFire_BM = pc.ResFire_BM + 50;
end

function SCR_C205_PIECE3_LEAVE(pc)
	pc.ResFire_BM = pc.ResFire_BM - 50;
end


-- set_C301--
function SCR_C301_PIECE2_ENTER(pc)
	pc.Velnias_Atk_BM = pc.Velnias_Atk_BM + 12;
end

function SCR_C301_PIECE2_LEAVE(pc)
	pc.Velnias_Atk_BM = pc.Velnias_Atk_BM - 12;
end

function SCR_C301_PIECE3_ENTER(pc)
	pc.ResDark_BM = pc.ResDark_BM + 60;
end

function SCR_C301_PIECE3_LEAVE(pc)
	pc.ResDark_BM = pc.ResDark_BM - 60;
end

function SCR_C301_PIECE4_ENTER(pc)
	pc.MSP_BM = pc.MSP_BM + 80;
end

function SCR_C301_PIECE4_LEAVE(pc)
	pc.MSP_BM = pc.MSP_BM - 80;
end


-- set_C303 --
function SCR_C303_PIECE2_ENTER(pc)
	pc.SDR_BM = pc.SDR_BM + 2;
end

function SCR_C303_PIECE2_LEAVE(pc)
	pc.SDR_BM = pc.SDR_BM - 2;
end

function SCR_C303_PIECE3_ENTER(pc)
	pc.Poison_Atk_BM = pc.Poison_Atk_BM + 16;
end

function SCR_C303_PIECE3_LEAVE(pc)
	pc.Poison_Atk_BM = pc.Poison_Atk_BM - 16;
end

function SCR_C303_PIECE4_ENTER(pc)
	pc.MHP_BM = pc.MHP_BM + 150;
end

function SCR_C303_PIECE4_LEAVE(pc)
	pc.MHP_BM = pc.MHP_BM - 150;
end


-- set_C401 --
function SCR_C401_PIECE2_ENTER(pc)
	pc.CRTHR_BM = pc.CRTHR_BM + 200;
end

function SCR_C401_PIECE2_LEAVE(pc)
	pc.CRTHR_BM = pc.CRTHR_BM - 200;
end

function SCR_C401_PIECE3_ENTER(pc)
	pc.ResFire_BM = pc.ResFire_BM + 60;
end

function SCR_C401_PIECE3_LEAVE(pc)
	pc.ResFire_BM = pc.ResFire_BM - 60;
end

function SCR_C401_PIECE4_ENTER(pc)
	pc.ATK_BM = pc.ATK_BM + 15;
end

function SCR_C401_PIECE4_LEAVE(pc)
	pc.ATK_BM = pc.ATK_BM - 15;
end


-- set_B201--
function SCR_B201_PIECE2_ENTER(pc)
	pc.INT_BM = pc.INT_BM + 5;
end

function SCR_B201_PIECE2_LEAVE(pc)
	pc.INT_BM = pc.INT_BM - 5;
end

function SCR_B201_PIECE3_ENTER(pc)
	pc.MSPD_BM = pc.MSPD_BM + 2;
end

function SCR_B201_PIECE3_LEAVE(pc)
	pc.MSPD_BM = pc.MSPD_BM - 2;
end


-- set_B202 --
function SCR_B202_PIECE2_ENTER(pc)
	pc.ResHoly_BM = pc.ResHoly_BM + 60;
end

function SCR_B202_PIECE2_LEAVE(pc)
	pc.ResHoly_BM = pc.ResHoly_BM - 60;
end

function SCR_B202_PIECE3_ENTER(pc)
	pc.CRTATK_BM = pc.CRTATK_BM + 10;
end

function SCR_B202_PIECE3_LEAVE(pc)
	pc.CRTATK_BM = pc.CRTATK_BM - 10;
end


-- set_B203--
function SCR_B203_PIECE2_ENTER(pc)
	pc.SDR_BM = pc.SDR_BM + 3;
end

function SCR_B203_PIECE2_LEAVE(pc)
	pc.SDR_BM = pc.SDR_BM - 3;
end

function SCR_B203_PIECE3_ENTER(pc)
	pc.MHP_BM = pc.MHP_BM + 150;
end

function SCR_B203_PIECE3_LEAVE(pc)
	pc.MHP_BM = pc.MHP_BM - 150;
end


-- set_B204 --
function SCR_B204_PIECE2_ENTER(pc)
	pc.DR_BM = pc.DR_BM + 60;
end

function SCR_B204_PIECE2_LEAVE(pc)
	pc.DR_BM = pc.DR_BM - 60;
end

function SCR_B204_PIECE3_ENTER(pc)
	pc.RHP_BM = pc.RHP_BM + 5;
end

function SCR_B204_PIECE3_LEAVE(pc)
	pc.RHP_BM = pc.RHP_BM - 5;
end


-- set_B205 --
function SCR_B205_PIECE2_ENTER(pc)
	pc.ResIce_BM = pc.ResIce_BM + 80;
end

function SCR_B205_PIECE2_LEAVE(pc)
	pc.ResIce_BM = pc.ResIce_BM - 80;
end

function SCR_B205_PIECE3_ENTER(pc)
	pc.DEF_BM = pc.DEF_BM + 8;
end

function SCR_B205_PIECE3_LEAVE(pc)
	pc.DEF_BM = pc.DEF_BM - 8;
end


-- set_B301--
function SCR_B301_PIECE2_ENTER(pc)
	pc.MSP_BM = pc.MSP_BM + 100;
end

function SCR_B301_PIECE2_LEAVE(pc)
	pc.MSP_BM = pc.MSP_BM - 100;
end

function SCR_B301_PIECE3_ENTER(pc)
	pc.CRTHR_BM = pc.CRTHR_BM + 200;
end

function SCR_B301_PIECE3_LEAVE(pc)
	pc.CRTHR_BM = pc.CRTHR_BM - 200;
end

function SCR_B301_PIECE4_ENTER(pc)
	pc.DR_BM = pc.DR_BM + 80;
end

function SCR_B301_PIECE4_LEAVE(pc)
	pc.DR_BM = pc.DR_BM - 80;
end


-- set_B302 --
function SCR_B302_PIECE2_ENTER(pc)
	pc.ResPoison_BM = pc.ResPoison_BM + 60;
end

function SCR_B302_PIECE2_LEAVE(pc)
	pc.ResPoison_BM = pc.ResPoison_BM - 60;
end

function SCR_B302_PIECE3_ENTER(pc)
	pc.MHP_BM = pc.MHP_BM + 200;
end

function SCR_B302_PIECE3_LEAVE(pc)
	pc.MHP_BM = pc.MHP_BM - 200;
end

function SCR_B302_PIECE4_ENTER(pc)
	pc.Forester_Atk_BM = pc.Forester_Atk_BM + 20;
end

function SCR_B302_PIECE4_LEAVE(pc)
	pc.Forester_Atk_BM = pc.Forester_Atk_BM - 20;
end


-- set_B401--
function SCR_B401_PIECE2_ENTER(pc)
	pc.RHP_BM = pc.RHP_BM + 4;
    pc.RSP_BM = pc.RSP_BM + 4;
end

function SCR_B401_PIECE2_LEAVE(pc)
	pc.RHP_BM = pc.RHP_BM - 4;
    pc.RSP_BM = pc.RSP_BM - 4;
end

function SCR_B401_PIECE3_ENTER(pc)
    AddAllStats(pc, 5);
end

function SCR_B401_PIECE3_LEAVE(pc)
    AddAllStats(pc, -5);
end

function SCR_B401_PIECE4_ENTER(pc)
	pc.ResIce_BM = pc.ResIce_BM + 80;
end

function SCR_B401_PIECE4_LEAVE(pc)
	pc.ResIce_BM = pc.ResIce_BM - 80;
end


-- set_Pokubu --
function SCR_Pokubu_PIECE2_ENTER(pc)
	pc.DEF_BM = pc.DEF_BM + 1;
end

function SCR_Pokubu_PIECE2_LEAVE(pc)
	pc.DEF_BM = pc.DEF_BM - 1;
end

function SCR_Pokubu_PIECE3_ENTER(pc)
	pc.DEX_BM = pc.DEX_BM + 2;
end

function SCR_Pokubu_PIECE3_LEAVE(pc)
	pc.DEX_BM = pc.DEX_BM - 2;
end

function SCR_Pokubu_PIECE4_ENTER(pc)
	pc.MHP_BM = pc.MHP_BM + 100;
end

function SCR_Pokubu_PIECE4_LEAVE(pc)
	pc.MHP_BM = pc.MHP_BM - 100;
end

-- set_001 --
function SCR_set_001_PIECE2_ENTER(pc)
	pc.SR_BM = pc.SR_BM + 1;
end

function SCR_set_001_PIECE2_LEAVE(pc)
	pc.SR_BM = pc.SR_BM - 1;
end

-- set_002 --
function SCR_set_002_PIECE2_ENTER(pc)
	pc.DEF_BM = pc.DEF_BM + 6;
end

function SCR_set_002_PIECE2_LEAVE(pc)
	pc.DEF_BM = pc.DEF_BM - 6;
end

-- set_003 --
function SCR_set_003_PIECE2_ENTER(pc)
	pc.Dark_Atk_BM = pc.DEF_BM + 30;
end

function SCR_set_003_PIECE2_LEAVE(pc)
	pc.Dark_Atk_BM = pc.DEF_BM - 30;
end

-- set_004--
function SCR_set_004_PIECE2_ENTER(pc)
	pc.MSPD_BM = pc.MSPD_BM + 5;
end

function SCR_set_004_PIECE2_LEAVE(pc)
	pc.MSPD_BM = pc.MSPD_BM - 5;
end

-- set_005 --
function SCR_set_005_PIECE2_ENTER(pc)
	pc.ResFire_BM = pc.ResFire_BM + 15;
end

function SCR_set_005_PIECE2_LEAVE(pc)
	pc.ResFire_BM = pc.ResFire_BM - 15;
end

-- set_006 --
function SCR_set_006_PIECE2_ENTER(pc)
	pc.Holy_Atk_BM = pc.Holy_Atk_BM + 168;
	pc.Dark_Atk_BM = pc.Dark_Atk_BM + 168;
end

function SCR_set_006_PIECE2_LEAVE(pc)
	pc.Holy_Atk_BM = pc.Holy_Atk_BM - 168;
	pc.Dark_Atk_BM = pc.Dark_Atk_BM - 168;
end

-- set_007
function SCR_set_007_PIECE2_ENTER(pc)
	pc.RHP_BM = pc.RHP_BM + 16;
end

function SCR_set_007_PIECE2_LEAVE(pc)
	pc.RHP_BM = pc.RHP_BM - 16;
end

function SCR_set_007_PIECE3_ENTER(pc)
	pc.STR_ITEM_BM = pc.STR_ITEM_BM + 1;
	pc.DEX_ITEM_BM = pc.DEX_ITEM_BM + 1;
	pc.CON_ITEM_BM = pc.CON_ITEM_BM + 1;
	pc.INT_ITEM_BM = pc.INT_ITEM_BM + 1;
	pc.MNA_ITEM_BM = pc.MNA_ITEM_BM + 1;
end

function SCR_set_007_PIECE3_LEAVE(pc)
	pc.STR_ITEM_BM = pc.STR_ITEM_BM - 1;
	pc.DEX_ITEM_BM = pc.DEX_ITEM_BM - 1;
	pc.CON_ITEM_BM = pc.CON_ITEM_BM - 1;
	pc.INT_ITEM_BM = pc.INT_ITEM_BM - 1;
	pc.MNA_ITEM_BM = pc.MNA_ITEM_BM - 1;
end

function SCR_set_007_PIECE4_ENTER(pc)
    AddBuff(pc, pc, 'item_set_007_buff');
end

function SCR_set_007_PIECE4_LEAVE(pc)
    RemoveBuff(pc, 'item_set_007_buff');
end

-- set_008
function SCR_set_008_PIECE2_ENTER(pc)
	pc.ResFire_BM = pc.ResFire_BM + 16;
end

function SCR_set_008_PIECE2_LEAVE(pc)
	pc.ResFire_BM = pc.ResFire_BM - 16;
end

-- set_009
function SCR_set_009_PIECE2_ENTER(pc)
	pc.ResFire_BM = pc.ResFire_BM + 16;
end

function SCR_set_009_PIECE2_LEAVE(pc)
	pc.ResFire_BM = pc.ResFire_BM - 16;
end

-- set_010
function SCR_set_010_PIECE2_ENTER(pc)
	pc.ResFire_BM = pc.ResFire_BM + 16;
end

function SCR_set_010_PIECE2_LEAVE(pc)
	pc.ResFire_BM = pc.ResFire_BM - 16;
end


-- set_011
function SCR_set_011_PIECE2_ENTER(pc)
	pc.Velnias_Atk_BM = pc.Velnias_Atk_BM + 6;
end

function SCR_set_011_PIECE2_LEAVE(pc)
	pc.Velnias_Atk_BM = pc.Velnias_Atk_BM - 6;
end

function SCR_set_011_PIECE3_ENTER(pc)
	pc.Velnias_Atk_BM = pc.Velnias_Atk_BM + 8;
end

function SCR_set_011_PIECE3_LEAVE(pc)
    pc.Velnias_Atk_BM = pc.Velnias_Atk_BM - 8;
end

function SCR_set_011_PIECE4_ENTER(pc)
    AddBuff(pc, pc, 'item_set_011pre_buff');
end

function SCR_set_011_PIECE4_LEAVE(pc)
    RemoveBuff(pc, 'item_set_011pre_buff');
end

-- set_012
function SCR_set_012_PIECE2_ENTER(pc)
	pc.STR_ITEM_BM = pc.STR_ITEM_BM + 3;
	pc.DEX_ITEM_BM = pc.DEX_ITEM_BM + 3;
	pc.CON_ITEM_BM = pc.CON_ITEM_BM + 3;
	pc.INT_ITEM_BM = pc.INT_ITEM_BM + 3;
	pc.MNA_ITEM_BM = pc.MNA_ITEM_BM + 3;
end

function SCR_set_012_PIECE2_LEAVE(pc)
	pc.STR_ITEM_BM = pc.STR_ITEM_BM - 3;
	pc.DEX_ITEM_BM = pc.DEX_ITEM_BM - 3;
	pc.CON_ITEM_BM = pc.CON_ITEM_BM - 3;
	pc.INT_ITEM_BM = pc.INT_ITEM_BM - 3;
	pc.MNA_ITEM_BM = pc.MNA_ITEM_BM - 3;
end


-- set_013 --
function SCR_set_013_PIECE2_ENTER(pc)
	pc.CON_ITEM_BM = pc.CON_ITEM_BM + 5;
end

function SCR_set_013_PIECE2_LEAVE(pc)
	pc.CON_ITEM_BM = pc.CON_ITEM_BM - 5;
end

function SCR_set_013_PIECE3_ENTER(pc)
	pc.MaxSta_BM = pc.MaxSta_BM + 10;
end

function SCR_set_013_PIECE3_LEAVE(pc)
    pc.MaxSta_BM = pc.MaxSta_BM - 10;
end

function SCR_set_013_PIECE4_ENTER(pc)
    AddBuff(pc, pc, 'item_set_013pre_buff');
end

function SCR_set_013_PIECE4_LEAVE(pc)
    RemoveBuff(pc, 'item_set_013pre_buff');
end

-- set_016 --
function SCR_set_016_PIECE2_ENTER(pc)
	pc.ResDark_BM = pc.ResDark_BM + 10;
end

function SCR_set_016_PIECE2_LEAVE(pc)
	pc.ResDark_BM = pc.ResDark_BM - 10;
end

function SCR_set_016_PIECE3_ENTER(pc)
	pc.MNA_ITEM_BM = pc.MNA_ITEM_BM + 6;
end

function SCR_set_016_PIECE3_LEAVE(pc)
    pc.MNA_ITEM_BM = pc.MNA_ITEM_BM - 6;
end

function SCR_set_016_PIECE4_ENTER(pc)
    AddBuff(pc, pc, 'item_set_016pre_buff');
end

function SCR_set_016_PIECE4_LEAVE(pc)
    RemoveBuff(pc, 'item_set_016pre_buff');
end

-- set_019
function SCR_set_019_PIECE2_ENTER(pc)
	pc.DR_BM = pc.DR_BM - 188;
	AddBuff(pc, pc, 'item_set_019_buff');
end

function SCR_set_019_PIECE2_LEAVE(pc)
	pc.DR_BM = pc.DR_BM + 188;
	RemoveBuff(pc, 'item_set_019_buff');
end

-- set_020
function SCR_set_020_PIECE2_ENTER(pc)
	pc.DEX_ITEM_BM = pc.DEX_ITEM_BM + 6;
end

function SCR_set_020_PIECE2_LEAVE(pc)
    pc.DEX_ITEM_BM = pc.DEX_ITEM_BM - 6;
end

-- set_021
function SCR_set_021_PIECE2_ENTER(pc)
	pc.MDEF_BM = pc.MDEF_BM + 5;
end

function SCR_set_021_PIECE2_LEAVE(pc)
    pc.MDEF_BM = pc.MDEF_BM - 5;
end

function SCR_set_021_PIECE3_ENTER(pc)
	pc.MDEF_BM = pc.MDEF_BM + 10;
end

function SCR_set_021_PIECE3_LEAVE(pc)
    pc.MDEF_BM = pc.MDEF_BM - 10;
end

function SCR_set_021_PIECE4_ENTER(pc)
	pc.INT_ITEM_BM = pc.INT_ITEM_BM + 15;
end

function SCR_set_021_PIECE4_LEAVE(pc)
    pc.INT_ITEM_BM = pc.INT_ITEM_BM - 15;
end

-- set_022
function SCR_set_022_PIECE2_ENTER(pc)
	pc.DEF_BM = pc.DEF_BM + 5;
end

function SCR_set_022_PIECE2_LEAVE(pc)
    pc.DEF_BM = pc.DEF_BM - 5;
end

function SCR_set_022_PIECE3_ENTER(pc)
	pc.DEF_BM = pc.DEF_BM + 10;
end

function SCR_set_022_PIECE3_LEAVE(pc)
    pc.DEF_BM = pc.DEF_BM - 10;
end

function SCR_set_022_PIECE4_ENTER(pc)
	pc.DR_BM = pc.DR_BM + 15;
end

function SCR_set_022_PIECE4_LEAVE(pc)
    pc.DR_BM = pc.DR_BM - 15;
end

-- set_023
function SCR_set_023_PIECE2_ENTER(pc)
	pc.ResDark_BM = pc.ResDark_BM + 10;
end

function SCR_set_023_PIECE2_LEAVE(pc)
    pc.ResDark_BM = pc.ResDark_BM - 10;
end

function SCR_set_023_PIECE3_ENTER(pc)
	pc.ResDark_BM = pc.ResDark_BM + 20;
end

function SCR_set_023_PIECE3_LEAVE(pc)
    pc.ResDark_BM = pc.ResDark_BM - 20;
end

function SCR_set_023_PIECE4_ENTER(pc)
	pc.MHP_BM = pc.MHP_BM + 1020;
end

function SCR_set_023_PIECE4_LEAVE(pc)
    pc.MHP_BM = pc.MHP_BM - 1020;
end

-- set_024
function SCR_set_024_PIECE2_ENTER(pc)
	AddBuff(pc, pc, 'item_set_024');
end

function SCR_set_024_PIECE2_LEAVE(pc)
    RemoveBuff(pc, 'item_set_024');
end

-- set_025
function SCR_set_025_PIECE2_ENTER(pc)
	pc.Ice_Atk_BM = pc.Ice_Atk_BM + 12;
end

function SCR_set_025_PIECE2_LEAVE(pc)
    pc.Ice_Atk_BM = pc.Ice_Atk_BM - 12;
end

function SCR_set_025_PIECE3_ENTER(pc)
	pc.Ice_Atk_BM = pc.Ice_Atk_BM + 26;
end

function SCR_set_025_PIECE3_LEAVE(pc)
    pc.Ice_Atk_BM = pc.Ice_Atk_BM - 26;
end

function SCR_set_025_PIECE4_ENTER(pc)
	pc.DefAries_BM = pc.DefAries_BM + 25;
end

function SCR_set_025_PIECE4_LEAVE(pc)
    pc.DefAries_BM = pc.DefAries_BM - 25;
end

-- set_026
function SCR_set_026_PIECE2_ENTER(pc)
	pc.Ice_Atk_BM = pc.Ice_Atk_BM + 12;
end

function SCR_set_026_PIECE2_LEAVE(pc)
    pc.Ice_Atk_BM = pc.Ice_Atk_BM - 12;
end

function SCR_set_026_PIECE3_ENTER(pc)
	pc.Ice_Atk_BM = pc.Ice_Atk_BM + 26;
end

function SCR_set_026_PIECE3_LEAVE(pc)
    pc.Ice_Atk_BM = pc.Ice_Atk_BM - 26;
end

function SCR_set_026_PIECE4_ENTER(pc)
	pc.DefStrike_BM = pc.DefStrike_BM + 25;
end

function SCR_set_026_PIECE4_LEAVE(pc)
    pc.DefStrike_BM = pc.DefStrike_BM - 25;
end

-- set_027
function SCR_set_027_PIECE2_ENTER(pc)
	pc.Ice_Atk_BM = pc.Ice_Atk_BM + 12;
end

function SCR_set_027_PIECE2_LEAVE(pc)
    pc.Ice_Atk_BM = pc.Ice_Atk_BM - 12;
end

function SCR_set_027_PIECE3_ENTER(pc)
	pc.Ice_Atk_BM = pc.Ice_Atk_BM + 26;
end

function SCR_set_027_PIECE3_LEAVE(pc)
    pc.Ice_Atk_BM = pc.Ice_Atk_BM - 26;
end

function SCR_set_027_PIECE4_ENTER(pc)
	pc.DefSlash_BM = pc.DefSlash_BM + 25;
end

function SCR_set_027_PIECE4_LEAVE(pc)
    pc.DefSlash_BM = pc.DefSlash_BM - 25;
end

-- set_028
function SCR_set_028_PIECE2_ENTER(pc)
	pc.RSP_BM = pc.RSP_BM + 100;
end

function SCR_set_028_PIECE2_LEAVE(pc)
    pc.RSP_BM = pc.RSP_BM - 100;
end

function SCR_set_028_PIECE3_ENTER(pc)
	pc.Earth_Atk_BM = pc.Earth_Atk_BM + 42;
end

function SCR_set_028_PIECE3_LEAVE(pc)
    pc.Earth_Atk_BM = pc.Earth_Atk_BM - 42;
end

function SCR_set_028_PIECE4_ENTER(pc)
	pc.INT_ITEM_BM = pc.INT_ITEM_BM + 25;
end

function SCR_set_028_PIECE4_LEAVE(pc)
    pc.INT_ITEM_BM = pc.INT_ITEM_BM - 25;
end

-- set_029
function SCR_set_029_PIECE2_ENTER(pc)
	pc.CRTHR_BM = pc.CRTHR_BM + 46;
end

function SCR_set_029_PIECE2_LEAVE(pc)
    pc.CRTHR_BM = pc.CRTHR_BM - 46;
end

function SCR_set_029_PIECE3_ENTER(pc)
	pc.Earth_Atk_BM = pc.Earth_Atk_BM + 42;
end

function SCR_set_029_PIECE3_LEAVE(pc)
    pc.Earth_Atk_BM = pc.Earth_Atk_BM - 42;
end

function SCR_set_029_PIECE4_ENTER(pc)
	pc.DEX_ITEM_BM = pc.DEX_ITEM_BM + 25;
end

function SCR_set_029_PIECE4_LEAVE(pc)
    pc.DEX_ITEM_BM = pc.DEX_ITEM_BM - 25;
end

-- set_030
function SCR_set_030_PIECE2_ENTER(pc)
	pc.RHP_BM = pc.RHP_BM + 190;
end

function SCR_set_030_PIECE2_LEAVE(pc)
    pc.RHP_BM = pc.RHP_BM - 190;
end

function SCR_set_030_PIECE3_ENTER(pc)
	pc.Earth_Atk_BM = pc.Earth_Atk_BM + 42;
end

function SCR_set_030_PIECE3_LEAVE(pc)
    pc.Earth_Atk_BM = pc.Earth_Atk_BM - 42;
end

function SCR_set_030_PIECE4_ENTER(pc)
	pc.STR_ITEM_BM = pc.STR_ITEM_BM + 25;
end

function SCR_set_030_PIECE4_LEAVE(pc)
    pc.STR_ITEM_BM = pc.STR_ITEM_BM - 25;
end

-- set_031
function SCR_set_031_PIECE3_ENTER(pc)
	pc.MDEF_BM = pc.MDEF_BM + 10;
end

function SCR_set_031_PIECE3_LEAVE(pc)
    pc.MDEF_BM = pc.MDEF_BM - 10;
end

-- set_032
function SCR_set_032_PIECE3_ENTER(pc)
	pc.MDEF_BM = pc.MDEF_BM + 14;
end

function SCR_set_032_PIECE3_LEAVE(pc)
    pc.MDEF_BM = pc.MDEF_BM - 14;
end

-- set_033
function SCR_set_033_PIECE3_ENTER(pc)
	pc.MDEF_BM = pc.MDEF_BM + 18;
end

function SCR_set_033_PIECE3_LEAVE(pc)
    pc.MDEF_BM = pc.MDEF_BM - 18;
end

-- set_034
function SCR_set_034_PIECE3_ENTER(pc)
	pc.MDEF_BM = pc.MDEF_BM + 22;
end

function SCR_set_034_PIECE3_LEAVE(pc)
    pc.MDEF_BM = pc.MDEF_BM - 22;
end

-- set 035
function SCR_set_035_PIECE2_ENTER(pc)
	pc.RHP_BM = pc.RHP_BM + 240;
end

function SCR_set_035_PIECE2_LEAVE(pc)
	pc.RHP_BM = pc.RHP_BM - 240;
end

function SCR_set_035_PIECE3_ENTER(pc)
	pc.STR_ITEM_BM = pc.STR_ITEM_BM + 6;
	pc.DEX_ITEM_BM = pc.DEX_ITEM_BM + 6;
	pc.CON_ITEM_BM = pc.CON_ITEM_BM + 6;
	pc.INT_ITEM_BM = pc.INT_ITEM_BM + 6;
	pc.MNA_ITEM_BM = pc.MNA_ITEM_BM + 6;
end

function SCR_set_035_PIECE3_LEAVE(pc)
	pc.STR_ITEM_BM = pc.STR_ITEM_BM - 6;
	pc.DEX_ITEM_BM = pc.DEX_ITEM_BM - 6;
	pc.CON_ITEM_BM = pc.CON_ITEM_BM - 6;
	pc.INT_ITEM_BM = pc.INT_ITEM_BM - 6;
	pc.MNA_ITEM_BM = pc.MNA_ITEM_BM - 6;
end

function SCR_set_035_PIECE4_ENTER(pc)
    AddBuff(pc, pc, 'item_set_035_buff');
	pc.STR_ITEM_BM = pc.STR_ITEM_BM + 12;
	pc.MNA_ITEM_BM = pc.MNA_ITEM_BM + 12;
end

function SCR_set_035_PIECE4_LEAVE(pc)
    RemoveBuff(pc, 'item_set_035_buff');
    	pc.STR_ITEM_BM = pc.STR_ITEM_BM - 12;
	pc.MNA_ITEM_BM = pc.MNA_ITEM_BM - 12;
end

-- set 036
function SCR_set_036_PIECE3_ENTER(pc)
	pc.STR_ITEM_BM = pc.STR_ITEM_BM + 25;
	pc.DEX_ITEM_BM = pc.DEX_ITEM_BM + 25;
	pc.CON_ITEM_BM = pc.CON_ITEM_BM + 25;
	pc.INT_ITEM_BM = pc.INT_ITEM_BM + 25;
	pc.MNA_ITEM_BM = pc.MNA_ITEM_BM + 25;
end

function SCR_set_036_PIECE3_LEAVE(pc)
	pc.STR_ITEM_BM = pc.STR_ITEM_BM - 25;
	pc.DEX_ITEM_BM = pc.DEX_ITEM_BM - 25;
	pc.CON_ITEM_BM = pc.CON_ITEM_BM - 25;
	pc.INT_ITEM_BM = pc.INT_ITEM_BM - 25;
	pc.MNA_ITEM_BM = pc.MNA_ITEM_BM - 25;
end

function SCR_set_036_PIECE4_ENTER(pc)
	pc.MSP_BM = pc.MSP_BM + 1437;
end

function SCR_set_036_PIECE4_LEAVE(pc)
	pc.MSP_BM = pc.MSP_BM - 1437;
end

function SCR_set_036_PIECE6_ENTER(pc)
	pc.Earth_Atk_BM = pc.Earth_Atk_BM + 162;
end

function SCR_set_036_PIECE6_LEAVE(pc)
    pc.Earth_Atk_BM = pc.Earth_Atk_BM - 162;
end

function SCR_set_036_PIECE7_ENTER(pc)
    pc.MATK_BM = pc.MATK_BM + 571;
    pc.MHR_BM = pc.MHR_BM + 69;
end

function SCR_set_036_PIECE7_LEAVE(pc)
    pc.MATK_BM = pc.MATK_BM - 571;
    pc.MHR_BM = pc.MHR_BM - 69;
end

-- set 037

function SCR_set_037_PIECE4_ENTER(pc)
	pc.HR_BM = pc.HR_BM + 100;
	pc.CRTATK_BM = pc.CRTATK_BM + 225;
end

function SCR_set_037_PIECE4_LEAVE(pc)
	pc.CRTATK_BM = pc.CRTATK_BM - 225;
	pc.HR_BM = pc.HR_BM - 100;
end

function SCR_set_037_PIECE6_ENTER(pc)
    pc.DR_BM = pc.DR_BM + 48;
    pc.CRTHR_BM = pc.CRTHR_BM + 72;
end

function SCR_set_037_PIECE6_LEAVE(pc)
    pc.DR_BM = pc.DR_BM - 48;
    pc.CRTHR_BM = pc.CRTHR_BM - 72;
end

function SCR_set_037_PIECE7_ENTER(pc)
    pc.PATK_BM = pc.PATK_BM + 818;
end

function SCR_set_037_PIECE7_LEAVE(pc)
    pc.PATK_BM = pc.PATK_BM - 818;
end

-- set 038

function SCR_set_038_PIECE4_ENTER(pc)
	pc.MHP_BM = pc.MHP_BM + 3942;
end

function SCR_set_038_PIECE4_LEAVE(pc)
	pc.MHP_BM = pc.MHP_BM - 3942;
end

function SCR_set_038_PIECE6_ENTER(pc)
    pc.DEF_BM = pc.DEF_BM + 201;
    AddBuff(pc, pc, 'item_set_038pre_buff');
end

function SCR_set_038_PIECE6_LEAVE(pc)
    pc.DEF_BM = pc.DEF_BM - 201;
    RemoveBuff(pc, 'item_set_038pre_buff');
end

function SCR_set_038_PIECE7_ENTER(pc)
    pc.PATK_BM = pc.PATK_BM + 571;
    pc.MDEF_BM = pc.MDEF_BM + 247;
end

function SCR_set_038_PIECE7_LEAVE(pc)
    pc.PATK_BM = pc.PATK_BM - 571;
    pc.MDEF_BM = pc.MDEF_BM - 247;
end

function SCR_set_039_PIECE2_ENTER(pc)
    pc.CRTHR_BM = pc.CRTHR_BM + 30;
end


function SCR_set_039_PIECE2_LEAVE(pc)
    pc.CRTHR_BM = pc.CRTHR_BM - 30;
end

function SCR_set_039_PIECE3_ENTER(pc)
    pc.PATK_BM = pc.PATK_BM + 120;
    pc.SR_BM = pc.SR_BM + 1;
    AddBuff(pc, pc, 'item_set_039pre_buff');

end

function SCR_set_039_PIECE3_LEAVE(pc)
    pc.PATK_BM = pc.PATK_BM - 120;
    pc.SR_BM = pc.SR_BM - 1;
    RemoveBuff(pc, 'item_set_039pre_buff');
end


function SCR_set_040_PIECE2_ENTER(pc)
    pc.MHR_BM = pc.MHR_BM + 60;
end


function SCR_set_040_PIECE2_LEAVE(pc)
    pc.MHR_BM = pc.MHR_BM - 60;
end

function SCR_set_040_PIECE3_ENTER(pc)
    pc.MATK_BM = pc.MATK_BM + 120;
    pc.SR_BM = pc.SR_BM + 1;
    AddBuff(pc, pc, 'item_set_039pre_buff');

end

function SCR_set_040_PIECE3_LEAVE(pc)
    pc.MATK_BM = pc.MATK_BM - 120;
    pc.SR_BM = pc.SR_BM - 1;
    RemoveBuff(pc, 'item_set_039pre_buff');
end
-- set 041
function SCR_set_041_PIECE1_ENTER(pc)
    AddBuff(pc, pc, 'item_set_041_buff');

end

function SCR_set_041_PIECE1_LEAVE(pc)
    RemoveBuff(pc, 'item_set_041_buff');
end

-- set 042
function SCR_set_042_PIECE1_ENTER(pc)
    AddBuff(pc, pc, 'item_set_042_buff');

end

function SCR_set_042_PIECE1_LEAVE(pc)
    RemoveBuff(pc, 'item_set_042_buff');
end

-- set 043
function SCR_set_043_PIECE1_ENTER(pc)
    AddBuff(pc, pc, 'item_set_043_buff');

end

function SCR_set_043_PIECE1_LEAVE(pc)
    RemoveBuff(pc, 'item_set_043_buff');
end

-- set 045--
function SCR_set_045_PIECE2_ENTER(pc)
    pc.CON_ITEM_BM = pc.CON_ITEM_BM + 25;
end

function SCR_set_045_PIECE2_LEAVE(pc)
    pc.CON_ITEM_BM = pc.CON_ITEM_BM - 25;
end

function SCR_set_045_PIECE3_ENTER(pc)

    AddBuff(pc, pc, 'Res_TS_ATK');

end

function SCR_set_045_PIECE3_LEAVE(pc)
    RemoveBuff(pc, 'Res_TS_ATK');
end

-- set 046--
function SCR_set_046_PIECE2_ENTER(pc)
    pc.SR_BM = pc.SR_BM + 1;
    pc.CRTATK_BM = pc.CRTATK_BM +231;
end

function SCR_set_046_PIECE2_LEAVE(pc)
    pc.SR_BM = pc.SR_BM - 1;
    pc.CRTATK_BM = pc.CRTATK_BM -231;
end

function SCR_set_046_PIECE3_ENTER(pc)
    AddBuff(pc, pc, 'SHOCK_BOOM');
end

function SCR_set_046_PIECE3_LEAVE(pc)
    RemoveBuff(pc,'SHOCK_BOOM');
end
-- set 047--

function SCR_set_047_PIECE2_ENTER(pc)
    pc.MHP_BM = pc.MHP_BM + 1023;
    pc.DEX_ITEM_BM = pc.DEX_ITEM_BM + 10;
end

function SCR_set_047_PIECE2_LEAVE(pc)
    pc.MHP_BM = pc.MHP_BM - 1023;
    pc.DEX_ITEM_BM = pc.DEX_ITEM_BM - 10;
end

function SCR_set_047_PIECE3_ENTER(pc)
    AddBuff(pc, pc, 'DFFENCE_SHIELD_PRE');
end

function SCR_set_047_PIECE3_LEAVE(pc)
    RemoveBuff(pc, 'DFFENCE_SHIELD_PRE');
end

-- set 048--

function SCR_set_048_PIECE2_ENTER(pc)
    pc.MATK_BM = pc.MATK_BM + 120;
end

function SCR_set_048_PIECE2_LEAVE(pc)
    pc.MATK_BM = pc.MATK_BM - 120;
end

function SCR_set_048_PIECE3_ENTER(pc)
    AddBuff(pc, pc, 'STACK_MATK_PRE');
end

function SCR_set_048_PIECE3_LEAVE(pc)
    RemoveBuff(pc, 'STACK_MATK_PRE');
end

function SCR_SET_SUMAZIN01_ENTER(pc)
    pc.INT_BM = pc.INT_BM + 25;
    pc.MNA_BM = pc.MNA_BM + 25;
end

function SCR_SET_SUMAZIN01_LEAVE(pc)
    pc.INT_BM = pc.INT_BM - 25;
    pc.MNA_BM = pc.MNA_BM - 25;
end

function SCR_SET_SUMAZIN02_ENTER(pc)
     pc.MATK_BM = pc.MATK_BM + 571;
end

function SCR_SET_SUMAZIN02_LEAVE(pc)
     pc.MATK_BM = pc.MATK_BM - 571;
end

function SCR_SET_SUMAZIN03_ENTER(pc)
     pc.MSP_BM = pc.MSP_BM + 1435;
end

function SCR_SET_SUMAZIN03_LEAVE(pc)
     pc.MSP_BM = pc.MSP_BM - 1435;
end

function SCR_SET_TIKSLINE01_ENTER(pc)
    pc.DEX_BM = pc.DEX_BM + 25;
    pc.MNA_BM = pc.MNA_BM + 25;
end

function SCR_SET_TIKSLINE01_LEAVE(pc)
    pc.DEX_BM = pc.DEX_BM - 25;
    pc.MNA_BM = pc.MNA_BM - 25;
end

function SCR_SET_TIKSLINE02_ENTER(pc)
    pc.SR_BM = pc.SR_BM + 3;
end

function SCR_SET_TIKSLINE02_LEAVE(pc)
    pc.SR_BM = pc.SR_BM - 3;
end

function SCR_SET_KARUJAS01_ENTER(pc)
    pc.CON_BM = pc.CON_BM + 25;
    pc.DEX_BM = pc.DEX_BM + 25;
end

function SCR_SET_KARUJAS01_LEAVE(pc)
    pc.CON_BM = pc.CON_BM - 25;
    pc.DEX_BM = pc.DEX_BM - 25;
end

function SCR_SET_KARUJAS02_ENTER(pc)
    pc.PATK_BM = pc.PATK_BM + 571;
end

function SCR_SET_KARUJAS02_LEAVE(pc)
    pc.PATK_BM = pc.PATK_BM - 571;
end

function SCR_SET_GYVENIMAS01_ENTER(pc)
    pc.CON_BM = pc.CON_BM + 35;
end

function SCR_SET_GYVENIMAS01_LEAVE(pc)
    pc.CON_BM = pc.CON_BM - 35;
end

function SCR_SET_GYVENIMAS02_ENTER(pc)
    pc.MSPD_BM = pc.MSPD_BM + 1;
end

function SCR_SET_GYVENIMAS02_LEAVE(pc)
    pc.MSPD_BM = pc.MSPD_BM - 1;
end

function SCR_VELCOFFER_COSTUME_SET01_ENTER(pc)
    AddBuff(pc, pc, 'COSTUME_VELCOFFER_SET');
end

function SCR_VELCOFFER_COSTUME_SET01_LEAVE(pc)
   RemoveBuff(pc, 'COSTUME_VELCOFFER_SET');
end

-- set 054
function SCR_set_054_COLONY_ENTER(pc)
    AddBuff(pc, pc, 'item_set_041_buff');

end

function SCR_set_054_COLONY_LEAVE(pc)
    RemoveBuff(pc, 'item_set_041_buff');
end

-- set 055
function SCR_set_055_COLONY_ENTER(pc)
    AddBuff(pc, pc, 'item_set_041_buff');

end

function SCR_set_055_COLONY_LEAVE(pc)
    RemoveBuff(pc, 'item_set_041_buff');
end