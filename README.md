# Gelo Gestor - Sistema de Gestão para Distribuidoras v1.1.4

![Flutter](https://img.shields.io/badge/Framework-Flutter-02569B?style=for-the-badge&logo=flutter)
![Firebase](https://img.shields.io/badge/Backend-Firebase-FFCA28?style=for-the-badge&logo=firebase)
![Dart](https://img.shields.io/badge/Language-Dart-0175C2?style=for-the-badge&logo=dart)
![Status](https://img.shields.io/badge/Status-Completo-green?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-blue?style=for-the-badge)

> Um sistema de gestão completo e multiplataforma para distribuidoras de gelo, construído com Flutter e Firebase, com foco em controle de vendas, clientes, finanças e estoque.

---

## 📖 Sobre o Projeto

**Gelo Gestor** é um aplicativo completo que serve como uma solução de gestão de ponta a ponta para distribuidoras de gelo. O projeto foi concebido para digitalizar e otimizar operações diárias, substituindo controles manuais por um sistema centralizado, reativo e acessível em dispositivos móveis e na web.

O principal objetivo é fornecer ao proprietário do negócio uma ferramenta poderosa para gerenciar vendas, clientes, estoque e finanças, com um foco especializado no controle de vendas a prazo (fiado), uma das maiores dores do setor.

<br>

## ✨ Funcionalidades Principais

A versão atual do aplicativo é um produto funcional completo, com dados persistidos na nuvem e uma arquitetura robusta.

#### 🔑 **Autenticação & Segurança Multi-Tenant**
* **Sistema de Login Completo:** Autenticação segura de usuários com E-mail e Senha via **Firebase Authentication**.
* **Arquitetura Multi-Tenant:** Os dados de cada usuário (loja) são completamente isolados e seguros no banco de dados, utilizando as Regras de Segurança do Firebase.
* **Gerenciamento de Sessão:** Login persistente (o usuário não é deslogado ao fechar o app) e função de "Sair" segura.

#### 📦 **Gestão de Estoque e Dados (CRUD Completo)**
* **Controle de Estoque:** Cadastro da quantidade inicial de produtos e **baixa automática e segura** no estoque a cada venda realizada, utilizando Transações do Firestore.
* **Gerenciamento de Produtos:** Tela dedicada para Criar, Ler, Editar e Excluir produtos.
* **Upload de Imagens:** Funcionalidade para adicionar imagens aos produtos, com upload para o **Firebase Storage**.
* **Gerenciamento de Clientes:** Tela dedicada para Criar, Ler, Editar e Excluir clientes.
* **Busca Inteligente:** Funcionalidade de busca *case-insensitive* em tempo real para encontrar produtos e clientes.

#### 💰 **Fluxo de Venda e Financeiro**
* **Ponto de Venda (PDV) Reativo:** Tela de "Nova Venda" que lê o catálogo de produtos (com imagens e estoque) em tempo real do Firestore.
* **Multi-pagamento:** Suporte para vendas em Dinheiro, Cartão, PIX (com exibição de QR Code) e "Fiado".
* **Gestão de Vendas "Fiado":** Fluxo completo para vendas a prazo, com seleção de clientes do banco de dados e definição de data de vencimento.
* **Controle de Pagamentos:** Função para **marcar uma conta como paga**, que atualiza o status da venda e credita o valor ao caixa.
* **Histórico de Vendas Detalhado:** Lista de todas as vendas salvas no Firestore, com filtros e detalhes expansíveis.
* **Alertas Visuais:** O histórico destaca automaticamente vendas vencidas e não pagas.

#### 📊 **Dashboard & Análise de Dados**
* **Painel de Controle Interativo:** Dashboard com métricas de negócio em tempo real (Vendas do Período, Caixa, Contas a Receber, Contas Vencidas).
* **Filtros de Período:** Análise de performance de vendas com filtros por **Hoje, Semana e Mês**.
* **Gráficos Dinâmicos:** Visualização de dados de vendas em gráficos de barra para análises semanais e mensais.
* **Navegação por Atalhos:** Cards da dashboard que funcionam como atalhos para listas já filtradas.

#### 🎨 **Experiência do Usuário (UI/UX)**
* **Interface Adaptativa:** O layout se adapta automaticamente para diferentes tamanhos de tela, funcionando bem em celulares (retrato/paisagem) e na web.
* **Suporte a Temas:** Interface totalmente funcional em **Modo Claro** e **Modo Escuro**.
* **Performance Otimizada:** Splash screen na inicialização e pré-carregamento de imagens para uma experiência mais fluida.

<hr>

## 🛠️ Tecnologias e Arquitetura

* **Framework Principal:** **[Flutter](https://flutter.dev/)**
* **Linguagem:** **[Dart](https://dart.dev/)** (com Sound Null Safety)
* **Backend (BaaS):** **[Firebase](https://firebase.google.com/)**
  * **Autenticação:** Firebase Authentication
  * **Banco de Dados:** Cloud Firestore (com Transações para consistência de dados)
  * **Armazenamento de Arquivos:** Firebase Storage
* **Gerenciamento de Estado:** **[Provider](https://pub.dev/packages/provider)**
* **UI Reativa:** O aplicativo foi construído em torno do widget **`StreamBuilder`**, permitindo que a interface reaja e se atualize instantaneamente a qualquer mudança nos dados do Firestore.
* **Bibliotecas Adicionais Notáveis:**
  * **`fl_chart`**: Para a criação dos gráficos dinâmicos.
  * **`image_picker`**: Para a seleção de imagens da galeria.
  * **`intl`**, **`package_info_plus`**, **`url_launcher`**.

<hr>

## 🔥 Configuração para Execução

Este projeto depende totalmente dos serviços do Firebase. Para executá-lo localmente:

1.  Crie um novo projeto no [Firebase Console](https://console.firebase.google.com/).
2.  Ative os serviços **Authentication** (provedor "E-mail/senha"), **Firestore Database** (no modo de teste) e **Storage**.
3.  Ajuste as **Regras de Segurança** do Firestore e do Storage para permitir leitura e escrita para usuários autenticados.
4.  Use a **FlutterFire CLI** (`flutterfire configure`) para conectar seu app ao projeto, o que irá gerar o arquivo `lib/firebase_options.dart`.
5.  Crie os índices compostos do Firestore que serão solicitados no console de depuração ao executar as buscas e filtros pela primeira vez.

<hr>

## 🚀 Como Executar o Projeto


# 1. Clone o repositório
git clone [https://github.com/RodrigoCosta1983/tienda_model_.git](https://github.com/RodrigoCosta1983/tienda_model_.git)

# 2. Navegue para a pasta do projeto
cd tienda_model_

# 3. Instale as dependências
flutter pub get

# 4. Execute o aplicativo
flutter run
👨‍💻 Autor
RodrigoCostaDEV

GitHub: @RodrigoCosta1983

Website: rodrigocosta-dev.com

=================================================================================================================

# Gelo Gestor - Management System for Distributors v1.1.4

![Flutter](https://img.shields.io/badge/Framework-Flutter-02569B?style=for-the-badge&logo=flutter)
![Firebase](https://img.shields.io/badge/Backend-Firebase-FFCA28?style=for-the-badge&logo=firebase)
![Dart](https://img.shields.io/badge/Language-Dart-0175C2?style=for-the-badge&logo=dart)
![Status](https://img.shields.io/badge/Status-Completo-green?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-blue?style=for-the-badge)

> A complete, multi-platform management system for ice distributors, built with Flutter and Firebase, focusing on sales, customer, financial, and inventory control.

---

## 📖 About the Project

**Gelo Gestor** is a complete application that serves as an end-to-end management solution for ice distributors. The project was designed to digitize and optimize daily operations, replacing manual controls with a centralized, responsive system that's accessible on mobile devices and the web.

The main objective is to provide business owners with a powerful tool for managing sales, customers, inventory, and finances, with a specialized focus on credit sales management, one of the biggest pain points in the industry.

<br>

## ✨ Main Features

The current version of the app is a fully functional product, with data persisted in the cloud and a robust architecture.

#### 🔑 **Multi-Tenant Authentication & Security**
* **Full Login System:** Secure user authentication with email and password via **Firebase Authentication**.
* **Multi-Tenant Architecture:** Each user's (store's) data is completely isolated and secure in the database, using Firebase Security Rules.
* **Session Management:** Persistent login (the user is not logged out when closing the app) and a secure "Logout" function.

#### 📦 **Inventory and Data Management (Complete CRUD)**
* **Inventory Control:** Register the initial quantity of products and **automatically and securely reduce** inventory with each sale made, using Firestore Transactions.
* **Product Management:** Dedicated screen for Creating, Reading, Editing, and Deleting products.
* **Image Upload:** Functionality for adding images to products, with upload to **Firebase Storage**.
* **Customer Management:** Dedicated screen for Creating, Reading, Editing, and Deleting customers.
* **Smart Search:** Real-time, case-insensitive search functionality to find products and customers.

#### 💰 **Sales and Financial Flow**
* **Reactive Point of Sale (POS):** "New Sale" screen that reads the product catalog (with images and inventory) in real time from Firestore. * **Multi-payment:** Support for sales in cash, card, PIX (with QR code display), and "Credit".
* **"Credit" Sales Management:** Complete flow for installment sales, with customer selection from the database and due date definition.
* **Payment Control:** Function to **mark an account as paid**, which updates the sale status and credits the amount to the cashier.
* **Detailed Sales History:** List of all sales saved in Firestore, with filters and expandable details.
* **Visual Alerts:** The history automatically highlights overdue and unpaid sales.

#### 📊 **Dashboard & Data Analysis**
* **Interactive Control Panel:** Dashboard with real-time business metrics (Period Sales, Cash, Accounts Receivable, Overdue Accounts). * **Period Filters:** Sales performance analysis with filters by **Today, Week, and Month**.
* **Dynamic Charts:** Visualization of sales data in bar graphs for weekly and monthly analysis.
* **Shortcut Navigation:** Dashboard cards that function as shortcuts to previously filtered lists.

#### 🎨 **User Experience (UI/UX)**
* **Adaptive Interface:** The layout automatically adapts to different screen sizes, working well on mobile devices (portrait/landscape) and the web.
* **Theme Support:** Fully functional interface in **Light Mode** and **Dark Mode**.
* **Optimized Performance:** Splash screen on startup and image preloading for a more fluid experience.

<hr>

## 🛠️ Technologies and Architecture

* **Main Framework:** **[Flutter](https://flutter.dev/)**
* **Language:** **[Dart](https://dart.dev/)** (with Sound Null Safety)
* **Backend (BaaS):** **[Firebase](https://firebase.google.com/)**
* **Authentication:** Firebase Authentication
* **Database:** Cloud Firestore (with Transactions for data consistency)
* **File Storage:** Firebase Storage
* **State Management:** **[Provider](https://pub.dev/packages/provider)**
* **Reactive UI:** The application is built around the **`StreamBuilder`** widget, allowing the interface to react and update instantly to any changes in Firestore data. * **Notable Additional Libraries:**
* **`fl_chart`**: For creating dynamic charts.
* **`image_picker`**: For selecting images from the gallery.
* **`intl`**, **`package_info_plus`**, **`url_launcher`**.

<hr>

## 🔥 Runtime Configuration

This project fully relies on Firebase services. To run it locally:

1. Create a new project in the [Firebase Console](https://console.firebase.google.com/).
2. Enable the **Authentication** ("Email/Password" provider), **Firestore Database** (in test mode), and **Storage** services.
3. Adjust the **Security Rules** for Firestore and Storage to allow reading and writing for authenticated users. 4. Use the FlutterFire CLI (flutterfire configure) to connect your app to the project, which will generate the lib/firebase_options.dart file.
5. Create the Firestore composite indexes that will be requested in the debug console when running searches and filters for the first time.

<hr>

## 🚀 How to Run the Project

```bash
# 1. Clone the repository
git clone [https://github.com/RodrigoCosta1983/tienda_model_.git](https://github.com/RodrigoCosta1983/tienda_model_.git)

# 2. Navigate to the project folder
cd tienda_model_

# 3. Install the dependencies
flutter pub get

# 4. Run the application
flutter run
👨‍💻 Author
RodrigoCostaDEV

GitHub: @RodrigoCosta1983

Website: rodrigocosta-dev.com
