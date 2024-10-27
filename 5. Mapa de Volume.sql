
/*Incluindo data_criacao nas tabelas criadas
ALTER TABLE ordem_producao ADD COLUMN data_criacao DATE;
ALTER TABLE compra_materia_prima ADD COLUMN data_transacao DATE;*/

/*Volume trimestral OP

SELECT 
    t.table_name AS 'Entidade',
    QUARTER(o.data_criacao) AS 'Trimestre',
    YEAR(o.data_criacao) AS 'Ano',
    t.table_rows AS 'Registros',
    ROUND((t.data_length + t.index_length) / 1024, 2) AS 'EspacoTotalKB',
    ROUND(t.data_length / 1024, 2) AS 'EspacoUsadoKB',
    ROUND(t.index_length / 1024, 2) AS 'EspacoIndexKB',
    ROUND((t.data_free) / 1024, 2) AS 'EspacoNaoUsadoKB'
FROM 
    information_schema.tables t
JOIN 
    pj_hermes.ordem_producao o ON t.table_name = 'ordem_producao'
WHERE 
    t.table_schema = 'pj_hermes'
GROUP BY 
    t.table_name, t.table_rows, t.data_length, t.index_length, t.data_free, YEAR(o.data_criacao), QUARTER(o.data_criacao)
ORDER BY 
    t.table_rows DESC;

 */
 
 /*Consultando dados gerais
 SELECT 
    table_name AS 'Entidade',
    table_rows AS 'Registros',
    ROUND((data_length + index_length) / 1024, 2) AS 'EspacoTotalKB',
    ROUND(data_length / 1024, 2) AS 'EspacoUsadoKB',
    ROUND(index_length / 1024, 2) AS 'EspacoIndexKB',
    ROUND((data_free) / 1024, 2) AS 'EspacoNaoUsadoKB'
FROM 
    information_schema.tables
WHERE 
    table_schema = 'pj_hermes'
ORDER BY 
    table_rows DESC;
*/

/*Selecionado 2 tabelas para avaliar volume e projetar*/

/*tabela Compra_Materia_Prima*/

/*Criando tabela CP temporária para inserir datas
CREATE TEMPORARY TABLE temp_compra_materia AS
SELECT idTransacaoCompra, ROW_NUMBER() OVER (ORDER BY idTransacaoCompra) AS rn
FROM compra_materia_prima
WHERE dataTransacao IS NULL;*/

/*Verifando quantos registros nulos CP
SELECT COUNT(*) AS RegistrosNulos
FROM pj_hermes.compra_materia_prima
WHERE data_transacao IS NULL;*/

/*inserindo datas na tabela CP 
SET @rownum = 0;

UPDATE pj_hermes.compra_materia_prima
SET data_transacao = DATE_ADD('2023-10-20', INTERVAL @rownum := @rownum + 1 DAY)
WHERE data_transacao IS NULL;
*/

