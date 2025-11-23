from openai import OpenAI
import json
import time

class FineTuningManager:
    def __init__(self, api_key):
        self.client = OpenAI(api_key=api_key)
    
    def upload_training_file(self, jsonl_content):
        """JSONL 파일 업로드"""
        with open('/tmp/training_data.jsonl', 'w', encoding='utf-8') as f:
            f.write(jsonl_content)
        
        with open('/tmp/training_data.jsonl', 'rb') as f:
            file_response = self.client.files.create(
                file=f,
                purpose='fine-tune'
            )
        
        return file_response.id
    
    def create_finetuning_job(self, file_id, model="gpt-4o-mini-2024-07-18"):
        """Fine-tuning Job 생성"""
        job = self.client.fine_tuning.jobs.create(
            training_file=file_id,
            model=model,
            hyperparameters={
                "n_epochs": 3
            }
        )
        
        return {
            'job_id': job.id,
            'status': job.status,
            'model': job.model,
            'created_at': job.created_at
        }
    
    def get_job_status(self, job_id):
        """Job 상태 확인"""
        job = self.client.fine_tuning.jobs.retrieve(job_id)
        
        return {
            'job_id': job.id,
            'status': job.status,
            'fine_tuned_model': job.fine_tuned_model,
            'trained_tokens': job.trained_tokens,
            'finished_at': job.finished_at
        }
    
    def list_finetuned_models(self):
        """파인튜닝된 모델 목록"""
        jobs = self.client.fine_tuning.jobs.list(limit=10)
        
        models = []
        for job in jobs.data:
            if job.fine_tuned_model:
                models.append({
                    'model_id': job.fine_tuned_model,
                    'status': job.status,
                    'created_at': job.created_at,
                    'finished_at': job.finished_at
                })
        
        return models
