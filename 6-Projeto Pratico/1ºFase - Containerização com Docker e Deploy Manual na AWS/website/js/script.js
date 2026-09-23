// Função para mostrar status do container
function showStatus() {
    const statusSection = document.getElementById('status');
    statusSection.scrollIntoView({ behavior: 'smooth' });
    
    // Atualizar informações dinamicamente
    updateStatus();
}

// Função para mostrar informações do sistema
function showInfo() {
    const timestamp = new Date().toLocaleString('pt-BR');
    const info = `
🐳 Container Docker: Ativo
⚡ Servidor: Nginx
🌐 Porta: 80
📅 Deploy: ${timestamp}
☁️ Cloud: AWS EC2
🔄 Status: Online
    `;
    
    alert(info);
}

// Função para atualizar status em tempo real
function updateStatus() {
    const containerStatus = document.getElementById('container-status');
    const serverStatus = document.getElementById('server-status');
    const environment = document.getElementById('environment');
    
    // Simular verificação de status
    setTimeout(() => {
        containerStatus.textContent = 'Docker Ativo';
        containerStatus.className = 'status-value active';
        
        serverStatus.textContent = 'Nginx Online';
        serverStatus.className = 'status-value active';
        
        environment.textContent = 'AWS EC2 - Rodando';
        environment.className = 'status-value active';
    }, 1000);
}

// Inicialização quando a página carregar
document.addEventListener('DOMContentLoaded', function() {
    console.log('🚀 DevOps Lab - Site carregado com sucesso!');
    console.log('🐳 Container Docker ativo');
    console.log('⚡ Servidor web rodando na porta 80');
    
    // Smooth scroll para links de navegação
    const navLinks = document.querySelectorAll('.nav-link');
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const targetId = this.getAttribute('href').substring(1);
            const targetElement = document.getElementById(targetId);
            
            if (targetElement) {
                targetElement.scrollIntoView({ behavior: 'smooth' });
            }
        });
    });
});