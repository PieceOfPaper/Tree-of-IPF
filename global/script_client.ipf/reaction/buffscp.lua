-- buffscp.lua

function ShadowUmbrella_ENTER(actor, obj, buff)

	actor:PlayEquipAni(1, "b-master_umbrella_ani.xsm");

end

function ShadowUmbrella_LEAVE(actor, obj, buff)

	actor:StopEquipAni(1);

end

function Burrow_ENTER(actor, obj, buff)

end

function Burrow_LEAVE(actor, obj, buff)

	actor:GetAnimation():PlayFixAnim("BORN", 1.0, 0);

end

function StopAni_ENTER(actor, obj, buff)

	actor:GetEffect():EnableVibrate(1, 0.5, 0.5, 50.0);

end

function StopAni_LEAVE(actor, obj, buff)

	

end

function Petrification_ENTER(actor, obj, buff)

	-- actor:GetEffect():EnableVibrate(1, 0.5, 0.5, 50.0); -- ?? ?????? ?? ?????? ??÷? ???.
	-- imcSound.PlaySoundItem(cls.Sound);
	-- actor:PlaySound("SOUNDNAME");

end

function Petrification_LEAVE(actor, obj, buff)

	

end


function ShieldChargeClientScp_ENTER(actor, obj, buff)

	if actor:GetVehicleActor() ~= nil then
		actor:GetAnimation():SetSTDAnim("ASTD_RIDE");
		actor:GetAnimation():SetRUNAnim("SKL_ATAQUE_RUN_RIDE");
		actor:GetAnimation():SetWLKAnim("SKL_ATAQUE_RUN_RIDE");
		actor:GetAnimation():SetTURNAnim("None");
	else
		actor:GetAnimation():SetSTDAnim("ASTD");
		actor:GetAnimation():SetRUNAnim("SKL_ATAQUE_RUN");
		actor:GetAnimation():SetWLKAnim("SKL_ATAQUE_RUN");
		actor:GetAnimation():SetTURNAnim("None");
	end
	actor:SetAlwaysBattleState(true);
end

function ShieldChargeClientScp_LEAVE(actor, obj, buff)

	actor:GetAnimation():ResetSTDAnim();
	actor:GetAnimation():ResetRUNAnim();
	actor:GetAnimation():ResetWLKAnim();
	actor:GetAnimation():ResetTURNAnim();
	actor:SetAlwaysBattleState(false);

end


function SlitheringClientScp_ENTER(actor, obj, buff)

    actor:GetAnimation():SetSTDAnim("SKL_SLITHERING_ASTD");
    actor:GetAnimation():SetRUNAnim("SKL_SLITHERING_AWLK");
    actor:GetAnimation():SetWLKAnim("SKL_SLITHERING_AWLK");
    actor:GetAnimation():SetTURNAnim("None");
    
	actor:SetAlwaysBattleState(true);
end

function SlitheringClientScp_LEAVE(actor, obj, buff)

	actor:GetAnimation():ResetSTDAnim();
	actor:GetAnimation():ResetRUNAnim();
	actor:GetAnimation():ResetWLKAnim();
	actor:GetAnimation():ResetTURNAnim();
	
	actor:SetAlwaysBattleState(false);

end

function PouncingClientScp_ENTER(actor, obj, buff)
    actor:GetAnimation():SetSTDAnim("ASTD");
    actor:GetAnimation():SetRUNAnim("SKL_POUNCING");
    actor:GetAnimation():SetWLKAnim("SKL_POUNCING");
    actor:GetAnimation():SetTURNAnim("None");
    
	actor:SetAlwaysBattleState(true);
end

function PouncingClientScp_LEAVE(actor, obj, buff)
	actor:GetAnimation():ResetSTDAnim();
	actor:GetAnimation():ResetRUNAnim();
	actor:GetAnimation():ResetWLKAnim();
	actor:GetAnimation():ResetTURNAnim();
	
	actor:SetAlwaysBattleState(false);

end

function LimaconClientScp_ENTER(actor, obj, buff)
    actor:GetAnimation():SetSTDAnim("ASTD");
    actor:GetAnimation():SetTURNAnim("None");
	actor:SetMovingShotAnimation("SKL_LIMACON");
	

	actor:SetAlwaysBattleState(true);
end

