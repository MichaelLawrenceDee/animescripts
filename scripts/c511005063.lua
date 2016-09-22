--Magical Hats (Anime)
--  By Shad3

local scard=c511005063

function scard.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(scard.cd)
	e1:SetTarget(scard.tg)
	e1:SetOperation(scard.op)
	c:RegisterEffect(e1)
end

function scard.cd(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end

function scard.fil(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsFaceup()
end

function scard.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local n=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return n>0 and Duel.IsExistingTarget(scard.fil,tp,LOCATION_MZONE,0,1,nil) end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then n=1 end
	Duel.SelectTarget(tp,scard.fil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,n,tp,0)
end

function scard.sum_fil(c,e,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),nil,0x11,0,0,0,0,0)
end

function scard.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local loc=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if loc<1 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then loc=1 end
	local gg=Duel.GetMatchingGroup(scard.sum_fil,tp,LOCATION_DECK,0,nil,e,tp)
	local sg=Group.CreateGroup()
	if gg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(4001,10)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		sg:Merge(gg:Select(tp,1,loc,nil))
	end
	local sco=loc-sg:GetCount()
	if sco>0 then
		for i=1,sco do
			sg:AddCard(Duel.CreateToken(tp,511005062))
		end
	end
	local stc=sg:GetFirst()
	while stc do
		local e1=Effect.CreateEffect(stc)
		if stc:IsType(TYPE_SPELL+TYPE_TRAP) then
			local te=stc:GetActivateEffect()
			if te then
				local se1=Effect.CreateEffect(stc)
				se1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
				se1:SetCondition(scard.mimica_cd)
				se1:SetCost(scard.mimica_cs)
				se1:SetTarget(scard.mimica_tg)
				se1:SetOperation(scard.mimica_op)
				se1:SetProperty(bit.bor(te:GetProperty(),EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL))
				se1:SetCategory(te:GetCategory())
				se1:SetLabel(te:GetLabel())
				se1:SetLabelObject(te:GetLabelObject())
				se1:SetReset(RESET_EVENT+0x47c0000)
				stc:RegisterEffect(se1)
				if stc:IsType(TYPE_TRAP) then
					local te1=Effect.CreateEffect(stc)
					te1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
					te1:SetCode(EVENT_BE_BATTLE_TARGET)
					te1:SetRange(LOCATION_MZONE)
					te1:SetCondition(scard.mimicb_cd)
					te1:SetOperation(scard.mimicb_op)
					te1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_UNCOPYABLE)
					te1:SetReset(RESET_EVENT+0x47c0000)
					stc:RegisterEffect(te1)
				end
			end
		end
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_NORMAL+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x47c0000)
		stc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_REMOVE_RACE)
		e2:SetValue(RACE_ALL)
		stc:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_REMOVE_ATTRIBUTE)
		e3:SetValue(0xff)
		stc:RegisterEffect(e3,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_SET_BASE_ATTACK)
		e4:SetValue(0)
		stc:RegisterEffect(e4,true)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_SET_BASE_DEFENSE)
		e5:SetValue(0)
		stc:RegisterEffect(e5,true)
		stc:SetStatus(STATUS_NO_LEVEL,true)
		stc=sg:GetNext()
	end
	Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEDOWN_DEFENSE)
	if tc:IsFaceup() then
		if tc:IsHasEffect(EFFECT_DEVINE_LIGHT) then Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		else
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
			tc:ClearEffectRelation()
		end
	end
	sg:AddCard(tc)
	Duel.ConfirmCards(1-tp,sg)
	Duel.ShuffleSetCard(sg)
end

function scard.mimica_cd(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE or (re and e:GetHandler()==re:GetHandler())
end

function scard.mimica_cs(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	c:AssumeProperty(ASSUME_TYPE,c:GetOriginalType())
	local te=c:GetActivateEffect()
	local tprop=te:GetProperty()
	te:SetProperty(bit.band(tprop,EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL))
	local act=te:IsActivatable(tp)
	te:SetProperty(tprop)
	if chk==0 then return act end
	local ote,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(te:GetCode(),true)
	c:ResetEffect(EFFECT_CHANGE_TYPE,RESET_CODE)
	e:SetType(EFFECT_TYPE_ACTIVATE)
	local cost=te:GetCost()
	if cost then cost(te,tp,ceg,cep,cev,cre,cr,crp,1) end
end

function scard.mimica_tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local te=e:GetHandler():GetActivateEffect()
	local ote,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(te:GetCode(),true)
	local targ=te:GetTarget()
	if chkc then return targ and targ(te,tp,ceg,cep,cev,cre,cr,crp,0,chkc) end
	if chk==0 then return not targ or targ(te,tp,ceg,cep,cev,cre,cr,crp,0) end
	e:GetHandler():SetStatus(STATUS_ACTIVATED,true)
	if targ then targ(te,tp,ceg,cep,cev,cre,cr,crp,1) end
end

function scard.mimica_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=c:GetActivateEffect()
	local ote,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(te:GetCode(),true)
	local oper=te:GetOperation()
	if Duel.GetCurrentPhase()==PHASE_DAMAGE and bit.band(c:GetOriginalType(),TYPE_CONTINUOUS)==TYPE_CONTINUOUS then return end
	if oper then oper(e,tp,ceg,cep,cev,cre,cr,crp) end
	if Duel.GetCurrentPhase()~=PHASE_DAMAGE and c:IsRelateToEffect(e) then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsType(TYPE_CONTINUOUS) then
			Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		else
			Duel.SendtoGrave(c,REASON_RULE)
		end
	end
end

function scard.mimicb_cd(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:AssumeProperty(ASSUME_TYPE,c:GetOriginalType())
	local te=c:GetActivateEffect()
	Debug.Message(te:IsActivatable(tp))
	return te:IsActivatable(tp)
end

function scard.mimicb_op(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(4001,9)) then return end
	local c=e:GetHandler()
	c:ResetEffect(EFFECT_CHANGE_TYPE,RESET_CODE)
	Duel.ChangePosition(c,POS_FACEUP_ATTACK,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_DEFENSE)
end