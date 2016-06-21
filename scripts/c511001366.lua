--Power Collapse
function c511001366.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(c511001366.condition)
	e1:SetTarget(c511001366.target)
	e1:SetOperation(c511001366.activate)
	c:RegisterEffect(e1)
end
function c511001366.cfilter(c,tp)
	local rc=c:GetReasonCard()
	return c:IsReason(REASON_BATTLE) and rc:IsControler(tp) and rc:IsRelateToBattle()
end
function c511001366.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and eg:IsExists(c511001366.cfilter,1,nil,tp)
end
function c511001366.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ec=eg:GetFirst()
	if chkc then return false end
	if chk==0 then return ec and ec:GetReasonCard() and ec:GetReasonCard():IsControler(tp) and ec:GetReasonCard():IsFaceup() 
		and ec:GetReasonCard():IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(ec:GetReasonCard())
end
function c511001366.activate(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		e1:SetValue(-ec:GetAttack())
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ATTACK_ALL)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		tc:RegisterEffect(e2)
	end
end
