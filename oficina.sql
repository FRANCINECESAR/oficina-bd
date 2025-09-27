-- =====================================
-- 1️⃣ Limpar tabelas existentes
-- =====================================
DROP TABLE IF EXISTS Funcionario_OS;
DROP TABLE IF EXISTS Funcionarios;
DROP TABLE IF EXISTS Itens_Servico;
DROP TABLE IF EXISTS OS;
DROP TABLE IF EXISTS Servicos;
DROP TABLE IF EXISTS Veiculos;
DROP TABLE IF EXISTS Clientes;

-- =====================================
-- 2️⃣ Criar tabelas
-- =====================================
CREATE TABLE Clientes (
    cliente_id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    telefone TEXT,
    email TEXT
);

CREATE TABLE Veiculos (
    veiculo_id INTEGER PRIMARY KEY AUTOINCREMENT,
    cliente_id INTEGER NOT NULL,
    marca TEXT NOT NULL,
    modelo TEXT NOT NULL,
    ano INTEGER,
    placa TEXT UNIQUE,
    FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id)
);

CREATE TABLE Servicos (
    servico_id INTEGER PRIMARY KEY AUTOINCREMENT,
    descricao TEXT NOT NULL,
    valor_base REAL NOT NULL
);

CREATE TABLE OS (
    os_id INTEGER PRIMARY KEY AUTOINCREMENT,
    veiculo_id INTEGER NOT NULL,
    data_os DATE NOT NULL,
    status TEXT NOT NULL,
    valor_total REAL DEFAULT 0,
    FOREIGN KEY (veiculo_id) REFERENCES Veiculos(veiculo_id)
);

CREATE TABLE Itens_Servico (
    item_id INTEGER PRIMARY KEY AUTOINCREMENT,
    os_id INTEGER NOT NULL,
    servico_id INTEGER NOT NULL,
    quantidade INTEGER DEFAULT 1,
    valor_unitario REAL NOT NULL,
    FOREIGN KEY (os_id) REFERENCES OS(os_id),
    FOREIGN KEY (servico_id) REFERENCES Servicos(servico_id)
);

CREATE TABLE Funcionarios (
    funcionario_id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    cargo TEXT,
    telefone TEXT
);

CREATE TABLE Funcionario_OS (
    funcionario_id INTEGER NOT NULL,
    os_id INTEGER NOT NULL,
    PRIMARY KEY (funcionario_id, os_id),
    FOREIGN KEY (funcionario_id) REFERENCES Funcionarios(funcionario_id),
    FOREIGN KEY (os_id) REFERENCES OS(os_id)
);

-- =====================================
-- 3️⃣ Inserir dados de teste
-- =====================================
INSERT INTO Clientes (nome, telefone, email) VALUES
('João Silva', '11999999999', 'joao@email.com'),
('Maria Oliveira', '11988888888', 'maria@email.com');

INSERT INTO Veiculos (cliente_id, marca, modelo, ano, placa) VALUES
(1, 'Honda', 'Civic', 2018, 'ABC1234'),
(1, 'Toyota', 'Corolla', 2020, 'XYZ5678'),
(2, 'Ford', 'Ka', 2019, 'DEF4321');

INSERT INTO Servicos (descricao, valor_base) VALUES
('Troca de óleo', 150.00),
('Alinhamento', 100.00),
('Balanceamento', 80.00),
('Revisão completa', 500.00);

INSERT INTO OS (veiculo_id, data_os, status, valor_total) VALUES
(1, '2025-09-20', 'Finalizada', 300.00),
(2, '2025-09-22', 'Em Andamento', 100.00),
(3, '2025-09-23', 'Aberta', 80.00);

INSERT INTO Itens_Servico (os_id, servico_id, quantidade, valor_unitario) VALUES
(1, 1, 1, 150.00),
(1, 2, 1, 150.00),
(2, 2, 1, 100.00),
(3, 3, 1, 80.00);

INSERT INTO Funcionarios (nome, cargo, telefone) VALUES
('Carlos Pereira', 'Mecânico', '11977777777'),
('Ana Souza', 'Mecânica', '11966666666');

