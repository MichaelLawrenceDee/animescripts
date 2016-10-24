--Freedom Bird
--scripted by GameMaster (GM)
--fixed by MLD
function c511005630.initial_effect(c)
	--Special summon Freedom bird from you deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511005630,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c511005630.spcon)	
	e1:SetTarget(c511005630.sptg)
	e1:SetOperation(c511005630.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c511005630.cfilter(c,tp)
	return c:GetSummonPlayer()~=tp
end
function c511005630.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c511005630.cfilter,1,nil,tp)
end
function c511005630.filter(c,e,tp)
	return c:IsCode(511005630) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511005630.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c511005630.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c511005630.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c511005630.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
