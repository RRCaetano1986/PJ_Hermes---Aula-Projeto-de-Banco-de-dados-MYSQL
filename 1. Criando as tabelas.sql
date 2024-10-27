/*use pj_hermes;
CREATE TABLE Fornecedor (
    idFornecedor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(255),
    cidade VARCHAR(100),
    CNPJ VARCHAR(20),
    responsavel VARCHAR(100),
    ramo VARCHAR(100),
    telefone VARCHAR(15),
    email VARCHAR(100)
);*/

/*use pj_hermes;
CREATE TABLE Materia_Prima (
    idMateriaPrima INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10, 2) NOT NULL
);*/

/*use pj_hermes;
CREATE TABLE Produto (
    idProduto INT AUTO_INCREMENT PRIMARY KEY,
    nomeProduto VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10, 2) NOT NULL
);*/

/*use pj_hermes;
CREATE TABLE Vinculo_Produto_MateriaPrima (
    idProdutoMateriaPrima INT AUTO_INCREMENT PRIMARY KEY,
    fk_idProduto INT,
    fk_idMateriaPrima INT,
    dataLancada DATE,
    FOREIGN KEY (fk_idProduto) REFERENCES Produto(idProduto),
    FOREIGN KEY (fk_idMateriaPrima) REFERENCES Materia_Prima(idMateriaPrima)
);*/

/*use pj_hermes;
CREATE TABLE Compra_Materia_Prima (
    idTransacaoCompra INT AUTO_INCREMENT PRIMARY KEY,
    dataTransacao DATE,
    dataValidade DATE,
    totalCompra DECIMAL(10, 2) NOT NULL,
    fk_idMateriaPrima INT,
    fk_idFornecedor INT,
    FOREIGN KEY (fk_idMateriaPrima) REFERENCES Materia_Prima(idMateriaPrima),
    FOREIGN KEY (fk_idFornecedor) REFERENCES Fornecedor(idFornecedor)
);*/

/*use pj_hermes;
CREATE TABLE Estoque_Materia_Prima (
    idEstoqueMateriaPrima INT AUTO_INCREMENT PRIMARY KEY,
    quantidadeEstoque INT NOT NULL,
    fk_idTransacaoCompra INT,
    FOREIGN KEY (fk_idTransacaoCompra) REFERENCES Compra_Materia_Prima(idTransacaoCompra)
);*/

/*use pj_hermes;
CREATE TABLE Ordem_Producao (
    idLote INT AUTO_INCREMENT PRIMARY KEY,
    dataInicio DATE,
    dataFinal DATE,
    quantidadeProduzida INT,
    custo DECIMAL(10, 2),
    dataValidade DATE,
    fk_idProduto INT,
    FOREIGN KEY (fk_idProduto) REFERENCES Produto(idProduto)
);*/

/*use pj_hermes;
CREATE TABLE Estoque_Produto (
    idEstoque INT AUTO_INCREMENT PRIMARY KEY,
    quantidadeEstoque INT NOT NULL,
    fk_idProduto INT,
    FOREIGN KEY (fk_idProduto) REFERENCES Produto(idProduto)
);*/
