<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gelo Gestor - Apresentação do Aplicativo</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        /* --- Reset e Estilos Globais --- */
        body {
            font-family: 'Poppins', -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif;
            line-height: 1.7;
            color: #4A5568;
            background-color: #F7FAFC;
            margin: 0;
            padding: 20px;
        }

        /* --- Container Principal --- */
        .container {
            max-width: 900px;
            margin: 40px auto;
            padding: 40px;
            background-color: #FFFFFF;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05), 0 5px 10px rgba(0, 0, 0, 0.04);
        }

        /* --- Tipografia --- */
        h1, h2, h3 {
            font-weight: 700;
            color: #1A202C;
            margin-bottom: 0.5em;
        }
        h1 {
            font-size: 2.8em;
            text-align: center;
            letter-spacing: -1px;
            color: #2D3748;
        }
        h2 {
            font-size: 2em;
            margin-top: 60px;
            border-bottom: 3px solid #E2E8F0;
            padding-bottom: 10px;
        }
        p {
            margin-bottom: 1.2em;
            font-size: 1.1em;
        }
        a {
            color: #3182CE;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.2s ease-in-out;
        }
        a:hover {
            color: #2B6CB0;
            text-decoration: underline;
        }

        /* --- Seções e Cards --- */
        .header {
            text-align: center;
            margin-bottom: 60px;
        }
        .header p {
            font-size: 1.2em;
            color: #718096;
            max-width: 600px;
            margin: 20px auto 0 auto;
        }
        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
            margin-top: 30px;
        }
        .feature-card {
            background-color: #F7FAFC;
            padding: 25px;
            border-radius: 8px;
            border: 1px solid #E2E8F0;
            transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
        }
        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 15px rgba(0,0,0,0.06);
        }
        .feature-card h3 {
            font-size: 1.3em;
            margin-top: 0;
            display: flex;
            align-items: center;
        }
        .feature-card ul {
            padding-left: 20px;
            color: #4A5568;
        }
        .feature-card li {
            margin-bottom: 8px;
        }
        .icon {
            margin-right: 12px;
            color: #3182CE;
            font-size: 1.5em;
        }
        .tech-stack ul {
            list-style: none;
            padding: 0;
        }
        .tech-stack li {
            background-color: #EDF2F7;
            padding: 10px 15px;
            border-radius: 6px;
            margin-bottom: 8px;
            font-weight: 600;
        }

        /* --- Rodapé --- */
        footer {
            text-align: center;
            margin-top: 60px;
            padding-top: 20px;
            border-top: 1px solid #E2E8F0;
            color: #A0AEC0;
        }
    </style>
</head>
<body>

    <div class="container">
        <header class="header">
            <h1>Gelo Gestor</h1>
            <p>A solução completa e moderna para a gestão de distribuidoras de gelo, otimizando vendas, finanças e o controle de clientes.</p>
        </header>

        <section id="objetivo">
            <h2>🎯 Objetivo do Aplicativo</h2>
            <p>O Gelo Gestor foi concebido para resolver os desafios diários enfrentados por distribuidoras de gelo. O objetivo principal é substituir processos manuais, como anotações em cadernos e planilhas complexas, por uma ferramenta digital, centralizada e acessível. O foco é proporcionar clareza sobre o fluxo de caixa, simplificar o registro de vendas e, crucialmente, oferecer um controle rigoroso e eficiente sobre as vendas a prazo (fiado), reduzindo perdas e facilitando a cobrança.</p>
        </section>

        <section id="funcionalidades">
            <h2>✨ O Que o Aplicativo Faz? (Funcionalidades)</h2>
            <div class="features-grid">
                <div class="feature-card">
                    <h3><span class="icon">📊</span>Dashboard Analítico</h3>
                    <ul>
                        <li>Visão geral do negócio com métricas em tempo real.</li>
                        <li>Filtros de vendas por Hoje, Semana e Mês.</li>
                        <li>Gráficos interativos para análise de performance.</li>
                        <li>Cards que servem como atalhos para listas detalhadas.</li>
                    </ul>
                </div>
                <div class="feature-card">
                    <h3><span class="icon">💰</span>Gestão Financeira Completa</h3>
                    <ul>
                        <li>Registro de vendas "fiado" associadas a um cliente.</li>
                        <li>Seleção de data de vencimento para cada conta.</li>
                        <li>Função para "Marcar como Pago", que atualiza o status da venda e o saldo do caixa.</li>
                        <li>Alertas visuais no histórico para contas vencidas.</li>
                    </ul>
                </div>
                <div class="feature-card">
                    <h3><span class="icon">📦</span>Gerenciamento de Dados</h3>
                    <ul>
                        <li>Controle total (Criar, Ler, Editar, Excluir) de Produtos.</li>
                        <li>Controle total (Criar, Ler, Editar, Excluir) de Clientes.</li>
                        <li>Busca inteligente e "case-insensitive" para encontrar produtos rapidamente.</li>
                        <li>Dados salvos de forma segura e permanente na nuvem.</li>
                    </ul>
                </div>
                <div class="feature-card">
                    <h3><span class="icon">🔒</span>Segurança e Usabilidade</h3>
                    <ul>
                        <li>Sistema de Autenticação com e-mail e senha.</li>
                        <li>Suporte completo a Modo Claro e Modo Escuro.</li>
                        <li>Interface reativa que atualiza os dados em tempo real.</li>
                        <li>Design intuitivo e profissional.</li>
                    </ul>
                </div>
            </div>
        </section>

        <section id="tecnologias">
            <h2>🛠️ Como Foi Construído? (Tecnologias Usadas)</h2>
            <p>O aplicativo foi desenvolvido com as tecnologias mais modernas do mercado de desenvolvimento móvel para garantir performance, segurança e escalabilidade.</p>
            <div class="tech-stack">
                <ul>
                    <li><strong>Framework Principal:</strong> Flutter (para uma interface nativa e de alta performance em Android e iOS).</li>
                    <li><strong>Linguagem:</strong> Dart (moderna, segura e otimizada para interfaces de usuário).</li>
                    <li><strong>Backend e Banco de Dados:</strong> Firebase (plataforma do Google que oferece banco de dados em tempo real, autenticação e outros serviços na nuvem).</li>
                    <li><strong>Gerenciamento de Estado:</strong> Provider (para uma arquitetura de código limpa e organizada).</li>
                    <li><strong>Bibliotecas Adicionais:</strong> `fl_chart` para gráficos e `intl` para formatação de datas e moedas.</li>
                </ul>
            </div>
        </section>
        
        <footer>
            <p>Desenvolvido por RodrigoCosta-DEV em parceria com a IA Dev da Google.</p>
        </footer>
    </div>

</body>
</html>