/*Distribuindo datas tabela CP
-- Atualizar parte dos registros para o 4º trimestre de 2022 (20/10/2022 - 31/12/2022)
UPDATE pj_hermes.compra_materia_prima
SET data_transacao = DATE_ADD('2022-10-20', INTERVAL RAND() * 72 DAY)
WHERE data_transacao IS NULL
LIMIT 200; -- Ajustando o volume para o final de 2022

-- Atualizar parte dos registros para o 1º trimestre de 2023 (01/01/2023 - 31/03/2023)
UPDATE pj_hermes.compra_materia_prima
SET data_transacao = DATE_ADD('2023-01-01', INTERVAL RAND() * 90 DAY)
WHERE data_transacao IS NULL
LIMIT 300; -- Ajustando o volume para o início de 2023

-- Atualizar parte dos registros para o 2º trimestre de 2023 (01/04/2023 - 30/06/2023)
UPDATE pj_hermes.compra_materia_prima
SET data_transacao = DATE_ADD('2023-04-01', INTERVAL RAND() * 90 DAY)
WHERE data_transacao IS NULL
LIMIT 250; -- Ajustando o volume para o meio de 2023

-- Atualizar parte dos registros para o 3º trimestre de 2023 (01/07/2023 - 30/09/2023)
UPDATE pj_hermes.compra_materia_prima
SET data_transacao = DATE_ADD('2023-07-01', INTERVAL RAND() * 90 DAY)
WHERE data_transacao IS NULL
LIMIT 250; -- Ajustando o volume para o 3º trimestre de 2023

-- Atualizar parte dos registros para o 4º trimestre de 2023 (01/10/2023 - 31/12/2023)
UPDATE pj_hermes.compra_materia_prima
SET data_transacao = DATE_ADD('2023-10-01', INTERVAL RAND() * 90 DAY)
WHERE data_transacao IS NULL
LIMIT 300; -- Ajustando o volume para o final de 2023

-- Atualizar parte dos registros para o 1º trimestre de 2024 (01/01/2024 - 31/03/2024)
UPDATE pj_hermes.compra_materia_prima
SET data_transacao = DATE_ADD('2024-01-01', INTERVAL RAND() * 90 DAY)
WHERE data_transacao IS NULL
LIMIT 300; -- Ajustando o volume para o início de 2024

-- Atualizar parte dos registros para o 2º trimestre de 2024 (01/04/2024 - 30/06/2024)
UPDATE pj_hermes.compra_materia_prima
SET data_transacao = DATE_ADD('2024-04-01', INTERVAL RAND() * 90 DAY)
WHERE data_transacao IS NULL
LIMIT 250; -- Ajustando o volume para o meio de 2024

-- Atualizar parte dos registros para o 3º trimestre de 2024 (01/07/2024 - 30/09/2024)
UPDATE pj_hermes.compra_materia_prima
SET data_transacao = DATE_ADD('2024-07-01', INTERVAL RAND() * 90 DAY)
WHERE data_transacao IS NULL
LIMIT 250; -- Ajustando o volume para o 3º trimestre de 2024

-- Atualizar o restante dos registros para o 4º trimestre de 2024 até a data atual
UPDATE pj_hermes.compra_materia_prima
SET data_transacao = DATE_ADD('2024-10-01', INTERVAL RAND() * 19 DAY) -- De 01/10/2024 até a data atual (19 dias)
WHERE data_transacao IS NULL;

*/

/*Equilibrando volume na tabela CP
WITH volume_trimestral AS (
    SELECT 
        QUARTER(cmp.data_transacao) AS Trimestre,
        YEAR(cmp.data_transacao) AS Ano,
        COUNT(*) AS Registros
    FROM 
        pj_hermes.compra_materia_prima cmp
    WHERE 
        cmp.data_transacao IS NOT NULL
    GROUP BY 
        YEAR(cmp.data_transacao), QUARTER(cmp.data_transacao)
)
SELECT 
    'compra_materia_prima' AS 'Entidade',
    vt.Trimestre,
    vt.Ano,
    vt.Registros,
    ROUND(vt.Registros * ((t.data_length + t.index_length) / (SELECT COUNT(*) FROM pj_hermes.compra_materia_prima)), 2) AS EspacoTotalKB,
    ROUND(vt.Registros * (t.data_length / (SELECT COUNT(*) FROM pj_hermes.compra_materia_prima)), 2) AS EspacoUsadoKB,
    ROUND(vt.Registros * (t.index_length / (SELECT COUNT(*) FROM pj_hermes.compra_materia_prima)), 2) AS EspacoIndexKB,
    ROUND(vt.Registros * (t.data_free / (SELECT COUNT(*) FROM pj_hermes.compra_materia_prima)), 2) AS EspacoNaoUsadoKB
FROM 
    volume_trimestral vt
JOIN 
    information_schema.tables t ON t.table_name = 'compra_materia_prima'
WHERE 
    t.table_schema = 'pj_hermes'
ORDER BY 
    vt.Ano, vt.Trimestre;
    */

