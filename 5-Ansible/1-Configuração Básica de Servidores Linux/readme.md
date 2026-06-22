# 🤖 Ansible Lab 01 — Configuração Básica de Servidores Linux

## 📌 Objetivo

Automatizar a configuração inicial de um servidor Linux utilizando Ansible.

O objetivo deste laboratório foi aprender os conceitos fundamentais de Configuration Management através da execução de um playbook responsável por:

* Atualizar a cache de pacotes do sistema
* Instalar ferramentas essenciais para administração Linux
* Garantir consistência na configuração dos servidores
* Compreender o funcionamento de tasks e módulos Ansible

Este tipo de configuração é frequentemente utilizado em ambientes DevOps para preparar servidores recém-criados.

---

## 🧠 Tecnologias Utilizadas

* Ansible
* Linux
* Ubuntu Server
* AWS EC2
* SSH

---

## 📂 Estrutura do Projeto

```text
ansible-lab/
│
├── hosts
│
└── playbooks/
    └── setup-basico.yaml
```

---

## ⚙️ Inventário

Ficheiro:

```text
hosts
```

Conteúdo:

```ini
[targets]
target1 ansible_host=<IP_DA_VM> ansible_user=ubuntu
```

---

## 📜 Playbook

Ficheiro:

```text
playbooks/setup-basico.yaml
```

Código:

```yaml
---
- name: Configurar VM com pacotes básicos
  hosts: targets
  become: true

  tasks:

    - name: Atualizar lista de pacotes
      apt:
        update_cache: yes

    - name: Instalar pacotes úteis
      apt:
        name:
          - htop
          - curl
          - git
        state: present
```

---

## 🔍 Explicação do Playbook

### Atualização da Cache de Pacotes

```yaml
- name: Atualizar lista de pacotes
  apt:
    update_cache: yes
```

Executa o equivalente a:

```bash
sudo apt update
```

Garantindo que o sistema possui informação atualizada sobre os pacotes disponíveis.

---

### Instalação de Ferramentas Essenciais

```yaml
- name: Instalar pacotes úteis
  apt:
    name:
      - htop
      - curl
      - git
    state: present
```

Instala automaticamente:

| Pacote | Função                     |
| ------ | -------------------------- |
| htop   | Monitorização de processos |
| curl   | Testes HTTP e APIs         |
| git    | Controlo de versões        |

Equivalente a:

```bash
sudo apt install -y htop curl git
```

---

## 🚀 Executar o Playbook

A partir da máquina controller:

```bash
ansible-playbook -i hosts playbooks/setup-basico.yaml
```

---

## ✅ Validar Resultado

Verificar se os pacotes foram instalados:

### htop

```bash
ansible -i hosts targets -m shell -a "which htop"
```

### curl

```bash
ansible -i hosts targets -m shell -a "which curl"
```

### git

```bash
ansible -i hosts targets -m shell -a "git --version"
```

---

## 🔄 Idempotência

Uma das principais características do Ansible é a idempotência.

Primeira execução:

```text
changed=2
```

Execuções seguintes:

```text
changed=0
```

O Ansible apenas executa alterações quando necessário.

---

## 📚 Conceitos Aprendidos

Durante este laboratório foram explorados os seguintes conceitos:

* Inventários
* Playbooks
* Tasks
* Módulo apt
* Privilege Escalation (become)
* Gestão de Pacotes
* Automação Linux
* Idempotência

---

## ✅ Resultado Final

Foi criado um playbook capaz de preparar automaticamente um servidor Linux com ferramentas essenciais de administração.

Este laboratório serviu como introdução aos conceitos fundamentais de Configuration Management utilizando Ansible.
