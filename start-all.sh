#!/bin/bash

PROJECT_DIR="/Users/mac/Desktop/Project/StressDebugger"

echo "🚀 StressDebugger 전체 서비스 시작!"
echo "================================"

osascript <<APPLESCRIPT
tell application "Terminal"
    activate
    
    do script "cd $PROJECT_DIR && echo '📦 PostgreSQL 시작...' && docker run --rm --name stress-db -e POSTGRES_DB=stressdebugger -e POSTGRES_USER=admin -e POSTGRES_PASSWORD=stress2024! -p 5432:5432 postgres:15-alpine"
    
    delay 3
    
    do script "cd $PROJECT_DIR/python_service && echo '🐍 Python AI 서비스 시작...' && echo 'OpenAI API 키 확인 중...' && if [ -f .env ]; then source .env && python3 app.py; else echo '❌ .env 파일이 없습니다!'; fi"
    
    delay 2
    
    do script "cd $PROJECT_DIR/spring_api && echo '☕ Spring Boot API 시작...' && mvn spring-boot:run"
    
    delay 2
    
    do script "cd $PROJECT_DIR/flutter_app && echo '📱 Flutter 앱 시작...' && flutter run"
    
end tell
APPLESCRIPT

echo "✅ 모든 서비스 터미널 실행 완료!"
echo ""
echo "서비스 포트:"
echo "  - PostgreSQL: 5432"
echo "  - Python AI: 5000"
echo "  - Spring API: 8080"
echo "  - Flutter: 앱 실행"
