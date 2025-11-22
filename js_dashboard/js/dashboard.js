let angerChart, factorChart;

async function fetchStats() {
    const token = getToken();
    try {
        const response = await fetch(`${API_BASE_URL}/logs/stats`, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });
        
        if (!response.ok) throw new Error('Failed to fetch stats');
        
        const data = await response.json();
        displayStats(data);
        displayCharts(data);
        displayRecentLogs(data.recent_logs || []);
    } catch (error) {
        console.error('Error fetching stats:', error);
    }
}

function displayStats(data) {
    document.getElementById('avg-anger').textContent = 
        data.avg_anger ? Math.round(data.avg_anger) : '0';
    document.getElementById('avg-tech').textContent = 
        data.avg_tech_factor ? Math.round(data.avg_tech_factor) : '0';
    document.getElementById('avg-human').textContent = 
        data.avg_human_factor ? Math.round(data.avg_human_factor) : '0';
}

function displayCharts(data) {
    const recentLogs = data.recent_logs || [];
    
    const labels = recentLogs.map(log => {
        const date = new Date(log.createdAt);
        return `${date.getMonth() + 1}/${date.getDate()}`;
    }).reverse();
    
    const angerData = recentLogs.map(log => log.angerLevel).reverse();
    const anxietyData = recentLogs.map(log => log.anxiety).reverse();
    
    if (angerChart) angerChart.destroy();
    
    const angerCtx = document.getElementById('angerChart').getContext('2d');
    angerChart = new Chart(angerCtx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [
                {
                    label: '빡침 지수',
                    data: angerData,
                    borderColor: '#96A694',
                    backgroundColor: 'rgba(150, 166, 148, 0.2)',
                    tension: 0.4
                },
                {
                    label: '예민 지수',
                    data: anxietyData,
                    borderColor: '#B0BFAE',
                    backgroundColor: 'rgba(176, 191, 174, 0.2)',
                    tension: 0.4
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            plugins: {
                legend: {
                    labels: {
                        color: '#B0BFAE',
                        font: {
                            family: 'TaebaekEunhasu'
                        }
                    }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    max: 100,
                    ticks: {
                        color: '#96A694'
                    },
                    grid: {
                        color: '#50594F'
                    }
                },
                x: {
                    ticks: {
                        color: '#96A694'
                    },
                    grid: {
                        color: '#50594F'
                    }
                }
            }
        }
    });
    
    const techData = recentLogs.map(log => log.techFactor);
    const humanData = recentLogs.map(log => log.humanFactor);
    
    const avgTech = techData.reduce((a, b) => a + b, 0) / techData.length || 0;
    const avgHuman = humanData.reduce((a, b) => a + b, 0) / humanData.length || 0;
    
    if (factorChart) factorChart.destroy();
    
    const factorCtx = document.getElementById('factorChart').getContext('2d');
    factorChart = new Chart(factorCtx, {
        type: 'doughnut',
        data: {
            labels: ['기술 요인', '인간 요인'],
            datasets: [{
                data: [avgTech, avgHuman],
                backgroundColor: ['#96A694', '#B0BFAE'],
                borderColor: '#262620',
                borderWidth: 2
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            plugins: {
                legend: {
                    labels: {
                        color: '#B0BFAE',
                        font: {
                            family: 'TaebaekEunhasu'
                        }
                    }
                }
            }
        }
    });
}

function displayRecentLogs(logs) {
    const container = document.getElementById('recent-logs');
    container.innerHTML = '';
    
    logs.forEach(log => {
        const logItem = document.createElement('div');
        logItem.className = 'log-item';
        
        const date = new Date(log.createdAt);
        const dateStr = `${date.getFullYear()}.${String(date.getMonth() + 1).padStart(2, '0')}.${String(date.getDate()).padStart(2, '0')} ${String(date.getHours()).padStart(2, '0')}:${String(date.getMinutes()).padStart(2, '0')}`;
        
        logItem.innerHTML = `
            <div class="log-date">${dateStr}</div>
            <div class="log-text">${log.text.substring(0, 150)}${log.text.length > 150 ? '...' : ''}</div>
            <div class="log-stats">
                <span>빡침: ${log.angerLevel}</span>
                <span>예민: ${log.anxiety}</span>
                <span>기술: ${log.techFactor}</span>
                <span>인간: ${log.humanFactor}</span>
            </div>
        `;
        
        container.appendChild(logItem);
    });
}

fetchStats();
