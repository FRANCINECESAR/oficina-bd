# oficina-bd


## Descrição do Projeto
Este projeto consiste em um **banco de dados para gerenciamento de uma oficina mecânica**, desenvolvido para fins acadêmicos como parte de um desafio de modelagem e implementação de banco de dados relacional.  

O sistema contempla informações de **clientes, veículos, serviços, ordens de serviço (OS) e funcionários**, permitindo análises de faturamento, frequência de serviços, e distribuição de tarefas entre funcionários.

---

## Estrutura do Banco de Dados

### Tabelas

1. **Clientes**
| Coluna       | Tipo    | Descrição                    |
|--------------|--------|------------------------------|
| cliente_id   | INTEGER | Identificador único do cliente (PK) |
| nome         | TEXT   | Nome do cliente              |
| telefone     | TEXT   | Telefone do cliente          |
| email        | TEXT   | E-mail do cliente            |

2. **Veículos**
| Coluna       | Tipo    | Descrição                    |
|--------------|--------|------------------------------|
| veiculo_id   | INTEGER | Identificador único do veículo (PK) |
| cliente_id   | INTEGER | Referência ao cliente (FK)  |
| marca        | TEXT   | Marca do veículo             |
| modelo       | TEXT   | Modelo do veículo            |
| ano          | INTEGER | Ano do veículo               |
| placa        | TEXT   | Placa do veículo (única)    |

3. **Serviços**
| Coluna       | Tipo    | Descrição                    |
|--------------|--------|------------------------------|
| servico_id   | INTEGER | Identificador único do serviço (PK) |
| descricao    | TEXT   | Nome ou descrição do serviço |
| valor_base   | REAL   | Valor base do serviço        |

4. **OS (Ordens de Serviço)**
| Coluna       | Tipo    | Descrição                    |
|--------------|--------|------------------------------|
| os_id        | INTEGER | Identificador único da OS (PK) |
| veiculo_id   | INTEGER | Referência ao veículo (FK)  |
| data_os      | DATE   | Data da abertura da OS       |
| status       | TEXT   | Status da OS (Aberta, Em Andamento, Finalizada) |
| valor_total  | REAL   | Valor total da OS            |

5. **Itens_Serviço**
| Coluna       | Tipo    | Descrição                    |
|--------------|--------|------------------------------|
| item_id      | INTEGER | Identificador único do item (PK) |
| os_id        | INTEGER | Referência à OS (FK)        |
| servico_id   | INTEGER | Referência ao serviço (FK)  |
| quantidade   | INTEGER | Quantidade do serviço       |
| valor_unitario | REAL  | Valor unitário do serviço   |

6. **Funcionários**
| Coluna       | Tipo    | Descrição                    |
|--------------|--------|------------------------------|
| funcionario_id | INTEGER | Identificador único do funcionário (PK) |
| nome         | TEXT   | Nome do funcionário          |
| cargo        | TEXT   | Cargo do funcionário         |
| telefone     | TEXT   | Telefone                     |

7. **Funcionario_OS**
| Coluna       | Tipo    | Descrição                    |
|--------------|--------|------------------------------|
| funcionario_id | INTEGER | Referência ao funcionário (FK) |
| os_id        | INTEGER | Referência à OS (FK)        |
| **PK**       | (funcionario_id, os_id) | Chave composta |

---

## Exemplo de Queries

### Queries básicas

- Listar todos os clientes:
```sql
SELECT * FROM Clientes;
