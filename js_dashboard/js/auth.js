const API_BASE_URL = 'http://localhost:8080/api';

function getToken() {
    return localStorage.getItem('token');
}

function setToken(token) {
    localStorage.setItem('token', token);
}

function clearToken() {
    localStorage.removeItem('token');
}

function checkAuth() {
    const token = getToken();
    if (!token) {
        window.location.href = '/login.html';
    }
}

document.getElementById('logout-btn')?.addEventListener('click', () => {
    clearToken();
    window.location.href = '/login.html';
});

checkAuth();
