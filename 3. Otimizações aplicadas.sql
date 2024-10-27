/*TabelaFornecedor
Índice Único para CNPJ : Como o CNPJ é único por fornecedor e frequentemente consultado, 
adicionado um índice único garante a integridade e melhoria do desempenho nas buscas.

use pj_hermes;
CREATE UNIQUE INDEX idx_fornecedor_cnpj ON Fornecedor (CNPJ);

TabelaFornecedor
Índices em Colunas Frequentemente Consultadas : 
Adicionado índices em colunas frequentemente consultadas, como nomee cidade, para acelerar buscas e filtros.

use pj_hermes;
CREATE INDEX idx_fornecedor_nome ON Fornecedor (nome);
CREATE INDEX idx_fornecedor_cidade ON Fornecedor (cidade);*/

/*TabelaMateria_Prima
Índice por Nome : Otimiza consultas que envolvem o nome da matéria-prima, 
que pode ser frequentemente usada em relatórios e pesquisas.

use pj_hermes;
CREATE INDEX idx_materiaprima_nome ON Materia_Prima (nome);

Obs : Redução de Espaço : Avaliar se a coluna descricaopode ser reduzido TEXTpara VARCHAR(500)ou outro valor menor, 
economizando espaço de armazenamento e melhorando significativamente o desempenho.*/

/*TabelaProduto	
Índice por Nome e Preço : Como consultas sobre produtos por nome e faixa de preço podem ser comuns, 
adicionado um índice composto melhora muito o desempenho dessas operações.

use pj_hermes;
CREATE INDEX idx_produto_preco_nome ON Produto (preco, nomeProduto);
*/

/*TabelaVinculo_Produto_MateriaPrima
Índices nas Chaves Estrangeiras : Para acelerar joins entre Produtoe Materia_Prima, 
adicionado índices nas chaves estrangeiras é uma prática essencial.

use pj_hermes;
CREATE INDEX idx_vinculo_produto ON Vinculo_Produto_MateriaPrima (fk_idProduto);
CREATE INDEX idx_vinculo_materiaprima ON Vinculo_Produto_MateriaPrima (fk_idMateriaPrima);

Otimização de Dados : Considerando que essa tabela pode aumentar os registros baseados em dataLancada, 
considerado criar um indice.

use pj_hermes;
CREATE INDEX idx_vinculo_dataLancada ON Vinculo_Produto_MateriaPrima (dataLancada); */

/*TabelaCompra_Materia_Prima
Índices em Chaves Estrangeiras : 
Consulta que esta suscetível a fazer joins com Materia_Primae Fornecedor serão mais rápidas 
com índices nessas colunas.

use pj_hermes;
CREATE INDEX idx_compra_materiaprima ON Compra_Materia_Prima (fk_idMateriaPrima);
CREATE INDEX idx_compra_fornecedor ON Compra_Materia_Prima (fk_idFornecedor);

Índice por Dados de Transação : Consultas por dados são comuns em compras, portanto, 
adicionado um índice na coluna dataTransacaopode melhorar muito o desempenho em relatórios históricos.

use pj_hermes;
CREATE INDEX idx_compra_dataTransacao ON Compra_Materia_Prima (dataTransacao);
*/

/*TabelaEstoque_Materia_Prima
Índice na Chave Estrangeira : Consultas relacionadas à compra e ao estoque de materiais-primas frequentemente necessárias. 
Adicionado um índice na chave estrangeira fk_idTransacaoCompraotimiza esse processo.

use pj_hermes;
CREATE INDEX idx_estoque_transacaocompra ON Estoque_Materia_Prima (fk_idTransacaoCompra);
*/

/*TabelaOrdem_Producao
Índices por Dados (Início e Final) : Adicionado índices nas colunas dataInicioe dataFinalacelera 
consultas que buscam ordens de produção por período.

use pj_hermes;
CREATE INDEX idx_ordemproducao_dataInicio ON Ordem_Producao (dataInicio);
CREATE INDEX idx_ordemproducao_dataFinal ON Ordem_Producao (dataFinal);

Índice Composto : Para atualizações que envolvem tanto quanto o custo, c
riado um índice composto pode acelerar essas consultas.

use pj_hermes;
CREATE INDEX idx_ordemproducao_quantidade_custo ON Ordem_Producao (quantidadeProduzida, custo);
*/

/*TabelaEstoque_Produto
Índice na Chave Estrangeira : Adicionado um índice na chave estrangeira fk_idProduto 
garantindo que as consultas que envolvam produtos e estoque sejam rápidas, especialmente em juntas.

use pj_hermes;
CREATE INDEX idx_estoque_produto ON Estoque_Produto (fk_idProduto);
*/
