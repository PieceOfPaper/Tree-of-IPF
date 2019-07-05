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

    -- actor:GetEffect():EnableVibrate(1, 0.5, 0.5, 50.0); -- 얼굴 깨지는 것 때문에 임시로 주석.
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
    
    if actor:GetVehicleActor() ~= nil then
        actor:GetAnimation():SetSTDAnim("SKL_POUNCING");
    else
        actor:GetAnimation():SetSTDAnim("SKL_POUNCING_STAND");
    end
    
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

function TaglioClientScp_ENTER(actor, obj, buff)
    actor:GetAnimation():SetSTDAnim("SKL_TAGLIO_STAND");
    actor:GetAnimation():SetRUNAnim("SKL_TAGLIO");
    actor:GetAnimation():SetWLKAnim("SKL_TAGLIO");
    actor:GetAnimation():SetTURNAnim("None");
    
    actor:SetAlwaysBattleState(true);
end

function TaglioClientScp_LEAVE(actor, obj, buff)
    actor:GetAnimation():ResetSTDAnim();
    actor:GetAnimation():ResetRUNAnim();
    actor:GetAnimation():ResetWLKAnim();
    actor:GetAnimation():ResetTURNAnim();
    
    actor:SetAlwaysBattleState(false);
end

function LimaconClientScp_ENTER(actor, obj, buff)
--    actor:GetAnimation():SetSTDAnim("ASTD");
--    actor:GetAnimation():SetTURNAnim("None");
--    actor:SetMovingShotAnimation("SKL_LIMACON");
--    
--
--    actor:SetAlwaysBattleState(true);
    ScpChangeMovingShotAnimationSet(actor, obj, buff);
end

function LimaconClientScp_LEAVE(actor, obj, buff)
    actor:GetAnimation():ResetSTDAnim();
    actor:GetAnimation():ResetTURNAnim();    
    actor:SetMovingShot_MainWAnimation("");
    actor:SetMovingShot_SubWAnimation("");
    actor:SetAlwaysBattleState(false);
    ScpChangeMovingShotAnimationSet(actor, obj, buff);
end

function RunningShotClientScp_ENTER(actor, obj, buff)
--    actor:SetMovingShotAnimation("ATKRUN");
    ScpChangeMovingShotAnimationSet(actor, obj, buff)
end

function RunningShotClientScp_LEAVE(actor, obj, buff)
    actor:SetMovingShotAnimation("");
    ScpChangeMovingShotAnimationSet(actor, obj, buff)
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


function Dragoon_ChangeStance_ENTER(actor, obj, buff)

    actor:SetAlwaysBattleState(true);

--    actor:GetAnimation():SetChangeJumpAnim(true);
--    actor:GetAnimation():SetTURNAnim("SKL_MURMILLO_ATURN");
--    actor:GetAnimation():SetSTDAnim("SKL_MURMILLO_ASTD");
--    actor:GetAnimation():SetRUNAnim("SKL_MURMILLO_ARUN");
--    actor:GetAnimation():SetLANDAnim("SKL_MURMILLO_LAND")
--    actor:GetAnimation():SetRAISEAnim("SKL_MURMILLO_RAISE")
--    actor:GetAnimation():SetOnAIRAnim("SKL_MURMILLO_ONAIR")
--    actor:GetAnimation():SetFALLAnim("SKL_MURMILLO_FALL")
end


function Dragoon_ChangeStance_LEAVE(actor, obj, buff)
    
    actor:SetAlwaysBattleState(false);

    actor:GetAnimation():PlayFixAnim('SKL_DRAGOONHELMET_OFF', 1, 0);
--    actor:GetAnimation():SetChangeJumpAnim(false);
--    actor:GetAnimation():InitJumpAnimation();
--    actor:GetAnimation():ResetTURNAnim();
--    actor:GetAnimation():ResetSTDAnim();
--    actor:GetAnimation():ResetRUNAnim();

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
    actor:GetAnimation():UpdateFixAnim();
    
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

    actor:SetTransfomedNodeScale(1);
    actor:PushSetNodeScale("Proliferation1", "Bip01 L Hand", 2.0);
    actor:PushSetNodeScale("Proliferation2", "Dummy_L_HAND", 1.25);
    actor:PushSetNodeScale("ProliferationRH1", "Bip01 R Hand", 2.0)
    actor:PushSetNodeScale("ProliferationRH2", "Dummy_R_HAND", 1.25)
    actor:PushSetNodeScale("ProliferationRH3", "Dummy_R_dagger", 1.25)
    actor:PushSetNodeScale("ProliferationRH4", "Dummy_R_allebell", 1.25)
    actor:PushSetNodeScale("ProliferationRH5", "Dummy_R_umbrella", 1.25)
    actor:PushSetNodeScale("ProliferationRH6", "Dummy_Shield", 1.25)