function LimaconClientScp_LEAVE(actor, obj, buff)
	actor:GetAnimation():ResetSTDAnim();
	actor:GetAnimation():ResetTURNAnim();
	actor:SetMovingShotAnimation("");
	actor:SetAlwaysBattleState(false);

end

function RunningShotClientScp_ENTER(actor, obj, buff)
	actor:SetMovingShotAnimation("ATKRUN");
end

function RunningShotClientScp_LEAVE(actor, obj, buff)
	actor:SetMovingShotAnimation("");
end

function FlutingClientScp_ENTER(actor, obj, buff)

	actor:GetAnimation():SetRUNAnim("SKL_PIEDPIPER_FLUTING");
	actor:GetAnimation():SetWLKAnim("SKL_PIEDPIPER_FLUTING");
	actor:SetAlwaysBattleState(true);
end

function FlutingClientScp_LEAVE(actor, obj, buff)

	actor:GetAnimation():ResetRUNAnim();
	actor:GetAnimation():ResetWLKAnim();
	actor:SetAlwaysBattleState(false);

end


function Murmillo_ChangeStance_ENTER(actor, obj, buff)

	actor:SetAlwaysBattleState(true);

	actor:GetAnimation():SetChangeJumpAnim(true);
	actor:GetAnimation():SetTURNAnim("SKL_MURMILLO_ATURN");
	actor:GetAnimation():SetSTDAnim("SKL_MURMILLO_ASTD");
	actor:GetAnimation():SetRUNAnim("SKL_MURMILLO_ARUN");
	actor:GetAnimation():SetLANDAnim("SKL_MURMILLO_LAND")
	actor:GetAnimation():SetRAISEAnim("SKL_MURMILLO_RAISE")
	actor:GetAnimation():SetOnAIRAnim("SKL_MURMILLO_ONAIR")
	actor:GetAnimation():SetFALLAnim("SKL_MURMILLO_FALL")
end


function Murmillo_ChangeStance_LEAVE(actor, obj, buff)
	
	actor:SetAlwaysBattleState(false);

	actor:GetAnimation():PlayFixAnim('SKL_MURMILLO_OFF', 1, 0);
	actor:GetAnimation():SetChangeJumpAnim(false);
	actor:GetAnimation():InitJumpAnimation();
	actor:GetAnimation():ResetTURNAnim();
	actor:GetAnimation():ResetSTDAnim();
	actor:GetAnimation():ResetRUNAnim();

end


function BeakMask_ENTER(actor, obj, buff)


	actor:SetAlwaysBattleState(true);
	
end


function BeakMask_LEAVE(actor, obj, buff)
	
	actor:SetAlwaysBattleState(false);
	actor:GetAnimation():PlayFixAnim('SKL_BEAKMASK_OFF', 1, 0);

end


function Finestra_ENTER(actor, obj, buff)

	actor:SetAlwaysBattleState(true);

	if actor:GetVehicleActor() ~= nil then
	--actor:GetAnimation():SetChangeJumpAnim(true);
	actor:GetAnimation():SetTURNAnim("SKL_FINESTRA_ATURN_RIDE");
	actor:GetAnimation():SetSTDAnim("SKL_FINESTRA_ASTD_RIDE");
	actor:GetAnimation():SetRUNAnim("SKL_FINESTRA_ARUN_RIDE");
	actor:GetAnimation():SetLANDAnim("SKL_FINESTRA_LAND_RIDE")
	actor:GetAnimation():SetRAISEAnim("SKL_FINESTRA_RAISE_RIDE")
	actor:GetAnimation():SetOnAIRAnim("SKL_FINESTRA_ONAIR_RIDE")
	actor:GetAnimation():SetFALLAnim("SKL_FINESTRA_FALL_RIDE")
	else
	--actor:GetAnimation():SetChangeJumpAnim(true);
	actor:GetAnimation():SetTURNAnim("SKL_FINESTRA_ATURN");
	actor:GetAnimation():SetSTDAnim("SKL_FINESTRA_ASTD");
	actor:GetAnimation():SetRUNAnim("SKL_FINESTRA_ARUN");
	actor:GetAnimation():SetLANDAnim("SKL_FINESTRA_LAND")
	actor:GetAnimation():SetRAISEAnim("SKL_FINESTRA_RAISE")
	actor:GetAnimation():SetOnAIRAnim("SKL_FINESTRA_ONAIR")
	actor:GetAnimation():SetFALLAnim("SKL_FINESTRA_FALL")
	end
end

