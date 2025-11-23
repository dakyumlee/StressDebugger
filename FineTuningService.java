
    public Map<String, Object> startFineTuning() {
        String jsonl = generateJSONL();
        String url = pythonServiceUrl + "/finetuning/upload";
        
        Map<String, String> request = new HashMap<>();
        request.put("jsonl", jsonl);
        
        return restTemplate.postForObject(url, request, Map.class);
    }
    
    public Map<String, Object> getJobStatus(String jobId) {
        String url = pythonServiceUrl + "/finetuning/status/" + jobId;
        return restTemplate.getForObject(url, Map.class);
    }
    
    public Map<String, Object> listModels() {
        String url = pythonServiceUrl + "/finetuning/models";
        return restTemplate.getForObject(url, Map.class);
    }
}