end

function Proliferation_LEAVE(actor, obj, buff)
    actor:SetTransfomedNodeScale(0);
	actor:PopSetNodeScale("Proliferation1");
	actor:PopSetNodeScale("Proliferation2");
	actor:PopSetNodeScale("ProliferationRH1");
	actor:PopSetNodeScale("ProliferationRH2");
	actor:PopSetNodeScale("ProliferationRH3");
	actor:PopSetNodeScale("ProliferationRH4");
	actor:PopSetNodeScale("ProliferationRH5");
	actor:PopSetNodeScale("ProliferationRH6");
end

function ProliferationRH_ENTER(actor, obj, buff)
    if pc.IsBuffApplied(actor, "Thurisaz_Buff") == 1 then
        return;
    end

    actor:PushNodeScale("ProliferationRH1", "Bip01 R Hand", 1.0)
    actor:PushNodeScale("ProliferationRH2", "Dummy_R_HAND", 0.25)
    actor:PushNodeScale("ProliferationRH3", "Dummy_R_dagger", 0.25)
    actor:PushNodeScale("ProliferationRH4", "Dummy_R_allebell", 0.25)
    actor:PushNodeScale("ProliferationRH5", "Dummy_R_umbrella", 0.25)
    actor:PushNodeScale("ProliferationRH6", "Dummy_Shield", 0.25)    
end

function ProliferationRH_LEAVE(actor, obj, buff)
	actor:PopNodeScale("ProliferationRH1");
	actor:PopNodeScale("ProliferationRH2");
	actor:PopNodeScale("ProliferationRH3");
	actor:PopNodeScale("ProliferationRH4");
	actor:PopNodeScale("ProliferationRH5");
	actor:PopNodeScale("ProliferationRH6");
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


-- 버프이펙트 크기설정
function CalcBuffEffScale(radius)
    local scale = 1;        -- 기준. 스몰 m_radius = 12

    if radius >= 50 then
        scale = 2.5;        -- 엑스라지
    elseif radius >= 20 then
        scale = 2;          -- 라지
    elseif radius >= 15 then
        scale = 1.5;        -- 미들
    end
    return scale;
end

-- 텔레키네시스처럼 FSM으로는 ASTD이지만 실제로는 스킬캐스팅중 인것들 등록. (버프로 캐스팅중인것 확인)
function IsSkillStateByBuff(isForGuard)

  -- 텔레키네시스
  if info.GetMyPcBuff('TeleCast') ~= nil then
    return 1;
  end

  -- 임페일러
    if isForGuard == 1 and info.GetMyPcBuff('Impaler_Buff') ~= nil then
      return 1;
    end
  return 0;
end

function IsSkillStateOnCompanionByBuff()
    -- 텔레키네시스
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

-- 독
function PoisonBlink_ENTER(actor, obj, buff)
  imcSound.PlaySoundEvent("monster_state_2")
    actor:GetEffect():SetColorBlink(0,0.1,0,0,0.05,0.3,0,0, 1.5, 1);
end

function PoisonBlink_LEAVE(actor, obj, buff)
    actor:GetEffect():SetColorBlink(0,0,0,0,0,0.2,0,1, 0, 1);
end

-- 출혈
function WoundBlink_ENTER(actor, obj, buff)
    actor:GetEffect():SetColorBlink(0,0,0,0,0.5,0,0,1, 2.5, 1);
end

function WoundBlink_LEAVE(actor, obj, buff)
    actor:GetEffect():SetColorBlink(0,0,0,0,0.5,0,0,1, 0 , 1);
end

-- 화염
function FireBlink_ENTER(actor, obj, buff)
    actor:GetEffect():SetColorBlink(0,0,0,0,76,50,0,1, 2.5, 1);
end

function FireBlink_LEAVE(actor, obj, buff)
    actor:GetEffect():SetColorBlink(0,0,0,0,0.5,0.2,0,1, 0 , 1);
end

-- 목둔술
function Mokuton_ENTER(actor, obj, buff)
    actor:GetEffect():SetColorBlink(0,0,0,0,0.1,0.11,0.1,0.15, 2.5, 1);
end