function Finestra_LEAVE(actor, obj, buff)

	actor:SetAlwaysBattleState(false);
	actor:GetAnimation():SetChangeJumpAnim(false);

	actor:GetAnimation():InitJumpAnimation();
	actor:GetAnimation():ResetTURNAnim();
	actor:GetAnimation():ResetSTDAnim();
	actor:GetAnimation():ResetRUNAnim();

end

function EpeeGarde_ENTER(actor, obj, buff)

	local lhItem = session.GetEquipItemBySpot(item.GetEquipSpotNum("LH"));
	if nil == lhItem then
		return;
	end

	local lhObj = GetIES(lhItem:GetObject());
	if nil == lhObj then
		return;
	end

	actor:SetAlwaysBattleState(true);
	actor:ShowModelByPart('LH', 0, 0);
	actor:GetAnimation():SetSTDAnim("SKL_EPEEGARDE_ASTD");
end

function EpeeGarde_LEAVE(actor, obj, buff)

	actor:SetAlwaysBattleState(false);
	
	actor:GetAnimation():ResetSTDAnim();
	actor:ShowModelByPart('LH', 1, 0);
	actor:GetAnimation():PlayFixAnim("ASTD", 1, 1);
	
end


function HighGuard_ENTER(actor, obj, buff)

	actor:SetAlwaysBattleState(true);

	if actor:GetVehicleActor() ~= nil then
	actor:GetAnimation():InitJumpAnimation();
	actor:GetAnimation():SetTURNAnim("SKL_HIGHGUARD_ATURN_RIDE");
	actor:GetAnimation():SetSTDAnim("SKL_HIGHGUARD_ASTD_RIDE");
	actor:GetAnimation():SetRUNAnim("SKL_HIGHGUARD_ARUN_RIDE");
	else
	actor:GetAnimation():InitJumpAnimation();
	actor:GetAnimation():SetTURNAnim("SKL_HIGHGUARD_ATURN");
	actor:GetAnimation():SetSTDAnim("SKL_HIGHGUARD_ASTD");
	actor:GetAnimation():SetRUNAnim("SKL_HIGHGUARD_ARUN");
	end
end

function HighGuard_LEAVE(actor, obj, buff)

	actor:SetAlwaysBattleState(false);

	actor:GetAnimation():InitJumpAnimation();
	actor:GetAnimation():ResetTURNAnim();
	actor:GetAnimation():ResetSTDAnim();
	actor:GetAnimation():ResetRUNAnim();

end

function CamouflageScp_ENTER(actor, obj, buff)
	actor:SetAlwaysBattleState(true);
	
	actor:GetAnimation():SetTURNAnim("None");
	actor:GetAnimation():SetSTDAnim("HIDE_STD");
	actor:GetAnimation():SetRUNAnim("HIDE_WLK");
	actor:GetAnimation():SetWLKAnim("HIDE_WLK");
end

function CamouflageScp_LEAVE(actor, obj, buff)

	actor:SetAlwaysBattleState(false);

	actor:GetAnimation():ResetTURNAnim();
	actor:GetAnimation():ResetSTDAnim();
	actor:GetAnimation():ResetRUNAnim();
	actor:GetAnimation():ResetWLKAnim();

end




function Proliferation_ENTER(actor, obj, buff)

	if pc.IsBuffApplied(actor, "Thurisaz_Buff") == 1 then
		return;
	end

	actor:SetNodeScale("Bip01 L Hand", 2.0)
	actor:SetNodeScale("Dummy_L_HAND", 1.25)
end

function Proliferation_LEAVE(actor, obj, buff)

	actor:SetNodeScale("Bip01 L Hand", 1.0)
	actor:SetNodeScale("Dummy_L_HAND", 1.0)

end

function ProliferationRH_ENTER(actor, obj, buff)
	--DumpCPP()
	if pc.IsBuffApplied(actor, "Thurisaz_Buff") == 1 then
		return;
	end
		
	actor:SetNodeScale("Bip01 R Hand", 2.0)
	actor:SetNodeScale("Dummy_R_HAND", 1.25)
	actor:SetNodeScale("Dummy_R_dagger", 1.25)
	actor:SetNodeScale("Dummy_R_allebell", 1.25)
	actor:SetNodeScale("Dummy_R_umbrella", 1.25)
	actor:SetNodeScale("Dummy_Shield", 1.25)	
end

