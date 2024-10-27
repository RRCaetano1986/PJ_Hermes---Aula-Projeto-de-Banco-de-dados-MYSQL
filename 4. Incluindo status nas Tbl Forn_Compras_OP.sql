
USE pj_hermes;

-- Criar tabela de estados, se não existir
CREATE TABLE IF NOT EXISTS Estado_Completude (
    idEstado INT AUTO_INCREMENT PRIMARY KEY,
    descricaoEstado VARCHAR(50) NOT NULL
);

-- Inserir os novos estados
INSERT INTO Estado_Completude (descricaoEstado) VALUES 
('Incompleto'),
('Parcial'),
('Completo'),
('Aprovada'),
('Em andamento'),
('Finalizada'),
('Ativo'),
('Suspenso'),
('Inativo'),
('Cancelada');

-- Adicionar coluna de estado em Fornecedor
ALTER TABLE Fornecedor
ADD COLUMN fk_idEstado INT,
ADD CONSTRAINT fk_estado_fornecedor FOREIGN KEY (fk_idEstado) REFERENCES Estado_Completude(idEstado);

-- Adicionar coluna de estado em Compra_Materia_Prima
ALTER TABLE Compra_Materia_Prima
ADD COLUMN fk_idEstado INT,
ADD CONSTRAINT fk_estado_compra FOREIGN KEY (fk_idEstado) REFERENCES Estado_Completude(idEstado);

-- Adicionar coluna de estado em Ordem_Producao
ALTER TABLE Ordem_Producao
ADD COLUMN fk_idEstado INT,
ADD CONSTRAINT fk_estado_ordem FOREIGN KEY (fk_idEstado) REFERENCES Estado_Completude(idEstado);

SET SQL_SAFE_UPDATES = 0;

-- Exemplo de atualizações no estado do fornecedor
UPDATE Fornecedor SET fk_idEstado = 7 WHERE CNPJ LIKE '12.%';  -- Exemplo: Ativo
UPDATE Fornecedor SET fk_idEstado = 8 WHERE CNPJ LIKE '23.%';  -- Exemplo: Suspenso
UPDATE Fornecedor SET fk_idEstado = 9 WHERE CNPJ LIKE '34.%';  -- Exemplo: Inativo

-- Exemplo de atualizações no estado de compra
UPDATE Compra_Materia_Prima SET fk_idEstado = 4 WHERE totalCompra < 3000;  -- Aprovada
UPDATE Compra_Materia_Prima SET fk_idEstado = 5 WHERE totalCompra BETWEEN 3000 AND 6000;  -- Em andamento
UPDATE Compra_Materia_Prima SET fk_idEstado = 6 WHERE totalCompra > 6000;  -- Finalizada
UPDATE Compra_Materia_Prima SET fk_idEstado = 10 WHERE dataTransacao < '2023-01-01';  -- Cancelada

-- Exemplo de atualizações no estado de produção
UPDATE Ordem_Producao SET fk_idEstado = 1 WHERE quantidadeProduzida < 1000;  -- Incompleto
UPDATE Ordem_Producao SET fk_idEstado = 2 WHERE quantidadeProduzida BETWEEN 1000 AND 2000;  -- Parcial
UPDATE Ordem_Producao SET fk_idEstado = 3 WHERE quantidadeProduzida > 2000;  -- Completo
UPDATE Ordem_Producao SET fk_idEstado = 10 WHERE dataInicio < '2023-01-01';  -- Cancelada

SET SQL_SAFE_UPDATES = 1;