function Mokuton_LEAVE(actor, obj, buff)
    actor:GetEffect():SetColorBlink(0,0,0,0,0.5,0.2,0,1, 0 , 1);
end



-- 대박버프
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



-- Challenge Mode DKP Monster Buff

function ChallengeMode_Client_ENTER(actor, obj, buff)
    if buff.arg2 == 1 then
        actor:GetEffect():SetColorBlink(0,0,0,0,1,0.8,0.07,1, 1.5, 1);
    else
        actor:GetEffect():SetColorBlink(0,0,0,0,180/255,43/255,208/255,1, 1.5, 1);
    end
end

function ChallengeMode_Client_LEAVE(actor, obj, buff)
    if buff.arg2 == 1 then
        actor:GetEffect():SetColorBlink(0,0,0,0,1,3,3,3, 0, 1);
    else
        actor:GetEffect():SetColorBlink(0,0,0,0,1,1,1,1, 0 , 1);
    end
    
end




function EliteMonster_ENTER(actor, obj, buff)
    actor:SetAuraInfo("EliteBuff");
    actor:GetTitle():UpdateCaption();
end

function EliteMonster_LEAVE(actor, obj, buff)
end

--반짝이 버프: 대박 버프처럼 반짝거리기만 하는 용도
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

-- 디바인스티그마 디버프 블링크
function DivineStigma_ENTER(actor, obj, buff)
    actor:GetEffect():SetColorBlink(0,0,0,0,1,0,0,1, 1.5, 1);
end

function DivineStigma_LEAVE(actor, obj, buff)
    actor:GetEffect():SetColorBlink(0,0,0,0,1,0,0,1, 0 , 1);
end
--흰색
function WhiteBlink_ENTER(actor, obj, buff)
  imcSound.PlaySoundEvent("monster_state_1")
    actor:GetEffect():SetColorBlink(0.1,0.1,0.1,0.1,0.3,0.3,0.3,0.3, 1.5, 1);
end

function WhiteBlink_LEAVE(actor, obj, buff)
    actor:GetEffect():SetColorBlink(0,0,0,0,1,0,0,1, 0 , 1);
end

--빨간색
function RedBlink_ENTER(actor, obj, buff)
imcSound.PlaySoundEvent("monster_state_1")
    actor:GetEffect():SetColorBlink(0.2,0,0,0,0.45,0.05,0,0, 1.5, 1);
end

function RedBlink_LEAVE(actor, obj, buff)
    actor:GetEffect():SetColorBlink(0,0,0,0,1,0,0,1, 0 , 1);
end

--파란색
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

--노란색
function YellowBlink_ENTER(actor, obj, buff)
imcSound.PlaySoundEvent("monster_state_1")
    actor:GetEffect():SetColorBlink(0.2,0.17,0.05,0,0.5,0.4,0.15,0, 1.5, 1);
end

function YellowBlink_LEAVE(actor, obj, buff)
    actor:GetEffect():SetColorBlink(0,0,0,0,1,0,0,1, 0 , 1);
end

--금색
function GoldenBlink_ENTER(actor, obj, buff)
    actor:GetEffect():SetColorBlink(0.3,0.22,0.08,0,0,0,0,0, 2, 1);
end

function GoldenBlink_LEAVE(actor, obj, buff)
    actor:GetEffect():SetColorBlink(0,0,0,0,1,0,0,1, 0 , 1);
end


-- 포인팅 디버프 블링크
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

function EmperorsBane_Astd_ENTER(actor, obj, buff, rps, dir)
    actor:GetAnimation():SetSTDAnim("SKL_MURMILLO_EMPEROR'SBANE_ASTD");
    actor:SetAlwaysBattleState(true);
end

function EmperorsBane_Astd_LEAVE(actor, obj, buff)
    actor:GetAnimation():ResetSTDAnim();
    actor:SetAlwaysBattleState(false);
end

function EMPERORSBANE_STUN_ANI_ENTER(actor, obj, buff, rps, dir)
    actor:GetAnimation():SetSTDAnim("stun");
    actor:GetAnimation():PlayFixAnim('stun', 1, 1);
end

function EMPERORSBANE_STUN_ANI_LEAVE(actor, obj, buff)
    actor:GetAnimation():ResetSTDAnim();
    actor:GetAnimation():PlayFixAnim("ASTD", 1.0, 0);
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
    ScpChangeMovingShotAnimationSet(actor, obj, buff);
end

