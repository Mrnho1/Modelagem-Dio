CREATE DATABASE Oficina;
USE Oficina;

CREATE TABLE Cliente (
    idCliente INT PRIMARY KEY,
    Nome VARCHAR(45),
    CPF VARCHAR(45),
    Contato VARCHAR(45)
);

CREATE TABLE Servico (
    idServico INT PRIMARY KEY,
    TipoServico VARCHAR(45),
    Cliente_idCliente INT,
    ServicoIdentificado VARCHAR(45),
    ServicoAutorizado VARCHAR(45),
    FOREIGN KEY (Cliente_idCliente) REFERENCES Cliente(idCliente)
);

CREATE TABLE Mecanico (
    idMecanico INT PRIMARY KEY,
    Nome VARCHAR(45),
    Endereco VARCHAR(45),
    Especialidade VARCHAR(45)
);

CREATE TABLE Equipe_de_Servico (
    Servico_idServico INT,
    Mecanico_idMecanico INT,
    PRIMARY KEY (Servico_idServico, Mecanico_idMecanico),
    FOREIGN KEY (Servico_idServico) REFERENCES Servico(idServico),
    FOREIGN KEY (Mecanico_idMecanico) REFERENCES Mecanico(idMecanico)
);

CREATE TABLE O_S (
    idOS INT PRIMARY KEY,
    DataEmissao DATE,
    Valor INT,
    Status VARCHAR(45),
    DataConclusao DATE
);

CREATE TABLE O_S_has_Servico (
    O_S_idOS INT,
    Servico_idServico INT,
    PRIMARY KEY (O_S_idOS, Servico_idServico),
    FOREIGN KEY (O_S_idOS) REFERENCES O_S(idOS),
    FOREIGN KEY (Servico_idServico) REFERENCES Servico(idServico)
);

CREATE TABLE Pecas (
    idPecas INT PRIMARY KEY,
    Valor INT
);

CREATE TABLE ValorConvertido (
    Pecas_idPecas INT,
    O_S_idOS INT,
    ValorMaoObra INT,
    PRIMARY KEY (Pecas_idPecas, O_S_idOS),
    FOREIGN KEY (Pecas_idPecas) REFERENCES Pecas(idPecas),
    FOREIGN KEY (O_S_idOS) REFERENCES O_S(idOS)
);


INSERT INTO Cliente VALUES
(1, 'João Silva', '12345678900', '119999999'),
(2, 'Maria Souza', '98765432100', '118888888');

INSERT INTO Servico VALUES
(1, 'Troca de Óleo', 1, 'Óleo queimado', 'Autorizado'),
(2, 'Revisão Completa', 2, 'Revisão periódica', 'Autorizado');

INSERT INTO Mecanico VALUES
(1, 'Carlos Mec', 'Rua A', 'Motor'),
(2, 'Pedro Mec', 'Rua B', 'Suspensão');

INSERT INTO Equipe_de_Servico VALUES
(1, 1),
(1, 2),
(2, 1);

INSERT INTO O_S VALUES
(100, '2024-01-05', 300, 'Concluída', '2024-01-07'),
(200, '2024-01-10', 500, 'Em andamento', NULL);

INSERT INTO O_S_has_Servico VALUES
(100, 1),
(200, 2);

INSERT INTO Pecas VALUES
(10, 150),
(20, 300);

INSERT INTO ValorConvertido VALUES
(10, 100, 120),
(20, 200, 180);


-- listar todos os clientes
SELECT Nome, CPF FROM Cliente;

-- serviços de um cliente específico
SELECT *
FROM Servico
WHERE Cliente_idCliente = 1;

-- calcular custo total da OS
SELECT 
    os.idOS,
    SUM(pc.Valor + vc.ValorMaoObra) AS CustoTotal
FROM O_S os
JOIN ValorConvertido vc ON vc.O_S_idOS = os.idOS
JOIN Pecas pc ON pc.idPecas = vc.Pecas_idPecas
GROUP BY os.idOS;

-- serviços ordenados por tipo
SELECT * 
FROM Servico
ORDER BY TipoServico ASC;

-- OS com custo total acima de 
SELECT 
    os.idOS,
    SUM(pc.Valor + vc.ValorMaoObra) AS Total
FROM O_S os
JOIN ValorConvertido vc ON os.idOS = vc.O_S_idOS
JOIN Pecas pc ON pc.idPecas = vc.Pecas_idPecas
GROUP BY os.idOS
HAVING Total > 250;

-- serviços de cada mecânico
SELECT 
    s.idServico,
    s.TipoServico,
    m.Nome AS Mecanico
FROM Servico s
JOIN Equipe_de_Servico es ON es.Servico_idServico = s.idServico
JOIN Mecanico m ON m.idMecanico = es.Mecanico_idMecanico;


-- quanto cada clientes gastou
SELECT 
    c.Nome,
    SUM(pc.Valor + vc.ValorMaoObra) AS TotalGasto
FROM Cliente c
JOIN Servico s ON s.Cliente_idCliente = c.idCliente
JOIN O_S_has_Servico ohs ON ohs.Servico_idServico = s.idServico
JOIN O_S os ON os.idOS = ohs.O_S_idOS
JOIN ValorConvertido vc ON vc.O_S_idOS = os.idOS
JOIN Pecas pc ON pc.idPecas = vc.Pecas_idPecas
GROUP BY c.Nome;
