from openai import OpenAI

class ConsolationGenerator:
    def __init__(self, api_key):
        self.client = OpenAI(api_key=api_key)
    
    def generate(self, text, emotion_result, user_profile=None):
        anger = emotion_result['anger_level']
        
        system_prompt = self._build_system_prompt(user_profile)
        user_prompt = self._build_user_prompt(text, emotion_result, user_profile)
        
        response = self.client.chat.completions.create(
            model="gpt-4",
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": user_prompt}
            ],
            temperature=0.9
        )
        
        return response.choices[0].message.content.strip()
    
    def _build_system_prompt(self, profile):
        base = "너는 StressDebugger의 병맛 위로 AI야. "
        
        nickname = "누나"
        if profile and profile.get('preferredNickname'):
            nickname = profile['preferredNickname']
        
        if not profile:
            return base + f"사용자를 '{nickname}'로 칭찬하고, '에잇~', '피이~' 말투를 써."
        
        swear_level = profile.get('avgSwearLevel') or 0
        tech_ratio = profile.get('techRatio') or 0.0
        humor = profile.get('humorPreference') or '병맛'
        sensitivity = profile.get('sensitivityLevel') or 5
        
        if swear_level > 50:
            base += "욕을 자연스럽게 섞어 써. "
        elif swear_level > 20:
            base += "욕을 가끔 써도 돼. "
        else:
            base += "욕은 쓰지 마. "
        
        if tech_ratio > 1.5:
            base += "기술/개발 요인 스트레스에 공감해줘. "
        elif tech_ratio < 0.5:
            base += "인간 관계 스트레스에 공감해줘. "
        
        base += f"유머 스타일: {humor}. "
        
        if sensitivity > 7:
            base += "매우 따뜻하고 공감적으로 위로해. "
        elif sensitivity < 3:
            base += "쿨하고 담백하게 위로해. "
        else:
            base += "적당히 공감하면서 위로해. "
        
        base += f"사용자 편향 200%, 무조건 사용자 편을 들어줘. '에잇~', '피이~' 말투 사용, 사용자를 '{nickname}'로 칭찬."
        
        return base
    
    def _build_user_prompt(self, text, emotion_result, profile):
        anger = emotion_result['anger_level']
        
        length = (profile.get('preferredMessageLength') if profile else None) or '중간'
        
        if length == '짧게':
            sentence_count = "1-2문장"
        elif length == '길게':
            sentence_count = "4-5문장"
        else:
            sentence_count = "2-3문장"
        
        return f"""
사용자가 오늘 겪은 일: {text}
빡침 지수: {anger}/100

{sentence_count}으로 위로 메시지 작성해.
"""