function ProliferationRH_LEAVE(actor, obj, buff)
	actor:SetNodeScale("Bip01 R Hand", 1.0)
	actor:SetNodeScale("Dummy_R_HAND", 1.0)
	actor:SetNodeScale("Dummy_R_dagger", 1.0)
	actor:SetNodeScale("Dummy_R_allebell", 1.0)
	actor:SetNodeScale("Dummy_R_umbrella", 1.0)
	actor:SetNodeScale("Dummy_Shield", 1.0)
end


function Biggle_ENTER(actor, obj, buff, rps, dir)
	actor:SetRotateBillboard(1, 0.5, -1);
end
function Biggle_LEAVE(actor, obj, buff)
	actor:SetRotateBillboard(0, 0.5, -1);
end





function Medusa_ENTER(actor, obj, buff)

	actor:GetEffect():EnableVibrate(1, 1, 0.5, 50.0);
	-- imcSound.PlaySoundItem(cls.Sound);
	-- actor:PlaySound("SOUNDNAME");

end

function Medusa_LEAVE(actor, obj, buff)

	

end


-- ????????? ?????
function CalcBuffEffScale(radius)
	local scale = 1;		-- ????. ???? m_radius = 12

	if radius >= 50 then
		scale = 2.5;		-- ????????
	elseif radius >= 20 then
		scale = 2;			-- ????
	elseif radius >= 15 then
		scale = 1.5;		-- ???
	end
	return scale;
end

-- ??????y?o?? FSM???δ? ASTD?????? ?????δ? ???ĳ?????? ???? ???. (?????? ĳ????????? ???)
function IsSkillStateByBuff(isForGuard)

  -- ??????y?
  if info.GetMyPcBuff('TeleCast') ~= nil then
    return 1;
  end

  -- ???????
	if isForGuard == 1 and info.GetMyPcBuff('Impaler_Buff') ~= nil then
	  return 1;
	end
  return 0;
end

function IsSkillStateOnCompanionByBuff()
	-- ??????y?
  if info.GetMyPcBuff('TeleCast') ~= nil then
    return 1;
  end

  if info.GetMyPcBuff('Impaler_Buff') ~= nil then
    return 1;
  end

  return 0;
end

function TimeReverseClient_ENTER(actor, obj, buff)
	
	local reserveTime = buff.arg1 / 2000;
	actor:StartTimeReserveCmd(reserveTime);
end

function TimeReverseClient_LEAVE(actor, obj, buff)

end

function PlantGuard_ENTER(actor, obj, buff)
	geGrassEffect.EnablePlantSurround(actor, 25);
end

function PlantGuard_LEAVE(actor, obj, buff)
	geGrassEffect.EnablePlantSurround(actor, 0);
end

-- ??
function PoisonBlink_ENTER(actor, obj, buff)
  imcSound.PlaySoundEvent("monster_state_2")
    actor:GetEffect():SetColorBlink(0,0.1,0,0,0.05,0.3,0,0, 1.5, 1);
end

function PoisonBlink_LEAVE(actor, obj, buff)
    actor:GetEffect():SetColorBlink(0,0,0,0,0,0.2,0,1, 0, 1);
end

-- ????
function WoundBlink_ENTER(actor, obj, buff)
    actor:GetEffect():SetColorBlink(0,0,0,0,0.5,0,0,1, 2.5, 1);
end

function WoundBlink_LEAVE(actor, obj, buff)
    actor:GetEffect():SetColorBlink(0,0,0,0,0.5,0,0,1, 0 , 1);
end

-- ???
function FireBlink_ENTER(actor, obj, buff)
    actor:GetEffect():SetColorBlink(0,0,0,0,76,50,0,1, 2.5, 1);
end

function FireBlink_LEAVE(actor, obj, buff)
    actor:GetEffect():SetColorBlink(0,0,0,0,0.5,0.2,0,1, 0 , 1);
end

-- ??м?
function Mokuton_ENTER(actor, obj, buff)
    actor:GetEffect():SetColorBlink(0,0,0,0,0.1,0.11,0.1,0.15, 2.5, 1);
end

function Mokuton_LEAVE(actor, obj, buff)
    actor:GetEffect():SetColorBlink(0,0,0,0,0.5,0.2,0,1, 0 , 1);
end



