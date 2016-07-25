--Tribute Trade
--scripted by: UnknownGuest
function c810000087.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabel(0)
	e1:SetCost(c810000087.cost)
	e1:SetTarget(c810000087.target)
	e1:SetOperation(c810000087.activate)
	c:RegisterEffect(e1)
end
function c810000087.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c810000087.cfilter(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and Duel.IsExistingMatchingCard(c810000087.spfilter,tp,LOCATION_DECK,0,1,nil,lv+1,e,tp)
end
function c810000087.spfilter(c,lv,e,tp)
	return c:GetLevel()==lv and c:IsAbleToHand()
end
function c810000087.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,c810000087.cfilter,1,nil,e,tp)
	end
	local rg=Duel.SelectReleaseGroup(tp,c810000087.cfilter,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetLevel())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c810000087.activate(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c810000087.spfilter,tp,LOCATION_DECK,0,1,1,nil,lv+1,e,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
