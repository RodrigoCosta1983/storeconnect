# Gelo Gestor - Sistema de Gestão para Distribuidoras

## 📖 Sobre o Projeto

**Gelo Gestor** é um protótipo funcional de alta fidelidade de um aplicativo móvel, construído em Flutter, projetado para otimizar a gestão de pequenas e médias distribuidoras de gelo. A aplicação visa solucionar desafios comuns do setor, como o controle de estoque, o registro de vendas e, principalmente, a complexa gestão de pagamentos a prazo (vendas "fiado").

O projeto foi desenvolvido com foco em uma experiência de usuário limpa, intuitiva e eficiente, permitindo que o dono do negócio tenha uma visão clara e em tempo real da saúde financeira e operacional de sua empresa diretamente do seu smartphone.

-----

## ✨ Principais Funcionalidades

O protótipo atual inclui as seguintes funcionalidades, todas operando em memória (sem persistência de dados em banco de dados ainda):

  * **📱 Interface Moderna e Adaptável:**

      * Suporte completo a **Modo Claro (Light Mode)** e **Modo Escuro (Dark Mode)**.
      * Design responsivo e limpo, focado na usabilidade.

  * **💰 Fluxo de Venda Completo:**

      * Tela de vendas com catálogo de produtos em formato de "cards" visuais.
      * Carrinho de compras interativo com ajuste de quantidade de itens.
      * Múltiplas formas de pagamento (Dinheiro, PIX, Cartão).

  * **📋 Gestão de Vendas 'Fiado' (Core do App):**

      * Registro de vendas a prazo associadas a um cliente cadastrado.
      * Seleção de data de vencimento para cada venda "fiado".
      * Mecanismo para **marcar uma conta como paga**, atualizando o status da venda.

  * **📊 Dashboard Gerencial:**

      * Visão geral do negócio com cards informativos e interativos.
      * Filtro de vendas por período: **Hoje, Semana e Mês**.
      * Atalhos para listas detalhadas de contas a receber e contas vencidas.

  * **📚 Histórico e Controle:**

      * Tela de histórico de todas as vendas realizadas.
      * Detalhes expansíveis para cada venda, exibindo os produtos, quantidades e valores.
      * **Alerta visual automático** (ícone e borda vermelha) para contas vencidas e não pagas.

  * **💵 Gestão de Caixa Simplificada:**

      * Controle de saldo em caixa que é atualizado automaticamente quando uma venda "fiado" é marcada como paga.

-----

## 🛠️ Tecnologias Utilizadas

Este projeto foi construído utilizando tecnologias modernas do ecossistema Flutter:

  * **Framework:** [Flutter](https://flutter.dev/)
  * **Linguagem de Programação:** [Dart](https://dart.dev/)
  * **Gerenciamento de Estado:** [Provider](https://pub.dev/packages/provider) - para uma gestão de estado reativa e simplificada (ex: `CartProvider`, `SalesProvider`).
  * **Pacotes Adicionais:**
      * `intl`: Para formatação de datas e moedas.
  * **Arquitetura:** A estrutura do projeto foi organizada visando a escalabilidade, separando a lógica em:
      * `models`: Estrutura dos dados (Produto, Venda, Cliente).
      * `providers`: Lógica de negócio e gerenciamento de estado.
      * `screens`: Telas principais da aplicação.
      * `widgets`: Componentes de UI reutilizáveis (ex: item de venda, cards).

-----

 
-----

## 🗺️ Próximos Passos (Roadmap)

Este protótipo é a base para a versão final do aplicativo. Os próximos passos planejados são:

  - [ ] **Integração com Firebase:**
      - [ ] Configurar o projeto Firebase e conectar ao app Flutter.
      - [ ] Implementar **Firebase Authentication** para um sistema de login real.
      - [ ] Utilizar o **Cloud Firestore** para persistir todos os dados (Produtos, Clientes, Vendas).
  - [ ] **CRUD de Produtos e Clientes:**
      - [ ] Criar telas para Adicionar, Editar e Excluir produtos do catálogo.
      - [ ] Criar telas para Adicionar, Editar e Excluir clientes.
  - [ ] **Melhorias de UI/UX:**
      - [ ] Refinar animações e transições.
      - [ ] Desenvolver um logotipo e identidade visual para o app.

-----

## 👨‍💻 Autor

**Rodrigo Costa DEV**

  * GitHub: `[[@RodrigoCosta1983]((https://github.com/RodrigoCosta1983))`
  * LinkedIn: `[Rodrigo Costa DEV](https://www.linkedin.com/in/dev-rodrigo-costa/)`

-----

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](https://www.google.com/search?q=LICENSE) para mais detalhes.