-- ??????
function SuperDrop_Client_ENTER(actor, obj, buff)
	if buff.arg2 == 1 then
		actor:GetEffect():SetColorBlink(0,0,0,0,1,0.8,0.07,1, 1.5, 1);
	else
		actor:GetEffect():SetColorBlink(0,0,0,0,1,1,1,1, 1.5, 1);
	end
end

function SuperDrop_Client_LEAVE(actor, obj, buff)
	if buff.arg2 == 1 then
		actor:GetEffect():SetColorBlink(0,0,0,0,1,0.8,0.07,1, 0, 1);
	else
		actor:GetEffect():SetColorBlink(0,0,0,0,1,1,1,1, 0 , 1);
	end
	
end

function EliteMonster_ENTER(actor, obj, buff)
	actor:SetAuraInfo("EliteBuff");
end

function EliteMonster_LEAVE(actor, obj, buff)
end

--??|?? ????: ??? ????o?? ??|????? ??? ?뵵
function TwinkleBuff_Client_ENTER(actor, obj, buff)
	if buff.arg2 == 1 then
		actor:GetEffect():SetColorBlink(0,0,0,0,1,0.8,0.07,1, 1.5, 1);
	else
		actor:GetEffect():SetColorBlink(0,0,0,0,1,1,1,1, 1.5, 1);
	end
end

function TwinkleBuff_Client_LEAVE(actor, obj, buff)
	if buff.arg2 == 1 then
		actor:GetEffect():SetColorBlink(0,0,0,0,1,0.8,0.07,1, 0, 1);
	else
		actor:GetEffect():SetColorBlink(0,0,0,0,1,1,1,1, 0 , 1);
	end
	
end

-- ????ν????? ????? ????
function DivineStigma_ENTER(actor, obj, buff)
	actor:GetEffect():SetColorBlink(0,0,0,0,1,0,0,1, 1.5, 1);
end

function DivineStigma_LEAVE(actor, obj, buff)
	actor:GetEffect():SetColorBlink(0,0,0,0,1,0,0,1, 0 , 1);
end
--???
function WhiteBlink_ENTER(actor, obj, buff)
  imcSound.PlaySoundEvent("monster_state_1")
	actor:GetEffect():SetColorBlink(0.1,0.1,0.1,0.1,0.3,0.3,0.3,0.3, 1.5, 1);
end

function WhiteBlink_LEAVE(actor, obj, buff)
	actor:GetEffect():SetColorBlink(0,0,0,0,1,0,0,1, 0 , 1);
end

--??????
function RedBlink_ENTER(actor, obj, buff)
imcSound.PlaySoundEvent("monster_state_1")
	actor:GetEffect():SetColorBlink(0.2,0,0,0,0.45,0.05,0,0, 1.5, 1);
end

function RedBlink_LEAVE(actor, obj, buff)
	actor:GetEffect():SetColorBlink(0,0,0,0,1,0,0,1, 0 , 1);
end

--?????
function BlueBlink_ENTER(actor, obj, buff)
imcSound.PlaySoundEvent("monster_state_1")
	actor:GetEffect():SetColorBlink(0,0,0.1,0,0,0.1,0.4,0, 1.5, 1);
end

function BlueBlink_LEAVE(actor, obj, buff)
	actor:GetEffect():SetColorBlink(0,0,0,0,1,0,0,1, 0 , 1);
end

function OrangeBlink_ENTER(actor, obj, buff)
imcSound.PlaySoundEvent("monster_state_1")
	actor:GetEffect():SetColorBlink(0,0,0.1,0,1,0.3,0,0, 1.5, 1);
end

function OrangeBlink_LEAVE(actor, obj, buff)
	actor:GetEffect():SetColorBlink(0,0,0,0,1,0,0,1, 0 , 1);
end

--?????
function YellowBlink_ENTER(actor, obj, buff)
imcSound.PlaySoundEvent("monster_state_1")
	actor:GetEffect():SetColorBlink(0.2,0.17,0.05,0,0.5,0.4,0.15,0, 1.5, 1);
end

function YellowBlink_LEAVE(actor, obj, buff)
	actor:GetEffect():SetColorBlink(0,0,0,0,1,0,0,1, 0 , 1);
end

-- ?????? ????? ????
function Pointing_ENTER(actor, obj, buff)
	actor:GetEffect():SetColorBlink(0,0,0,0,1,0,0,1, 3.0, 1);
end

function Pointing_LEAVE(actor, obj, buff)
	actor:GetEffect():SetColorBlink(0,0,0,0,1,0,0,1, 0 , 1);
