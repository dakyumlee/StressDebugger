from flask import Flask, request, jsonify
from flask_cors import CORS
from engines.emotion_analyzer import EmotionAnalyzer
from engines.bullshit_justification import BullshitJustification
from engines.consolation_generator import ConsolationGenerator
import os
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)
CORS(app)

openai_api_key = os.getenv('OPENAI_API_KEY')

if not openai_api_key:
    print("⚠️  WARNING: OPENAI_API_KEY not found in environment!")
    print("Please set it in .env file")
else:
    print(f"✅ API Key loaded: {openai_api_key[:20]}...")

emotion_analyzer = EmotionAnalyzer(openai_api_key)
justifier = BullshitJustification(openai_api_key)
consoler = ConsolationGenerator(openai_api_key)

@app.route('/health', methods=['GET'])
def health():
    return jsonify({'status': 'ok'}), 200

@app.route('/analyze', methods=['POST'])
def analyze():
    data = request.get_json()
    text = data.get('text', '')
    
    if not text:
        return jsonify({'error': 'No text provided'}), 400
    
    emotion_result = emotion_analyzer.analyze(text)
    
    forensic_result = {
        'top_causes': emotion_result['top_causes'],
        'verdict': '오늘 빡침은 정상 반응입니다'
    }
    
    justification = justifier.generate(text, emotion_result)
    consolation = consoler.generate(text, emotion_result)
    
    return jsonify({
        'anger_level': emotion_result['anger_level'],
        'anxiety': emotion_result['anxiety'],
        'tech_factor': emotion_result['tech_factor'],
        'human_factor': emotion_result['human_factor'],
        'forensic_result': forensic_result,
        'justification': justification,
        'consolation': consolation
    }), 200

if __name__ == '__main__':
    port = int(os.getenv('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=False)