/*tabela Ordem_Produção*/

/*Criando tabela OP temporária para inserir datas
CREATE TEMPORARY TABLE temp_ordem_producao AS
SELECT idLote, ROW_NUMBER() OVER (ORDER BY idLote) AS rn
FROM pj_hermes.ordem_producao
WHERE data_criacao IS NULL;*/

/*Atualizando datas OP
UPDATE pj_hermes.ordem_producao o
JOIN temp_ordem_producao t
ON o.idLote = t.idLote
SET o.data_criacao = DATE_ADD('2022-10-01', INTERVAL t.rn DAY)
WHERE t.rn <= 2000;*/

/*Distribuindo volume OP
UPDATE pj_hermes.ordem_producao o
JOIN temp_ordem_producao t
ON o.idLote = t.idLote
SET o.data_criacao = DATE_ADD('2022-10-01', INTERVAL t.rn DAY)
WHERE t.rn <= 2000;

UPDATE pj_hermes.ordem_producao o
JOIN temp_ordem_producao t
ON o.idLote = t.idLote
SET o.data_criacao = DATE_ADD('2023-01-01', INTERVAL t.rn DAY)
WHERE t.rn > 2000 AND t.rn <= 5000;

UPDATE pj_hermes.ordem_producao o
JOIN temp_ordem_producao t
ON o.idLote = t.idLote
SET o.data_criacao = DATE_ADD('2023-04-01', INTERVAL t.rn DAY)
WHERE t.rn > 5000 AND t.rn <= 7500;

UPDATE pj_hermes.ordem_producao o
JOIN temp_ordem_producao t
ON o.idLote = t.idLote
SET o.data_criacao = DATE_ADD('2023-04-01', INTERVAL t.rn DAY)
WHERE t.rn > 5000 AND t.rn <= 7500;

UPDATE pj_hermes.ordem_producao o
JOIN temp_ordem_producao t
ON o.idLote = t.idLote
SET o.data_criacao = DATE_ADD('2023-07-01', INTERVAL t.rn DAY)
WHERE t.rn > 7500;    vt.Ano, vt.Trimestre;

UPDATE pj_hermes.ordem_producao o
JOIN temp_ordem_producao t
ON o.idLote = t.idLote
SET o.data_criacao = DATE_ADD('2023-07-01', INTERVAL t.rn DAY)
WHERE t.rn > 7500;    vt.Ano, vt.Trimestre;
*/

/*Equilibrando na tabela OP
WITH volume_trimestral AS (
    SELECT 
        QUARTER(o.data_criacao) AS Trimestre,
        YEAR(o.data_criacao) AS Ano,
        COUNT(*) AS Registros
    FROM 
        pj_hermes.ordem_producao o
    WHERE 
        o.data_criacao IS NOT NULL
    GROUP BY 
        YEAR(o.data_criacao), QUARTER(o.data_criacao)
)
SELECT 
    'ordem_producao' AS 'Entidade',
    vt.Trimestre,
    vt.Ano,
    vt.Registros,
    ROUND(vt.Registros * ((t.data_length + t.index_length) / (SELECT COUNT(*) FROM pj_hermes.ordem_producao)), 2) AS EspacoTotalKB,
    ROUND(vt.Registros * (t.data_length / (SELECT COUNT(*) FROM pj_hermes.ordem_producao)), 2) AS EspacoUsadoKB,
    ROUND(vt.Registros * (t.index_length / (SELECT COUNT(*) FROM pj_hermes.ordem_producao)), 2) AS EspacoIndexKB,
    ROUND(vt.Registros * (t.data_free / (SELECT COUNT(*) FROM pj_hermes.ordem_producao)), 2) AS EspacoNaoUsadoKB
FROM 
    volume_trimestral vt
JOIN 
    information_schema.tables t ON t.table_name = 'ordem_producao'
WHERE 
    t.table_schema = 'pj_hermes'
ORDER BY 
    vt.Ano, vt.Trimestre; */