end

function CollarBombScp_ENTER(actor, obj, buff)
	actor:GetEffect():SetColorBlink(0,0,0,0,1,0,0,1, 3.0, 1);
end

function CollarBombScp_LEAVE(actor, obj, buff)
	actor:GetEffect():SetColorBlink(0,0,0,0,1,0,0,1, 0 , 1);
end

function rottenScp_ENTER(actor, obj, buff)
	actor:GetEffect():SetColorBlink(0,0,0,0,0,0.1,0,0.1, 1, 1);
end

function rottenScp_LEAVE(actor, obj, buff)
	actor:GetEffect():SetColorBlink(0,0,0,0,0,0.1,0,0.1, 0, 1);
end

function DirtyWallScp_ENTER(actor, obj, buff)
	actor:GetEffect():SetColorBlink(0,0,0,0,0,0.3,0,0.6, 1.4, 1);
end

function DirtyWallScp_LEAVE(actor, obj, buff)
	actor:GetEffect():SetColorBlink(0,0,0,0,0,0.3,0,0.6, 0, 1);
end

function LH_VisibleObject_ENTER(actor, obj, buff, rps, dir)
	actor:ShowModelByPart("LH", 0, 0);
end

function LH_VisibleObject_LEAVE(actor, obj, buff)
	actor:ShowModelByPart("LH", 1, 0);
end

function RH_VisibleObject_ENTER(actor, obj, buff, rps, dir)
	actor:ShowModelByPart("RH", 0, 0);	
end

function RH_VisibleObject_LEAVE(actor, obj, buff)
	actor:ShowModelByPart("RH", 1, 0);
end

function ThrowObject_Biggle_ENTER(actor, obj, buff, rps, dir)
	actor:SetThrowObject(1, 0.5, -1);
end

function ThrowObject_Biggle_LEAVE(actor, obj, buff)
	actor:SetThrowObject(0, 0.5, -1);
end

function Impaler_Astd_ENTER(actor, obj, buff, rps, dir)
	actor:GetAnimation():SetRUNAnim("SKL_IMPALER_ARUN_RIDE");
	actor:GetAnimation():SetSTDAnim("SKL_IMPALER_ASTD_RIDE");
	actor:SetAlwaysBattleState(true);
end

function Impaler_Astd_LEAVE(actor, obj, buff)
	
	actor:GetAnimation():ResetSTDAnim();
	actor:GetAnimation():ResetRUNAnim();
	actor:SetAlwaysBattleState(false);
end


function KneelingShot_ENTER(actor, obj, buff)
	--actor:SetLimitMinTargetRange(50);
	actor:GetAnimation():SetSTDAnim("SKL_KNEELINGSHOT_ASTD");
	actor:SetAlwaysBattleState(true);	
end

function KneelingShot_LEAVE(actor, obj, buff)
	--actor:SetLimitMinTargetRange(0);
	actor:GetAnimation():ResetSTDAnim();
	actor:SetAlwaysBattleState(false);
end

function Bazooka_ENTER(actor, obj, buff)
    actor:SetAlwaysBattleState(true);
    actor:GetAnimation():SetSTDAnim("SKL_BAZOOCA_ASTD");
end

function Bazooka_LEAVE(actor, obj, buff)
    actor:SetAlwaysBattleState(false);
    actor:GetAnimation():ResetSTDAnim();
end

function RetreatShotScp_ENTER(actor, obj, buff)
	if actor:GetVehicleActor() ~= nil then
	 -- actor:GetAnimation():SetSTDAnim("SKL_RETREATSHOT_STD_RIDE");
	  actor:GetAnimation():SetRUNAnim("SKL_RETREATSHOT_RIDE");
		actor:GetAnimation():SetWLKAnim("SKL_RETREATSHOT_RIDE");
		actor:GetAnimation():SetTURNAnim("None");
	end
	
	actor:SetAlwaysBattleState(true);
end

function RetreatShotScp_LEAVE(actor, obj, buff)
	actor:GetAnimation():ResetSTDAnim();
	actor:GetAnimation():ResetRUNAnim();
	actor:GetAnimation():ResetWLKAnim();
	actor:GetAnimation():ResetTURNAnim();
	actor:SetAlwaysBattleState(false);
	
end

