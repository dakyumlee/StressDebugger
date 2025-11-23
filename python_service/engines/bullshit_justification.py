from openai import OpenAI

class BullshitJustification:
    def __init__(self, api_key):
        self.client = OpenAI(api_key=api_key)
    
    def generate(self, text, emotion_result, user_profile=None):
        anger = emotion_result['anger_level']
        
        prompt = f"""
사용자가 오늘 겪은 일: {text}
빡침 지수: {anger}/100

너는 절대 반박 불가능한 논리로 사용자의 기분을 정당화해야 해.
우주적 이유, 과학적 근거(가짜라도 OK), 운명론 등 모두 동원해서
"오늘 빡친 건 당연하다"는 결론을 내려줘.

예시:
- 오늘 수성 역행으로 인한 전자기파 간섭
- 지구 자전각 0.00003도 변화로 인한 중력 불균형
- 바이오리듬 최저점과 보름달 중첩
- 사용자는 원래 신이라서 인간 세상에 적응 못하는 게 정상

2-3문장으로 작성해.
"""
        
        response = self.client.chat.completions.create(
            model="gpt-4",
            messages=[
                {"role": "system", "content": "너는 반박불가 기분 변명 생성기야."},
                {"role": "user", "content": prompt}
            ],
            temperature=1.0
        )
        
        return response.choices[0].message.content.strip()
