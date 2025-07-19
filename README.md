# Gelo Gestor - Sistema de Gestão para Distribuidoras v1.0

![Flutter](https://img.shields.io/badge/Framework-Flutter-02569B?style=for-the-badge&logo=flutter)
![Firebase](https://img.shields.io/badge/Backend-Firebase-FFCA28?style=for-the-badge&logo=firebase)
![Dart](https://img.shields.io/badge/Language-Dart-0175C2?style=for-the-badge&logo=dart)
![Status](https://img.shields.io/badge/Status-Completo-green?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-blue?style=for-the-badge)

> Um sistema de gestão completo e multiplataforma para distribuidoras de gelo, construído com Flutter e Firebase.

---

## 📖 Sobre o Projeto

**Gelo Gestor** é um aplicativo completo que serve como uma solução de gestão de ponta a ponta para distribuidoras de gelo. O projeto foi concebido para digitalizar e otimizar operações diárias, substituindo controles manuais por um sistema centralizado, reativo e acessível em dispositivos móveis e na web.

O principal objetivo é fornecer ao proprietário do negócio uma ferramenta poderosa para gerenciar vendas, clientes e finanças, com um foco especializado no controle de vendas a prazo (fiado), uma das maiores dores do setor.

<br>

## ✨ Funcionalidades Principais

A versão atual do aplicativo é um produto funcional completo, com dados persistidos na nuvem e uma arquitetura robusta.

#### 🔑 **Autenticação & Segurança Multi-Tenant**
* **Sistema de Login Completo:** Autenticação segura de usuários com E-mail e Senha via **Firebase Authentication**.
* **Arquitetura Multi-Tenant:** Os dados de cada usuário (loja) são completamente isolados e seguros no banco de dados, utilizando as Regras de Segurança do Firebase.
* **Gerenciamento de Sessão:** Login persistente e função de "Sair" segura.

#### 📊 **Dashboard & Análise de Dados**
* **Painel de Controle Interativo:** Dashboard com métricas de negócio em tempo real (Vendas do Período, Caixa, Contas a Receber, Contas Vencidas).
* **Filtros de Período:** Análise de performance de vendas com filtros por **Hoje, Semana e Mês**.
* **Gráficos Dinâmicos:** Visualização de dados de vendas em gráficos de barra para análises semanais e mensais.
* **Navegação por Atalhos:** Cards da dashboard que funcionam como atalhos para listas já filtradas.

#### 📦 **Gestão de Dados (CRUD Completo)**
* **Gerenciamento de Produtos:** Tela dedicada para Criar, Ler, Editar e Excluir produtos, com dados persistidos no Firestore.
* **Upload de Imagens:** Funcionalidade para adicionar imagens aos produtos, com upload para o **Firebase Storage**.
* **Gerenciamento de Clientes:** Tela dedicada para Criar, Ler, Editar e Excluir clientes.
* **Busca Inteligente:** Funcionalidade de busca *case-insensitive* em tempo real para encontrar produtos e clientes.

#### 💰 **Fluxo de Venda e Financeiro**
* **Ponto de Venda (PDV) Reativo:** Tela de "Nova Venda" que lê o catálogo de produtos (com imagens) em tempo real do Firestore.
* **Gestão de Vendas "Fiado":** Fluxo completo para vendas a prazo, com seleção de clientes do banco de dados e definição de data de vencimento.
* **Controle de Pagamentos:** Função para **marcar uma conta como paga**, que atualiza o status da venda e credita o valor ao caixa.
* **Histórico de Vendas Detalhado:** Lista de todas as vendas salvas no Firestore, com filtros e detalhes expansíveis.
* **Alertas Visuais:** O histórico destaca automaticamente vendas vencidas e não pagas.

#### 🎨 **Experiência do Usuário (UI/UX)**
* **Interface Adaptativa:** O layout se adapta automaticamente para diferentes tamanhos de tela, funcionando bem em celulares (retrato/paisagem) e na web.
* **Suporte a Temas:** Interface totalmente funcional em **Modo Claro** e **Modo Escuro**.
* **Design Consistente:** Fundos personalizados e elementos de UI que se adaptam ao tema para uma experiência visual coesa.
* **Performance Otimizada:** Imagens de fundo pré-carregadas na inicialização e uso de `StreamBuilder` para atualizações de UI eficientes e em tempo real.

<hr>

## 🛠️ Tecnologias e Arquitetura

* **Framework Principal:** **[Flutter](https://flutter.dev/)**
* **Linguagem:** **[Dart](https://dart.dev/)** (com Sound Null Safety)
* **Backend (BaaS):** **[Firebase](https://firebase.google.com/)**
  * **Autenticação:** Firebase Authentication
  * **Banco de Dados:** Cloud Firestore (NoSQL, em tempo real)
  * **Armazenamento de Arquivos:** Firebase Storage
* **Gerenciamento de Estado:** **[Provider](https://pub.dev/packages/provider)**
* **Bibliotecas Adicionais Notáveis:**
  * **`fl_chart`**: Para a criação dos gráficos dinâmicos.
  * **`image_picker`**: Para a seleção de imagens da galeria do dispositivo.
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

```bash
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