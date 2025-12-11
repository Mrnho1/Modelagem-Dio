-- CRIAÇÃO DESAFIO ECOMMERCE.
-- Se necessário apague o comentário da query abaixo.
-- DROP DATABASE IF EXISTS ecommerce;
-- Criação do banco de dados ecommerce.
CREATE DATABASE IF NOT EXISTS ecommerce;
-- linha necessária para usar o banco de dados.
USE ecommerce;

-- CRIAÇÃO DAS TABELAS.

-- criando a tabela clients
CREATE TABLE clients(
	idClient INT AUTO_INCREMENT PRIMARY KEY,
    Fname VARCHAR(25),
    Minit CHAR(3),
    Lname VARCHAR(50),
    CPF CHAR(11) DEFAULT NULL,
    CNPJ CHAR(14) DEFAULT NULL,
    Address VARCHAR(255),
    CONSTRAINT unique_cpf_client UNIQUE (CPF),
    CONSTRAINT unique_cnpj_client UNIQUE (CNPJ),
    CONSTRAINT chk_client_pf_pj CHECK ( (CPF IS NULL) != (CNPJ IS NULL) )
);

-- criando a tabela products
CREATE TABLE product (
    idProduct INT AUTO_INCREMENT PRIMARY KEY,
    Pname VARCHAR(100) NOT NULL,
    classification_kids BOOLEAN DEFAULT FALSE,
    category ENUM('Eletrônico','Vestimenta','Brinquedos','Alimentos','Móveis') NOT NULL,
    avaliacao FLOAT DEFAULT 0,
    size VARCHAR(20)
);

-- criando a tabela payments
CREATE TABLE payments (
    idPayment INT AUTO_INCREMENT,
    idClient INT,
    typePayment ENUM('Boleto','Cartão','Dois Cartões') NOT NULL,
    limitAvailable FLOAT DEFAULT NULL,
    PRIMARY KEY (idPayment),
    CONSTRAINT fk_payments_client FOREIGN KEY (idClient) REFERENCES clients(idClient)
      ON UPDATE CASCADE
      ON DELETE CASCADE
);

-- criando a tabela orders
CREATE TABLE orders (
    idOrder INT AUTO_INCREMENT PRIMARY KEY,
    idOrderClient INT DEFAULT NULL,
    orderStatus ENUM('Cancelado','Confirmado','Em processamento') DEFAULT 'Em processamento',
    orderDescription VARCHAR(255),
    sendValue FLOAT DEFAULT 10,
    paymentCash BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_orders_client FOREIGN KEY (idOrderClient) REFERENCES clients(idClient)
      ON UPDATE CASCADE
      ON DELETE SET NULL
);

-- criando a tabela product storage
CREATE TABLE productStorage (
    idProdStorage INT AUTO_INCREMENT PRIMARY KEY,
    storageLocation VARCHAR(255),
    quantity INT DEFAULT 0
);

-- criando a tabela supplier
CREATE TABLE supplier (
    idSupplier INT AUTO_INCREMENT PRIMARY KEY,
    SocialName VARCHAR(255) NOT NULL,
    CNPJ CHAR(14) NOT NULL,
    contact VARCHAR(20) NOT NULL,
    CONSTRAINT unique_supplier UNIQUE (CNPJ)
);

-- criando a tabela seller
CREATE TABLE seller (
    idSeller INT AUTO_INCREMENT PRIMARY KEY,
    SocialName VARCHAR(255) NOT NULL,
    AbstName VARCHAR(255),
    CNPJ CHAR(14) DEFAULT NULL,
    CPF CHAR(11) DEFAULT NULL,
    location VARCHAR(255),
    contact VARCHAR(20) NOT NULL,
    CONSTRAINT unique_cnpj_seller UNIQUE (CNPJ),
    CONSTRAINT unique_cpf_seller UNIQUE (CPF)
);

-- criando a tabela product seller
CREATE TABLE productSeller (
    idPseller INT,
    idPproduct INT,
    prodQuantity INT DEFAULT 1,
    PRIMARY KEY (idPseller, idPproduct),
    CONSTRAINT fk_product_seller FOREIGN KEY (idPseller) REFERENCES seller(idSeller)
      ON UPDATE CASCADE
      ON DELETE CASCADE,
    CONSTRAINT fk_product_product FOREIGN KEY (idPproduct) REFERENCES product(idProduct)
      ON UPDATE CASCADE
      ON DELETE CASCADE
);

-- criando a tabela product order
CREATE TABLE productOrder (
    idPOproduct INT,
    idPOorder INT,
    poQuantity INT DEFAULT 1,
    poStatus ENUM('Disponível','Sem estoque') DEFAULT 'Disponível',
    PRIMARY KEY (idPOproduct, idPOorder),
    CONSTRAINT fk_product_order_product FOREIGN KEY (idPOproduct) REFERENCES product(idProduct)
      ON UPDATE CASCADE
      ON DELETE CASCADE,
    CONSTRAINT fk_product_order_order FOREIGN KEY (idPOorder) REFERENCES orders(idOrder)
      ON UPDATE CASCADE
      ON DELETE CASCADE
);