function AssaultFireScp_ENTER(actor, obj, buff)
    
    actor:SetAlwaysBattleState(true);
    if actor:GetVehicleActor() ~= nil then
        actor:GetAnimation():SetSTDAnim("SKL_WILDSHOT_LOOP_STD_RIDE");
        actor:GetAnimation():SetRUNAnim("SKL_WILDSHOT_LOOP_RIDE");
        actor:GetAnimation():SetWLKAnim("SKL_WILDSHOT_LOOP_RIDE");
        actor:GetAnimation():SetTURNAnim("None");
        actor:GetAnimation():PlayFixAnim("SKL_WILDSHOT_LOOP_STD_RIDE", 1, 1);
    end
    
    
end

function AssaultFireScp_LEAVE(actor, obj, buff)
    actor:GetAnimation():ResetSTDAnim();
	actor:GetAnimation():ResetRUNAnim();
	actor:GetAnimation():ResetWLKAnim();
	actor:GetAnimation():ResetTURNAnim();
	actor:SetAlwaysBattleState(false);
	actor:GetAnimation():PlayFixAnim("ASTD", 1, 1);
	
end

function WebFlyObject_ENTER(actor, obj, buff)
  actor:GetEffect():SetColorBlink(0.1,0.1,0.1,0.1,0.3,0.3,0.3,0.3, 1.5, 1);
	actor:GetEffect():DownModelToGround(true);
end

function WebFlyObject_LEAVE(actor, obj, buff)
  actor:GetEffect():SetColorBlink(0,0,0,0,1,0,0,1, 0 , 1);
	actor:GetEffect():DownModelToGround(false);
end

function Arrest_ENTER(actor, obj, buff)
  actor:GetEffect():SetColorBlink(0.1,0.1,0.1,0.1,0.3,0.3,0.3,0.3, 1.5, 1);
	local caster = buff:GetHandle();
	hardSkill.LinkToObject(actor, caster, "Warrior_Pull", "Dummy_R_HAND", "Bip01 Spine2");

	if actor:GetObjType() == GT_MONSTER then
		local monCls = GetClassByType("Monster", actor:GetType());
		if monCls.MoveType == "Flying" then
			actor:GetEffect():DownModelToGround(true);
		end
	end
end

function Arrest_LEAVE(actor, obj, buff)
  actor:GetEffect():SetColorBlink(0,0,0,0,1,0,0,1, 0 , 1);
	local caster = buff:GetHandle();
	hardSkill.LinkToObject(nil, caster, "Warrior_Pull", "Dummy_R_HAND", "Bip01 Spine2");

	if actor:GetObjType() == GT_MONSTER then
		local monCls = GetClassByType("Monster", actor:GetType());
		if monCls.MoveType == "Flying" then
			actor:GetEffect():DownModelToGround(false);
		end
	end
end

function TESTUDO_CLIENT_ENTER(actor, obj, buff)


	  actor:GetAnimation():SetTURNAnim("SKL_TESTUDO_ASTD"); 
		actor:GetAnimation():SetSTDAnim("SKL_TESTUDO_ASTD");
		actor:GetAnimation():SetRUNAnim("SKL_TESTUDO_AWLK");
		actor:GetAnimation():SetWLKAnim("SKL_TESTUDO_AWLK");
		actor:SetAlwaysBattleState(true);

	local apc = actor:GetPCApc();
	local lhItemType = apc:GetEquipItem(ES_LH);
	local equipShield = false;
	if item.IsNoneItem(lhItemType) == 1 then
		equipShield = true;
	else
		local itemCls = GetClassByType("Item", lhItemType);
		if itemCls == nil or itemCls.ClassType ~= "Shield" then
			equipShield = true;
		end
	end

	local defShield = GetClass("Item", "SHD01_101");
	if equipShield == true then
		actor:GetSystem():ChangeEquipApperance(ES_LH, defShield.ClassID);
		actor:SetUserValue("TESTUDO_SHIELD", 1);
	end
	
end

function TESTUDO_CLIENT_LEAVE(actor, obj, buff)	

	actor:GetAnimation():ResetSTDAnim();
	actor:GetAnimation():ResetRUNAnim();
	actor:GetAnimation():ResetWLKAnim();
  	actor:GetAnimation():ResetTURNAnim();
  actor:SetAlwaysBattleState(false);
  
  
	if actor:GetUserIValue("TESTUDO_SHIELD") == 1 then
		actor:GetSystem():ChangeEquipApperance(ES_LH, 0);
		actor:SetUserValue("TESTUDO_SHIELD", 0);
	end
	
