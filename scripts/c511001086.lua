--Food Cemetery
function c511001086.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c511001086.tg)
	e1:SetOperation(c511001086.op)
	c:RegisterEffect(e1)
	--copy	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_SZONE)	
	e2:SetOperation(c511001086.desop)
	c:RegisterEffect(e2)
end
function c511001086.filter(c,id)
	return c:IsSetCard(0x205) and c:GetTurnID()==id and not c:IsReason(REASON_RETURN)
end
function c511001086.afilter(c)
	return c:IsSetCard(0x205) and c:IsAbleToHand()
end
function c511001086.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c511001086.filter,tp,LOCATION_GRAVE,0,nil,Duel.GetTurnCount())
	local ct=g:GetCount()
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(c511001086.afilter,tp,LOCATION_DECK,0,ct,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,ct,tp,LOCATION_DECK)
end
function c511001086.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c511001086.filter,tp,LOCATION_GRAVE,0,nil,Duel.GetTurnCount())
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
		local ct=c:GetOverlayCount()
		if ct>0 then
			local g2=Duel.SelectMatchingCard(tp,c511001086.afilter,tp,LOCATION_DECK,0,ct,ct,nil)
			Duel.SendtoHand(g2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g2)
		end
	end
end
function c511001086.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()	
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)>c:GetOverlayCount() then
		local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,0,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