-- criando a tabela storage location
CREATE TABLE storageLocation (
    idLproduct INT,
    idLstorage INT,
    location VARCHAR(255) NOT NULL,
    PRIMARY KEY (idLproduct, idLstorage),
    CONSTRAINT fk_storage_location_product FOREIGN KEY (idLproduct) REFERENCES product(idProduct)
      ON UPDATE CASCADE
      ON DELETE CASCADE,
    CONSTRAINT fk_storage_location_storage FOREIGN KEY (idLstorage) REFERENCES productStorage(idProdStorage)
      ON UPDATE CASCADE
      ON DELETE CASCADE
);


-- criando a tabela product supplier
CREATE TABLE productSupplier (
    idPsSupplier INT,
    idPsProduct INT,
    quantity INT NOT NULL,
    PRIMARY KEY (idPsSupplier, idPsProduct),
    CONSTRAINT fk_product_supplier_supplier FOREIGN KEY (idPsSupplier) REFERENCES supplier(idSupplier)
      ON UPDATE CASCADE
      ON DELETE CASCADE,
    CONSTRAINT fk_product_supplier_product FOREIGN KEY (idPsProduct) REFERENCES product(idProduct)
      ON UPDATE CASCADE
      ON DELETE CASCADE
);


-- INSERINDO DADOS NAS TABELAS


-- clients
INSERT INTO clients (Fname, Minit, Lname, CPF, Address)
VALUES
  ('Maria','M','Silva','12346789000','rua silva de prata 29, Carangola - Cidade das flores'),
  ('Matheus','O','Pimentel','09876543210','rua alameda 289, Centro - Cidade das flores'),
  ('Ricardo','F','Silva','04567891300','avenida alameda vinha 1009, Centro - Cidade das flores'),
  ('Julia','S','França','78912345600','rua lareiras 861, Centro - Cidade das flores'),
  ('Roberta','G','Assis','09874563100','avenida koller 19, Centro - Cidade das flores'),
  ('Isabela','M','Cruz','65478912300','rua alameda das flores 28, Centro - Cidade das flores');

-- product
INSERT INTO product (Pname, classification_kids, category, avaliacao, size) VALUES
    ('Fone de ouvido', FALSE, 'Eletrônico', 4, NULL),
    ('Barbie Elsa', TRUE, 'Brinquedos', 3, NULL),
    ('Body Carters', TRUE, 'Vestimenta', 5, NULL),
    ('Microfone Vedo - Youtuber', FALSE, 'Eletrônico', 4, NULL),
    ('Sofá retrátil', FALSE, 'Móveis', 3, '3x57x80'),
    ('Farinha de arroz', FALSE, 'Alimentos', 2, NULL),
    ('Fire Stick Amazon', FALSE, 'Eletrônico', 3, NULL);

-- orders
INSERT INTO orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash) VALUES
    (1, DEFAULT, 'compra via aplicativo', NULL, TRUE),
    (2, DEFAULT, 'compra via aplicativo', 50, FALSE),
    (3, 'Confirmado', NULL, NULL, TRUE),
    (4, DEFAULT, 'compra via web site', 150, FALSE);

-- productOrder
INSERT INTO productOrder (idPOproduct, idPOorder, poQuantity, poStatus) VALUES
    (1,1,2,'Disponível'),
    (2,1,1,'Disponível'),
    (3,2,1,'Disponível');

-- productStorage
INSERT INTO productStorage (storageLocation, quantity) VALUES
    ('Rio de Janeiro',1000),
    ('Rio de Janeiro',500),
    ('São Paulo',10),
    ('São Paulo',100),
    ('São Paulo',10),
    ('Brasília',60);

-- storageLocation (associação produto <-> storage)
INSERT INTO storageLocation (idLproduct, idLstorage, location) VALUES
    (1,2,'RJ'),
    (2,6,'GO');

-- supplier
INSERT INTO supplier (SocialName, CNPJ, contact) VALUES
    ('Almeida e Filhos','12345678912345','21985474'),
    ('Eletrônicos Silva','85451964914345','21985484'),
    ('Eletrônicos Valma','93456789393469','21985474');

-- productSupplier
INSERT INTO productSupplier (idPsSupplier, idPsProduct, quantity) VALUES
    (1,1,500),
    (1,2,400),
    (2,4,633),
    (3,3,5),
    (2,5,10);

