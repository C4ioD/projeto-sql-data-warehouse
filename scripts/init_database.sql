/*
=============================================================
Criar Banco de Dados e Esquemas
=============================================================
Propósito do Script:
    Este script cria um novo banco de dados chamado 'DataWarehouse' após verificar se ele já existe. 
    Se o banco de dados existir, ele será excluído e recriado. Além disso, o script configura três esquemas 
    dentro do banco de dados: 'bronze', 'silver' e 'gold'.
	
AVISO:
    A execução deste script excluirá todo o banco de dados 'DataWarehouse', caso ele exista. 
    Todos os dados no banco de dados serão permanentemente apagados. Prossiga com cuidado 
    e certifique-se de ter backups adequados antes de executar este script.
*/

-- 1. Alterna para o banco de dados do sistema 'master' 
-- (Necessário para poder alterar ou excluir outros bancos de dados)
USE master;
GO

-- 2. Verifica se o banco 'DataWarehouse' já existe no servidor
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    -- Força o encerramento de todas as conexões ativas imediatamente (ROLLBACK IMMEDIATE)
    -- e coloca o banco em modo de usuário único para liberar o bloqueio de exclusão
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    
    -- Deleta o banco de dados antigo e todo o seu conteúdo
    DROP DATABASE DataWarehouse;
END;
GO

-- 3. Cria um novo banco de dados totalmente limpo
CREATE DATABASE DataWarehouse;
GO

-- 4. Entra no contexto do novo banco de dados recém-criado
USE DataWarehouse;
GO

-- ============================================================================
-- Criação dos Schemas (Camadas da Arquitetura Medalhão)
-- ============================================================================

-- Cria o schema 'bronze': Camada de dados brutos (Raw/Staging)
-- Armazena os dados exatamente como vêm das fontes de origem, sem tratamentos.
CREATE SCHEMA bronze;
GO

-- Cria o schema 'silver': Camada de dados limpos e validados
-- Armazena dados padronizados, sem duplicatas e com tipos de dados corrigidos.
CREATE SCHEMA silver;
GO

-- Cria o schema 'gold': Camada de dados de negócio (Analytics/BI)
-- Armazena dados modelados (ex: Star Schema), agregados e prontos para relatórios.
CREATE SCHEMA gold;
GO
