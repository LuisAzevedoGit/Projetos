# 🔍 Investigação e Correção de Incidente 

Projeto prático de **DevOps / Linux Essentials**, desenvolvido a partir da série do canal [MariaLazaraDev](https://www.youtube.com/@marialazaradev), simulando a investigação e resolução de um incidente real de produção.

## 📌 Contexto

A **MariaLazaraCloud** é uma empresa fictícia SaaS B2B de automação de cobrança e faturamento. No dia **27/09/2024**, o serviço `billing-api` deixou de processar transações, apresentando erros de corrupção de dados e falhas de validação de integridade, apesar de o processo continuar em execução (dashboard em estado *degraded*).

O objetivo do projeto foi assumir o papel de **DevOps Engineer on-call** e, através de comandos Linux básicos, investigar a causa raiz do problema e repor o serviço em funcionamento.

## 🎯 Objetivos de Aprendizagem

- Analisar processos em execução no Linux
- Monitorizar logs em tempo real
- Navegar e localizar ficheiros num sistema desconhecido (`find`)
- Investigar a integridade de dados
- Editar ficheiros de configuração com `nano`
- Compreender e aplicar permissões Unix (`chmod`)
- Aplicar troubleshooting sistemático
- Executar um rollback documentado
- Validar a recuperação do serviço

## 🧪 Ambiente do laboratório

O ambiente foi disponibilizado em container Docker:

```bash
# Descarregar a imagem do laboratório
docker pull marialazaradev/linux-essentials:latest

# Executar o container
docker run -it --name devops-investigation marialazaradev/linux-essentials:latest
```

## 🕵️ Resumo da investigação

| Passo | O que foi feito | Comando principal |
|---|---|---|
| 1 | Reconhecimento do sistema | `uname -a` |
| 2 | Verificação de processos ativos | `ps aux \| grep billing` |
| 3 | Análise inicial dos logs | `tail app.log` |
| 4 | Monitorização em tempo real | `tail -f app.log` |
| 5 | Localização da documentação da GMUD | `find / -name "GMUD-*"` |
| 6 | Análise do log de execução da mudança | `cat change-log.txt` |
| 7 | Verificação da configuração atual | `cat billing-config.yml` |
| 8 | Inspeção do diretório de dados | `ls -la /data/billing/` |
| 9 | Verificação da integridade dos dados | `cat /data/billing/transactions` |
| 10 | Verificação dos dados originais (backup) | `cat /opt/seeds/transactions` |
| 11 | Comparação da configuração com o backup | `diff billing-config.yml billing-config.yml.backup` |
| 12 | Backup de segurança antes do rollback | `cp billing-config.yml billing-config.yml.pre-rollback` |
| 13 | Rollback da configuração | `nano billing-config.yml` |
| 14 | Restauração de permissões seguras | `chmod 444 billing-config.yml` |
| 15 | Reinício da aplicação | `kill <PID>` + `start-billing-api.sh` |
| 16 | Validação da recuperação | `tail -f app.log` |
| 17 | Comunicação da resolução | — |

### Causa raiz

Uma **GMUD (Gestão de Mudança)** realizada na noite anterior migrou os dados de `/opt/seeds` para `/data/billing`, com o objetivo de otimizar o I/O do serviço. A cópia dos dados falhou/corrompeu-se durante a migração, e a validação pós-mudança não verificou a integridade do conteúdo — apenas confirmou que o serviço tinha reiniciado sem erros aparentes.

### Solução

Rollback da configuração `data_directory` de `/data/billing` para `/opt/seeds` (onde os dados originais permaneciam íntegros), seguido de reinício do serviço e validação através dos logs.

## 🛠️ Conceitos e comandos abordados

- **Permissões Unix**: `r` (ler) / `w` (escrever) / `x` (executar), níveis *owner / group / others* (ex.: `chmod 644`, `chmod 444`)
- **Gestão de processos**: `ps aux`, `kill <PID>`
- **Análise de logs**: `tail`, `tail -f`, `head`, `grep`, redireção (`>`) e pipes (`|`)
- **Localização de ficheiros**: `find / -name "..." 2>/dev/null`
- **Edição de ficheiros**: `nano`
- **Comparação de ficheiros**: `diff`
- **Estrutura do filesystem Linux**: `/etc`, `/var/log`, `/opt`, `/data`, `/usr/local/bin`, etc.

## 📁 Estrutura do repositório

```
.
├── README.md
├── apotamentos.txt       # Notas pessoais tiradas durante o curso
├── diretorios linux.png          
└── permissoes linux.png

```

## 📚 Referências

- Autora: **Maria Lazara** — [Canal YouTube](https://www.youtube.com/@marialazaradev)
- Metodologia: Aprendizagem Baseada em Problemas (PBL)
- Imagem Docker: `marialazaradev/linux-essentials:latest`

## ✅ Lições aprendidas

- Validar sempre a integridade dos dados após uma migração, não apenas se o serviço reiniciou sem erros.
- Documentar mudanças (GMUD) com plano de rollback claro poupa tempo em incidentes.
- Investigar sistemas legados de forma sistemática e narrada ajuda a construir raciocínio de troubleshooting.

---

*Projeto realizado para fins de aprendizagem, seguindo a série "Investigação e Correção de Incidente" da MariaLazaraCloud.*