function RetreatShotScp_LEAVE(actor, obj, buff)
    actor:GetAnimation():ResetSTDAnim();
    actor:GetAnimation():ResetRUNAnim();
    actor:GetAnimation():ResetWLKAnim();
    actor:GetAnimation():ResetTURNAnim();
    actor:SetAlwaysBattleState(false);
    ScpChangeMovingShotAnimationSet(actor, obj, buff);
end

function AssaultFireScp_ENTER(actor, obj, buff)
    ScpChangeMovingShotAnimationSet(actor, obj, buff);
end

function AssaultFireScp_LEAVE(actor, obj, buff)
    actor:GetAnimation():ResetSTDAnim();
    actor:GetAnimation():ResetRUNAnim();
    actor:GetAnimation():ResetWLKAnim();
    actor:GetAnimation():ResetTURNAnim();
    actor:SetAlwaysBattleState(false);
    actor:GetAnimation():PlayFixAnim("ASTD", 1, 1);
    ScpChangeMovingShotAnimationSet(actor, obj, buff);
end






function OutrageScp_ENTER(actor, obj, buff)
    ScpChangeMovingShotAnimationSet(actor, obj, buff);
end

function OutrageScp_LEAVE(actor, obj, buff)
    actor:GetAnimation():ResetSTDAnim();
    actor:GetAnimation():ResetRUNAnim();
    actor:GetAnimation():ResetWLKAnim();
    actor:GetAnimation():ResetTURNAnim();
    actor:SetAlwaysBattleState(false);
    actor:GetAnimation():PlayFixAnim("ASTD", 1, 1);
    ScpChangeMovingShotAnimationSet(actor, obj, buff);
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

function ShadowPool_Buff_CLIENT_ENTER(actor, obj, buff)
    movie.ShowModel(actor:GetHandleVal(), 0);   
end

function ShadowPool_Buff_CLIENT_LEAVE(actor, obj, buff)
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
    actor:GetClientMonster():ClientMonsterToPos("pcskill_IronMaiden", "BORN", actorPos.x, actorPos.y, actorPos.z, 0, 0);
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

    if actor:GetVehicleActor() ~= nil then
        effect.PlayActorEffect(actor, 'I_warrior_dash_run_line2', 'Dummy_emitter_pet', 2.0, 1.7);
    else
        effect.PlayActorEffect(actor, 'I_warrior_dash_run_line2', 'Dummy_emitter', 2.0, 1.7);
    end

    actor:GetEffect():SetColorBlend("DashRun", 100, 100, 100, 100, true, 0, true, 0.15);

    --local dir = actor:GetHorizonalDir();
    --actor:GetEffect():SetStartDirection("I_warrior_dash_run_line2", -dir.x, 0, -dir.y);
    
end

function DashRunBlend_LEAVE(actor, obj, buff)

end

function SlitheringDebuffClient_ENTER(actor, obj, buff)
    actor:GetAnimation():SetWLKAnim("RUN");
end

function SlitheringDebuffClient_LEAVE(actor, obj, buff)
    actor:GetAnimation():ResetWLKAnim();
end

function DoubleGunStance_ENTER(actor, obj, buff)
--    actor:ChangeEquipNode(EmAttach.eRHand, "Dummy_Sword");
--    actor:CopyAttachedModel(EmAttach.eLHand, "Dummy_L_HAND");
--    actor:SetAlwaysBattleState(true);
--    actor:SetMovingShotAnimation("DOUBLEGUN_ATKMOVE");
--    
--    actor:GetAnimation():SetTURNAnim("SKL_DOUBLEGUN_ATURN");
--    actor:GetAnimation():SetSTDAnim("SKL_DOUBLEGUN_ASTD");
--    actor:GetAnimation():SetRUNAnim("SKL_DOUBLEGUN_ARUN");
--    actor:GetAnimation():SetLANDAnim("SKL_DOUBLEGUN_LAND")
--    actor:GetAnimation():SetRAISEAnim("SKL_DOUBLEGUN_RAISE")
--    actor:GetAnimation():SetOnAIRAnim("SKL_DOUBLEGUN_ONAIR")
--    actor:GetAnimation():SetFALLAnim("SKL_DOUBLEGUN_FALL")
    ScpChangeMovingShotAnimationSet(actor, obj, buff);    
end

function DoubleGunStance_LEAVE(actor, obj, buff)
    actor:DetachCopiedModel();
    actor:ChangeEquipNode(EmAttach.eRHand, "Dummy_L_HAND");
    actor:SetAlwaysBattleState(false);
    actor:GetAnimation():SetChangeJumpAnim(false);
    actor:SetMovingShotAnimation("");
    actor:GetAnimation():ResetTURNAnim();
    actor:GetAnimation():ResetSTDAnim();
    actor:GetAnimation():ResetRUNAnim();
    ScpChangeMovingShotAnimationSet(actor, obj, buff);