end

function SCHILTRON_CLIENT_ENTER(actor, obj, buff)

		actor:GetAnimation():SetSTDAnim("SKL_SCHILTRON");
		actor:SetAlwaysBattleState(true);

	
end

function SCHILTRON_CLIENT_LEAVE(actor, obj, buff)	

	actor:GetAnimation():ResetSTDAnim();
	actor:SetAlwaysBattleState(false);
  
	
end

function Burrow_Rogue_CLIENT_ENTER(actor, obj, buff)
	movie.ShowModel(actor:GetHandleVal(), 0);	
end

function Burrow_Rogue_CLIENT_LEAVE(actor, obj, buff)
	movie.ShowModel(actor:GetHandleVal(), 1);
end


function IMPALER_STUN_ANI_ENTER(actor, obj, buff, rps, dir)
	actor:GetAnimation():SetSTDAnim("impaler_stun");
	actor:GetAnimation():PlayFixAnim('impaler_stun', 1, 1);
end

function IMPALER_STUN_ANI_LEAVE(actor, obj, buff)
	actor:GetAnimation():ResetSTDAnim();
	actor:GetAnimation():PlayFixAnim("ASTD", 1.0, 0);
end

function GuildBattleObserve_ENTER(actor, obj, buff)	
    actor:GetEffect():SetColorBlend("GuildPVP", 100, 100, 100, 100, true, 0, false, 0);
end

function GuildBattleObserve_LEAVE(actor, obj, buff)

end

function IronMaiden_ENTER(actor, obj, buff)
    local actorPos = actor:GetPos();
	actor:GetClientMonster():ClientMonsterToPos("pcskill_IronMaiden", "STD", actorPos.x, actorPos.y, actorPos.z, 0, 0);
end

function IronMaiden_LEAVE(actor, obj, buff)
    local actorPos = actor:GetPos();
	actor:GetClientMonster():ClientMonsterToPos("pcskill_IronMaiden", "STD", actorPos.x, actorPos.y, actorPos.z, 0, 1);
end

function Levitation_ENTER(actor, obj, buff)

	actor:SetAlwaysBattleState(true);
	
	actor:GetAnimation():SetTURNAnim("SKL_LEVITATION_ATURN");
	actor:GetAnimation():SetSTDAnim("SKL_LEVITATION_ASTD");
	actor:GetAnimation():SetRUNAnim("SKL_LEVITATION_ARUN");
	actor:GetAnimation():SetWLKAnim("SKL_LEVITATION_ARUN");

end

function Levitation_LEAVE(actor, obj, buff)

	actor:SetAlwaysBattleState(false);
	actor:GetAnimation():ResetTURNAnim();
	actor:GetAnimation():ResetSTDAnim();
	actor:GetAnimation():ResetRUNAnim();
	actor:GetAnimation():ResetWLKAnim();

end

function HoukiBroom_ENTER(actor, obj, buff)
    actor:SetAlwaysBattleState(true);
    actor:GetAnimation():SetTURNAnim("SKL_HOUKIBROOM_LOOP");
    actor:GetAnimation():SetSTDAnim("SKL_HOUKIBROOM_LOOP");
    actor:GetAnimation():SetRUNAnim("SKL_HOUKIBROOM_WLK");
    actor:GetAnimation():SetWLKAnim("SKL_HOUKIBROOM_WLK");
end

function HoukiBroom_LEAVE(actor, obj, buff)
    actor:SetAlwaysBattleState(false);
    actor:GetAnimation():ResetTURNAnim();
    actor:GetAnimation():ResetSTDAnim();
    actor:GetAnimation():ResetRUNAnim();
	actor:GetAnimation():ResetWLKAnim();
	actor:GetAnimation():PlayFixAnim("ASTD", 1.0, 0);
end



function DashRunBlend_ENTER(actor, obj, buff)

	--actor:GetEffect():PlayEffect('I_warrior_dash_run_line2', 0.7, EFTOFFSET_BOTTOM);
	effect.PlayActorEffect(actor, 'I_warrior_dash_run_line2', 'Dummy_emitter', 2.0, 1.7);
	actor:GetEffect():SetColorBlend("DashRun", 100, 100, 100, 100, true, 0, true, 0.15);
end

function DashRunBlend_LEAVE(actor, obj, buff)

end