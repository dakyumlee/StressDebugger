from flask import Flask, request, jsonify
from openai import OpenAI
import os
import json

app = Flask(__name__)

client = OpenAI(api_key=os.getenv('OPENAI_API_KEY'))

@app.route('/analyze', methods=['POST'])
def analyze():
    data = request.json
    text = data.get('text', '')
    
    if not text:
        return jsonify({'error': 'No text provided'}), 400
    
    try:
        response = client.chat.completions.create(
            model="gpt-4",
            messages=[
                {"role": "system", "content": """당신은 스트레스 분석 전문가입니다. 
                사용자의 하루 일과를 분석하여 다음을 JSON 형식으로 반환하세요:
                {
                    "anger_level": 0-100 사이 정수,
                    "anxiety": 0-100 사이 정수,
                    "tech_factor": 0-100 사이 정수 (기술적 문제로 인한 스트레스),
                    "human_factor": 0-100 사이 정수 (인간관계로 인한 스트레스),
                    "top_causes": ["원인1", "원인2", "원인3"],
                    "justification": "우주적 관점에서 오늘 빡친 게 정당한 이유 (100자 이내)",
                    "consolation": "따뜻하고 싸가지있는 위로 (50자 이내)"
                }"""},
                {"role": "user", "content": text}
            ],
            temperature=0.7
        )
        
        result = json.loads(response.choices[0].message.content)
        
        top_causes = result.get('top_causes', [])
        forensic_text = "주요 원인:\n"
        for i, cause in enumerate(top_causes[:3], 1):
            forensic_text += f"{i}. {cause}\n"
        forensic_text += "\n→ 오늘 빡침은 정상 반응입니다"
        
        return jsonify({
            'anger_level': result.get('anger_level', 50),
            'anxiety': result.get('anxiety', 50),
            'tech_factor': result.get('tech_factor', 50),
            'human_factor': result.get('human_factor', 50),
            'forensic_result': forensic_text,
            'justification': result.get('justification', ''),
            'consolation': result.get('consolation', '')
        })
        
    except Exception as e:
        print(f"Error: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/health', methods=['GET'])
def health():
    return jsonify({'status': 'healthy'}), 200

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)
