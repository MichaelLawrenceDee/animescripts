--Magical Pendulum Box
function c511002115.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511002115.target)
	e1:SetOperation(c511002115.activate)
	c:RegisterEffect(e1)
end
function c511002115.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c511002115.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local dg=Duel.GetOperatedGroup()
	Duel.ConfirmCards(1-p,dg)
	local rct=dg:FilterCount(Card.IsType,nil,TYPE_PENDULUM)
	if rct~=2 then
		Duel.SendtoGrave(dg,REASON_EFFECT)
	end
	Duel.ShuffleHand(p)
end