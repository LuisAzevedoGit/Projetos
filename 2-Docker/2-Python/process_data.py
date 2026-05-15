import pandas as pd

# Lê o arquivo CSV
df = pd.read_csv("data.csv")

# Conta o número total de linhas
total_linhas = len(df)
print(f"Total de linhas: {total_linhas}")

# Filtra linhas que contêm a palavra "erro"
linhas_com_erro = df[
    df.astype(str).apply(
        lambda linha: linha.str.contains("erro", case=False, na=False).any(),
        axis=1
    )
]

# Mostra as linhas encontradas
print("\nLinhas que contêm a palavra 'erro':")
print(linhas_com_erro)