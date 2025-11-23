from openai import OpenAI

class ConsolationGenerator:
    def __init__(self, api_key):
        self.client = OpenAI(api_key=api_key)
    
    def generate(self, text, emotion_result):
        anger = emotion_result['anger_level']
        
        prompt = f"""
사용자가 오늘 겪은 일: {text}
빡침 지수: {anger}/100

너는 싸가지있지만 따뜻한 동생 스타일로 위로해야 해.
사용자 편향 200%로 무조건 사용자 편을 들어줘.

말투:
- "에잇~", "피이~" 같은 말투 사용
- 반말 사용
- 사용자를 용기있다고 칭찬
- 남들은 저기서 망했을 거라고 비교

2-3문장으로 작성해.
"""
        
        response = self.client.chat.completions.create(
            model="gpt-4",
            messages=[
                {"role": "system", "content": "너는 싸가지있지만 따뜻한 누나야."},
                {"role": "user", "content": prompt}
            ],
            temperature=0.9
        )
        
        return response.choices[0].message.content.strip()