end

function RamMuay_ENTER(actor, obj, buff)
    actor:SetAlwaysBattleState(true);
    actor:GetAnimation():SetChangeJumpAnim(true);
    actor:GetAnimation():SetSTDAnim("SKL_NAKMUAY_ASTD");
    actor:GetAnimation():SetRUNAnim("SKL_NAKMUAY_ARUN");
    actor:GetAnimation():SetTURNAnim("SKL_NAKMUAY_ASTD");
    actor:GetAnimation():SetRAISEAnim("SKL_NAKMUAY_ARAISE");
    actor:GetAnimation():SetOnAIRAnim("SKL_NAKMUAY_AONAIR")
    actor:GetAnimation():SetFALLAnim("SKL_NAKMUAY_AFALL");
    actor:SetAlwaysBattleState(true);
end

function RamMuay_UPDATE(actor, obj, buff)
    local lhItem = session.GetEquipItemBySpot(item.GetEquipSpotNum("LH"));
    local lhObj = GetIES(lhItem:GetObject());
    if lhObj.ClassType == "Artefact" then
        actor:ShowModelByPart("LH", 0, 0);
    end
end

function RamMuay_LEAVE(actor, obj, buff)
    actor:SetAlwaysBattleState(false);
    actor:GetAnimation():SetChangeJumpAnim(false);
    actor:SetMovingShotAnimation("");
    actor:GetAnimation():ResetTURNAnim();
    actor:GetAnimation():ResetSTDAnim();
    actor:GetAnimation():ResetRUNAnim();
end

function ScpChangeMovingShotAnimationSet(actor, obj, buff)
    local buffSwiftStep = actor:GetBuff():GetBuff('SwiftStep_Buff');
    local buffDoubleGunStance = actor:GetBuff():GetBuff('DoubleGunStance_Buff');
    local buffLimacon = actor:GetBuff():GetBuff('Limacon_Buff');
    local RetreatShot = actor:GetBuff():GetBuff('RetreatShot');
    local AssaultFire = actor:GetBuff():GetBuff('AssaultFire_Buff');
    local Outrage = actor:GetBuff():GetBuff('Outrage_Buff');
    
    -- RunningShot_Buff (and) DoubleGunStance_Buff
    if buffSwiftStep ~= nil and buffDoubleGunStance ~= nil and Outrage == nil then
        actor:ChangeEquipNode(EmAttach.eRHand, "Dummy_Sword");
        actor:CopyAttachedModel(EmAttach.eLHand, "Dummy_L_HAND");
        actor:SetAlwaysBattleState(true);
        actor:SetMovingShotAnimation("DOUBLEGUN_ATKRUN");
        
        actor:GetAnimation():SetTURNAnim("SKL_DOUBLEGUN_ATURN");
        actor:GetAnimation():SetSTDAnim("SKL_DOUBLEGUN_ASTD");
        actor:GetAnimation():SetRUNAnim("SKL_DOUBLEGUN_ARUN");
        actor:GetAnimation():SetLANDAnim("SKL_DOUBLEGUN_LAND")
        actor:GetAnimation():SetRAISEAnim("SKL_DOUBLEGUN_RAISE")
--        actor:GetAnimation():SetOnAIRAnim("SKL_DOUBLEGUN_AONAIR")
        actor:GetAnimation():SetFALLAnim("SKL_DOUBLEGUN_FALL")
    -- Outrage_Buff
    elseif Outrage ~= nil and buffDoubleGunStance ~= nil then
        actor:ChangeEquipNode(EmAttach.eRHand, "Dummy_Sword");
        actor:CopyAttachedModel(EmAttach.eLHand, "Dummy_L_HAND");
        actor:SetAlwaysBattleState(true);
        actor:SetMovingShotAnimation("DOUBLEGUN_ATKRUN");
        
        actor:GetAnimation():SetTURNAnim("SKL_DOUBLEGUN_ATURN");
        actor:GetAnimation():SetSTDAnim("SKL_DOUBLEGUN_ASTD");
        actor:GetAnimation():SetRUNAnim("SKL_DOUBLEGUN_ARUN");
        actor:GetAnimation():SetLANDAnim("SKL_DOUBLEGUN_LAND")
        actor:GetAnimation():SetRAISEAnim("SKL_DOUBLEGUN_RAISE")
