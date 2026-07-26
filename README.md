
# SQL Data Warehouse: Projeto de Engenharia de Dados de Ponta a Ponta

## 📌 Visão Geral do Projeto
Este projeto demonstra a construção de um **Data Warehouse SQL moderno** do zero, simulando a implementação de soluções de dados em empresas do mundo real. O objetivo principal é consolidar dados de vendas de dois sistemas de origem (**CRM** e **ERP**) para permitir relatórios analíticos e tomadas de decisão informadas.

## 🏗️ Arquitetura do Sistema
O projeto segue a **Arquitetura Medallion**, organizada em três camadas lógicas para garantir a organização e a qualidade dos dados:

1.  **Camada Bronze (Raw):** Armazena os dados brutos e não processados exatamente como extraídos dos sistemas de origem (arquivos CSV). Foco total em **rastreabilidade e depuração**.
2.  **Camada Silver (Cleaned):** Contém dados limpos e padronizados. Aqui são aplicadas técnicas de **Data Cleansing**, como remoção de duplicatas, tratamento de nulos e normalização de formatos.
3.  **Gold (Business-Ready):** A camada final organizada em um modelo **Star Schema (Esquema Estrela)** para facilitar o consumo por ferramentas de BI. Esta camada utiliza **Views** em vez de tabelas físicas para garantir dinamismo e agilidade.

## 🛠️ Tecnologias Utilizadas
*   **Banco de Dados:** Microsoft SQL Server.
*   **Ferramentas de Desenvolvimento:** SQL Server Management Studio (SSMS).
*   **Design de Arquitetura:** Draw.io para diagramas de linhagem e modelos de dados.
*   **Gestão de Projeto:** Notion para acompanhamento de tarefas e épicos.
*   **Versionamento:** Git e GitHub.

## 🚀 Principais Etapas do Desenvolvimento
*   **Extração e Carga (ETL):** Implementação de processos de carga total usando a técnica de *Truncate and Insert* para manter o warehouse atualizado.
*   **Transformação de Dados:**
    *   Uso de **Window Functions** (`ROW_NUMBER`) para remoção de duplicatas e historização.
    *   Criação de **Surrogate Keys** para desacoplar o warehouse dos sistemas de origem.
    *   **Data Integration** para unir informações de clientes e produtos vindos de fontes distintas em uma única visão de negócio.
*   **Qualidade e Validação:** Scripts de testes automatizados para verificar integridade referencial e conformidade dos dados.
*   **Documentação Técnica:** Criação de um **Data Catalog** (Dicionário de Dados) detalhado para apoiar os usuários finais e analistas.

## 📊 Modelo de Dados
O modelo de dados final na camada **Gold** foi desenhado para ser intuitivo e performático:
*   **Dimensões:** `dim_customers`, `dim_products`.
*   **Fato:** `fact_sales` (conectando dimensões através de chaves substitutas).

## 📂 Estrutura do Repositório
*   `/scripts`: Contém todos os códigos DDL e DML organizados por camada.
*   `/docs`: Diagramas de arquitetura, linhagem de dados e dicionário de dados.
*   `/tests`: Scripts de validação de qualidade dos dados.

---
*Este projeto foi desenvolvido seguindo as melhores práticas de Engenharia de Dados, com foco na **Separação de Preocupações (Separation of Concerns)** para criar um sistema escalável e de fácil manutenção.*