INSERT INTO Funcionario_OS (funcionario_id, os_id) VALUES
(1, 1),
(2, 2),
(1, 3);

-- =====================================
-- 4️⃣ Queries de teste
-- =====================================

-- 4.1 Todos os clientes
SELECT * FROM Clientes;

-- 4.2 OS em andamento
SELECT * FROM OS WHERE status = 'Em Andamento';

-- 4.3 Total gasto por cada OS (atributo derivado)
SELECT os_id, SUM(quantidade * valor_unitario) AS total_os
FROM Itens_Servico
GROUP BY os_id;

-- 4.4 Lista de OS com cliente e veículo (JOIN)
SELECT o.os_id, c.nome AS cliente, v.marca || ' ' || v.modelo AS veiculo, o.status
FROM OS o
JOIN Veiculos v ON o.veiculo_id = v.veiculo_id
JOIN Clientes c ON v.cliente_id = c.cliente_id
ORDER BY o.data_os;

-- 4.5 Funcionários por OS (JOIN)
SELECT fo.os_id, f.nome AS funcionario
FROM Funcionario_OS fo
JOIN Funcionarios f ON fo.funcionario_id = f.funcionario_id
ORDER BY fo.os_id;

-- 4.6 Serviços com quantidade maior que 1 (HAVING)
SELECT servico_id, SUM(quantidade) AS total_qtde
FROM Itens_Servico
GROUP BY servico_id
HAVING total_qtde > 1;
-- =========================
-- Queries avançadas (JOINs complexos)
-- =========================

-- 1️⃣ OS detalhadas por cliente, veículo, serviço e funcionário
SELECT 
    c.nome AS cliente,
    v.marca || ' ' || v.modelo AS veiculo,
    o.os_id,
    o.data_os,
    o.status,
    s.descricao AS servico,
    i.quantidade,
    i.valor_unitario,
    f.nome AS funcionario
FROM OS o
JOIN Veiculos v ON o.veiculo_id = v.veiculo_id
JOIN Clientes c ON v.cliente_id = c.cliente_id
JOIN Itens_Servico i ON o.os_id = i.os_id
JOIN Servicos s ON i.servico_id = s.servico_id
JOIN Funcionario_OS fo ON o.os_id = fo.os_id
JOIN Funcionarios f ON fo.funcionario_id = f.funcionario_id
ORDER BY c.nome, o.data_os;

-- 2️⃣ Total gasto por cliente
SELECT 
    c.nome AS cliente,
    SUM(i.quantidade * i.valor_unitario) AS total_gasto
FROM Clientes c
JOIN Veiculos v ON c.cliente_id = v.cliente_id
JOIN OS o ON v.veiculo_id = o.veiculo_id
JOIN Itens_Servico i ON o.os_id = i.os_id
GROUP BY c.cliente_id
ORDER BY total_gasto DESC;

-- 3️⃣ Funcionários e total de serviços que participaram
SELECT 
    f.nome AS funcionario,
    COUNT(DISTINCT fo.os_id) AS total_os,
    SUM(i.quantidade) AS total_servicos
FROM Funcionarios f
JOIN Funcionario_OS fo ON f.funcionario_id = fo.funcionario_id
JOIN Itens_Servico i ON fo.os_id = i.os_id
GROUP BY f.funcionario_id
ORDER BY total_servicos DESC;

-- 4️⃣ Clientes com mais de uma OS (HAVING)
SELECT 
    c.nome AS cliente,
    COUNT(o.os_id) AS total_os
FROM Clientes c
JOIN Veiculos v ON c.cliente_id = v.cliente_id
JOIN OS o ON v.veiculo_id = o.veiculo_id
GROUP BY c.cliente_id
HAVING COUNT(o.os_id) > 1;

-- 5️⃣ Serviços mais realizados
SELECT 
    s.descricao AS servico,
    COUNT(i.item_id) AS vezes_realizado,
    SUM(i.quantidade) AS total_quantidade
FROM Servicos s
JOIN Itens_Servico i ON s.servico_id = i.servico_id
GROUP BY s.servico_id
ORDER BY vezes_realizado DESC;