--        actor:GetAnimation():SetOnAIRAnim("SKL_DOUBLEGUN_AONAIR")
        actor:GetAnimation():SetFALLAnim("SKL_DOUBLEGUN_FALL")
    else
        -- RunningShot_Buff
        if buffSwiftStep ~= nil then
            actor:SetMovingShotAnimation("ATKRUN");
        end
        
        -- DoubleGunStance_Buff
        if buffDoubleGunStance ~= nil then            
            actor:ChangeEquipNode(EmAttach.eRHand, "Dummy_Sword");
            actor:CopyAttachedModel(EmAttach.eLHand, "Dummy_L_HAND");
            actor:SetAlwaysBattleState(true);
            actor:SetMovingShotAnimation("DOUBLEGUN_ATKMOVE");
            actor:GetAnimation():SetTURNAnim("SKL_DOUBLEGUN_ATURN");
            actor:GetAnimation():SetSTDAnim("SKL_DOUBLEGUN_ASTD");
            actor:GetAnimation():SetRUNAnim("SKL_DOUBLEGUN_ARUN");
            actor:GetAnimation():SetLANDAnim("SKL_DOUBLEGUN_LAND")
            actor:GetAnimation():SetRAISEAnim("SKL_DOUBLEGUN_RAISE")
--            actor:GetAnimation():SetOnAIRAnim("SKL_DOUBLEGUN_ONAIR")
            actor:GetAnimation():SetFALLAnim("SKL_DOUBLEGUN_FALL")            
        end
    end
    
    -- Limacon_Buff
    if buffLimacon ~= nil then
         --actor:SetMovingShotAnimation("SKL_LIMACON");
         actor:GetAnimation():SetSTDAnim("ASTD");
         actor:GetAnimation():SetTURNAnim("None");
         actor:SetMovingShot_MainWAnimation("ATKMOVE");
         actor:SetMovingShot_SubWAnimation("SKL_LIMACON");
         actor:SetAlwaysBattleState(true);
    end
    
    -- RetreatShot --
    if actor:GetVehicleActor() ~= nil and RetreatShot ~= nil then
        actor:GetAnimation():SetRUNAnim("SKL_RETREATSHOT_RIDE");
        actor:GetAnimation():SetWLKAnim("SKL_RETREATSHOT_RIDE");
        actor:GetAnimation():SetTURNAnim("None");
        actor:SetAlwaysBattleState(true);
    end
    
    -- AssaultFire_Buff--
    if actor:GetVehicleActor() ~= nil and AssaultFire ~= nil then
        actor:GetAnimation():SetSTDAnim("SKL_WILDSHOT_LOOP_STD_RIDE");
        actor:GetAnimation():SetRUNAnim("SKL_WILDSHOT_LOOP_RIDE");
        actor:GetAnimation():SetWLKAnim("SKL_WILDSHOT_LOOP_RIDE");
        actor:GetAnimation():SetTURNAnim("None");
        actor:GetAnimation():PlayFixAnim("SKL_WILDSHOT_LOOP_STD_RIDE", 1, 1);
        actor:SetAlwaysBattleState(true);
    end
end

function SCR_ANIM_archer_f_bow_aonair(handle)
    local actor = world.GetActor(handle);
    if actor ~= nil then
        local buffDoubleGunStance = actor:GetBuff():GetBuff('DoubleGunStance_Buff');
        if buffDoubleGunStance ~= nil then
            actor:DetachCopiedModel();
            actor:ChangeEquipNode(EmAttach.eRHand, "Dummy_L_HAND");
            
            actor:ChangeEquipNode(EmAttach.eRHand, "Dummy_Sword");
            actor:CopyAttachedModel(EmAttach.eLHand, "Dummy_L_HAND");
        end
    end
end

function WING_GUILTY_FAIRY_BUFF_ENTER(actor, obj, buff)
end

function WING_GUILTY_FAIRY_BUFF_UPDATE(actor, obj, buff)
	SCR_CREATE_FAIRY(actor:GetHandleVal(), "guilty");
end

function WING_GUILTY_FAIRY_BUFF_LEAVE(actor, obj, buff)
	SCR_REMOVE_FAIRY(actor:GetHandleVal(), "guilty");
end

function GET_BUFF_BY_NAME_C(buffName)
    local buffCls = GetClass('Buff', buffName);
    if buffCls == nil then
        return nil;
    end
    local handle = session.GetMyHandle();
    return info.GetBuff(handle, buffCls.ClassID);
end