from openai import OpenAI
import json
import re

class EmotionAnalyzer:
    def __init__(self, api_key):
        self.client = OpenAI(api_key=api_key)
    
    def analyze(self, text):
        prompt = f"""
다음 텍스트를 분석해서 JSON 형식으로 반환해줘:

텍스트: {text}

분석 항목:
1. anger_level (0-100): 빡침 정도
2. anxiety (0-100): 예민함 정도
3. tech_factor (0-100): 기술적 요인 (버그, 빌드, 배포, 캐시, 네트워크 등)
4. human_factor (0-100): 인간 관계 요인
5. top_causes: 상위 3개 원인 리스트 ["1위", "2위", "3위"]

반드시 JSON만 반환하고 다른 텍스트는 포함하지 마.
"""
        
        response = self.client.chat.completions.create(
            model="gpt-4",
            messages=[
                {"role": "system", "content": "너는 감정 분석 전문가야. JSON만 반환해."},
                {"role": "user", "content": prompt}
            ],
            temperature=0.7
        )
        
        content = response.choices[0].message.content.strip()
        
        content = re.sub(r'```json\s*', '', content)
        content = re.sub(r'```\s*', '', content)
        
        result = json.loads(content)
        
        return result
