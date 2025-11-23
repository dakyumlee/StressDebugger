from flask import Flask, request, jsonify
from flask_cors import CORS
from engines.emotion_analyzer import EmotionAnalyzer
from engines.bullshit_justification import BullshitJustification
from engines.consolation_generator import ConsolationGenerator
from engines.finetuning_manager import FineTuningManager
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
finetuning_mgr = FineTuningManager(openai_api_key)

@app.route('/health', methods=['GET'])
def health():
    return jsonify({'status': 'ok'}), 200

@app.route('/analyze', methods=['POST'])
def analyze():
    data = request.get_json()
    text = data.get('text', '')
    user_profile = data.get('userProfile', {})
    
    if not text:
        return jsonify({'error': 'No text provided'}), 400
    
    emotion_result = emotion_analyzer.analyze(text)
    
    forensic_result = {
        'top_causes': emotion_result['top_causes'],
        'verdict': '오늘 빡침은 정상 반응입니다'
    }
    
    justification = justifier.generate(text, emotion_result, user_profile)
    consolation = consoler.generate(text, emotion_result, user_profile)
    
    return jsonify({
        'anger_level': emotion_result['anger_level'],
        'anxiety': emotion_result['anxiety'],
        'tech_factor': emotion_result['tech_factor'],
        'human_factor': emotion_result['human_factor'],
        'forensic_result': forensic_result,
        'justification': justification,
        'consolation': consolation
    }), 200

@app.route('/finetuning/upload', methods=['POST'])
def upload_training_data():
    """JSONL 데이터 업로드 & Fine-tuning Job 생성"""
    data = request.get_json()
    jsonl_content = data.get('jsonl', '')
    
    if not jsonl_content:
        return jsonify({'error': 'No JSONL data provided'}), 400
    
    try:
        file_id = finetuning_mgr.upload_training_file(jsonl_content)
        job_info = finetuning_mgr.create_finetuning_job(file_id)
        
        return jsonify({
            'success': True,
            'file_id': file_id,
            'job_info': job_info
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/finetuning/status/<job_id>', methods=['GET'])
def get_finetuning_status(job_id):
    """Fine-tuning Job 상태 확인"""
    try:
        status = finetuning_mgr.get_job_status(job_id)
        return jsonify(status), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/finetuning/models', methods=['GET'])
def list_finetuned_models():
    """파인튜닝된 모델 목록"""
    try:
        models = finetuning_mgr.list_finetuned_models()
        return jsonify({'models': models}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    port = int(os.getenv('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=False)

@app.route('/chat', methods=['POST'])
def chat():
    """나만의 AI와 대화"""
    data = request.get_json()
    message = data.get('message', '')
    user_profile = data.get('userProfile', {})
    conversation_history = data.get('history', [])
    
    if not message:
        return jsonify({'error': 'No message provided'}), 400
    
    system_prompt = consoler._build_system_prompt(user_profile)
    
    messages = [{"role": "system", "content": system_prompt}]
    messages.extend(conversation_history)
    messages.append({"role": "user", "content": message})
    
    response = consoler.client.chat.completions.create(
        model="gpt-4",
        messages=messages,
        temperature=0.9
    )
    
    reply = response.choices[0].message.content.strip()
    
    return jsonify({
        'reply': reply,
        'timestamp': str(int(time.time()))
    }), 200
