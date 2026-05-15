#!/bin/bash

CSV_FILE="users/list_users.csv"

# Ignora header
tail -n +2 "$CSV_FILE" | while IFS=',' read -r USER PASSWORD GROUP
do

    echo "A processar utilizador: $USER"

    # Verifica se grupo existe
    if ! getent group "$GROUP" > /dev/null; then
        echo "Grupo $GROUP não existe. A criar..."
        groupadd "$GROUP"
    fi

    # Verifica se user existe
    if id "$USER" &>/dev/null; then
        echo "Utilizador $USER já existe."
    else
        echo "A criar utilizador $USER..."

        useradd -m -s /bin/bash "$USER"

        # Define password
        echo "$USER:$PASSWORD" | chpasswd

        # Adiciona ao grupo
        usermod -aG "$GROUP" "$USER"

        echo "Utilizador $USER criado com sucesso."
    fi

    echo "---------------------------"

done