-- seller
INSERT INTO seller (SocialName, AbstName, CNPJ, CPF, location, contact) VALUES
    ('Tech eletronics', NULL, '12345678945632', NULL, 'Rio de Janeiro','219946287'),
    ('Botique Durgas', NULL, NULL, '12345678300', 'Rio de Janeiro','219567895'),
    ('Kids World', NULL, '45678912365448', NULL, 'São Paulo','1198657484');

-- productSeller
INSERT INTO productSeller (idPseller, idPproduct, prodQuantity) VALUES
    (1, 6, 80),
    (2, 7, 10);

-- payments (exemplo)
INSERT INTO payments (idClient, typePayment, limitAvailable) VALUES
    (1,'Cartão',5000),
    (2,'Boleto',NULL),
    (3,'Cartão',3000);





-- CRIANDO QUERIES E RESPONDENDO PERGUNTAS


-- listar todos os clientes
SELECT * FROM clients;

-- filtro com where: produtos eletrônicos com avaliação >= 4
SELECT idProduct,Pname, avaliacao
FROM product
WHERE category = 'Eletrônico' AND avaliacao >= 4
ORDER BY avaliacao DESC, Pname;


-- atributo derivado: total de itens por pedido
SELECT po.idPOorder AS idOrder,
SUM(po.poQuantity) AS total_items
FROM productOrder po
GROUP BY po.idPOorder;


-- quantos pedidos foram feitos por cada cliente?
SELECT c.idClient, CONCAT(c.Fname,' ',c.Lname) AS cliente, COUNT(o.idOrder) AS numero_pedidos
FROM clients c
LEFT JOIN orders o ON c.idClient = o.idOrderClient
GROUP BY c.idClient
ORDER BY numero_pedidos DESC;

-- algum vendedor também é fornecedor?
SELECT s.idSeller, s.SocialName AS vendedor, sp.idSupplier, sp.SocialName AS fornecedor
FROM seller s
JOIN supplier sp ON s.CNPJ IS NOT NULL AND s.CNPJ = sp.CNPJ
UNION
SELECT s.idSeller, s.SocialName, sp.idSupplier, sp.SocialName
FROM seller s
JOIN supplier sp ON s.CPF IS NOT NULL AND sp.CNPJ = s.CPF; -- pouco provável, só como exemplo

-- relação de produtos, fornecedores e quantidade fornecida
SELECT p.idProduct, p.Pname, sup.SocialName AS fornecedor, ps.quantity AS quantidade_fornecida
FROM productSupplier ps
JOIN product p ON ps.idPsProduct = p.idProduct
JOIN supplier sup ON ps.idPsSupplier = sup.idSupplier
ORDER BY sup.SocialName, p.Pname;

-- relação de nomes dos fornecedores e nomes dos produtos
SELECT sup.SocialName AS fornecedor,
       GROUP_CONCAT(DISTINCT p.Pname SEPARATOR ', ') AS produtos_fornecidos
FROM productSupplier ps
JOIN supplier sup ON ps.idPsSupplier = sup.idSupplier
JOIN product p ON ps.idPsProduct = p.idProduct
GROUP BY sup.idSupplier;

-- produtos com estoque total
SELECT p.idProduct, p.Pname, COALESCE(SUM(ps.quantity),0) AS estoque_total
FROM product p
LEFT JOIN productSupplier ps ON p.idProduct = ps.idPsProduct
GROUP BY p.idProduct
HAVING estoque_total > 0
ORDER BY estoque_total DESC;

-- pedidos e valor estimado
SELECT o.idOrder, CONCAT(c.Fname,' ',c.Lname) AS cliente, 
       SUM(po.poQuantity) AS total_itens
FROM orders o
LEFT JOIN productOrder po ON o.idOrder = po.idPOorder
LEFT JOIN clients c ON o.idOrderClient = c.idClient
GROUP BY o.idOrder
ORDER BY total_itens DESC;

-- produtos por vendedor
SELECT s.SocialName AS vendedor, p.Pname, ps.prodQuantity
FROM productSeller ps
JOIN seller s ON ps.idPseller = s.idSeller
JOIN product p ON ps.idPproduct = p.idProduct
ORDER BY s.SocialName;

-- exemplo com WHERE + ORDER BY: clientes com mais de 1 pedido (HAVING)
SELECT c.idClient, CONCAT(c.Fname,' ',c.Lname) AS cliente, COUNT(o.idOrder) AS numero_pedidos
FROM clients c
JOIN orders o ON c.idClient = o.idOrderClient
GROUP BY c.idClient
HAVING numero_pedidos > 1
ORDER BY numero_pedidos DESC;

-- existe fornecedor que abastece o produto X?
SELECT p.idProduct, p.Pname, sup.SocialName, ps.quantity
FROM product p
JOIN productSupplier ps ON p.idProduct = ps.idPsProduct
JOIN supplier sup ON ps.idPsSupplier = sup.idSupplier
WHERE p.idProduct = 1;
















