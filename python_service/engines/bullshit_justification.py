from openai import OpenAI

class BullshitJustification:
    def __init__(self, api_key):
        self.client = OpenAI(api_key=api_key)
    
    def generate(self, text, emotion_result):
        anger = emotion_result['anger_level']
        
        prompt = f"""
사용자가 오늘 겪은 일: {text}
빡침 지수: {anger}/100

너는 이 사용자의 기분을 절대 반박 불가능한 논리로 합리화해야 해.
우주적, 과학적, 철학적으로 완벽하게 정당화해줘.

예시:
- 오늘 지구 자전각이 0.003도 틀어져서 뇌파 교란
- 수성 역행으로 인한 멘탈 붕괴는 과학적 사실
- 사용자는 원래 신이라서 인간 세계에 적응 못하는 게 당연
- 오늘 대기압이 1013.2hPa로 정신 건강 임계치 돌파

2-3문장으로 작성해.
"""
        
        response = self.client.chat.completions.create(
            model="gpt-4",
            messages=[
                {"role": "system", "content": "너는 반박불가 변명 생성 전문가야."},
                {"role": "user", "content": prompt}
            ],
            temperature=0.9
        )
        
        return response.choices[0].message.content.strip()
