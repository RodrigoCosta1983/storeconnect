
# Gelo Gestor - Sistema de Gestão para Distribuidoras

![Flutter](https://img.shields.io/badge/Framework-Flutter-02569B?style=for-the-badge&logo=flutter)
![Firebase](https://img.shields.io/badge/Backend-Firebase-FFCA28?style=for-the-badge&logo=firebase)
![Dart](https://img.shields.io/badge/Language-Dart-0175C2?style=for-the-badge&logo=dart)
![Status](https://img.shields.io/badge/Status-V1.0-green?style=for-the-badge)

## 📖 Sobre o Projeto

**Gelo Gestor** é um aplicativo móvel completo, construído com Flutter e Firebase, que serve como uma solução de gestão de ponta a ponta para distribuidoras de gelo. O projeto foi concebido para digitalizar e otimizar operações diárias, substituindo controles manuais por um sistema centralizado, reativo e acessível.

O principal objetivo é fornecer ao proprietário do negócio uma ferramenta poderosa para gerenciar vendas, clientes e finanças, com um foco especializado no controle de vendas a prazo (fiado), uma das maiores dores do setor.

---

## ✨ Funcionalidades Implementadas

A versão atual do aplicativo é um produto funcional completo, com dados persistidos na nuvem e uma arquitetura robusta.

#### 🔑 **Autenticação & Segurança**
* **Sistema de Login Completo:** Autenticação segura de usuários com E-mail e Senha via **Firebase Authentication**.
* **Registro de Novos Usuários:** Fluxo de criação de conta direto no aplicativo com validação de dados.
* **Gerenciamento de Sessão:** Lógica de "Sair" que limpa o estado de navegação e retorna à tela de login de forma segura.

#### 📊 **Dashboard & Análise de Dados**
* **Painel de Controle Interativo:** Dashboard com métricas de negócio em tempo real (Vendas do Período, Caixa, Contas a Receber, Contas Vencidas).
* **Filtros de Período:** Análise de performance de vendas com filtros por **Hoje, Semana e Mês**.
* **Gráficos Dinâmicos:** Visualização de dados de vendas em gráficos de barra para análises semanais e mensais.
* **Navegação por Atalhos:** Cards da dashboard que funcionam como atalhos para listas pré-filtradas no histórico, otimizando o fluxo de trabalho do usuário.

#### 📦 **Gestão de Dados (CRUD Completo)**
* **Gerenciamento de Produtos:** Tela dedicada para Criar, Ler, Editar e Excluir produtos, com dados persistidos no Firestore.
* **Gerenciamento de Clientes:** Tela dedicada para Criar, Ler, Editar e Excluir clientes.
* **Busca Inteligente:** Funcionalidade de busca *case-insensitive* em tempo real para encontrar produtos e clientes rapidamente.

#### 💰 **Fluxo de Venda e Financeiro**
* **Ponto de Venda (PDV) Reativo:** Tela de "Nova Venda" que lê o catálogo de produtos em tempo real do Firestore.
* **Gestão de Vendas "Fiado":** Fluxo completo para vendas a prazo, com seleção de clientes do banco de dados e definição de data de vencimento.
* **Controle de Pagamentos:** Funcionalidade para **marcar uma conta como paga**, que atualiza o status da venda no Firestore e credita o valor ao caixa do aplicativo.
* **Histórico de Vendas Detalhado:** Lista de todas as vendas salvas no Firestore, com filtros e detalhes expansíveis.
* **Alertas Visuais:** O histórico destaca automaticamente vendas vencidas e não pagas com ícones e cores de alerta para facilitar a cobrança.

#### 🎨 **Experiência do Usuário (UI/UX)**
* **Suporte a Temas:** Interface totalmente adaptável para **Modo Claro** e **Modo Escuro**.
* **Design Consistente:** Fundos personalizados e elementos de UI que se adaptam ao tema para uma experiência visual coesa.
* **Feedback ao Usuário:** Uso de indicadores de carregamento, `SnackBar`s para confirmação e diálogos de alerta para operações críticas (como exclusão).

---

## 🛠️ Como Foi Construído? (Tecnologias e Arquitetura)

O aplicativo foi desenvolvido com uma stack de tecnologias modernas, focada em performance, escalabilidade e uma experiência de desenvolvimento ágil.

* **Framework Principal:** **[Flutter](https://flutter.dev/)** - Para uma interface de usuário compilada nativamente, garantindo performance e consistência visual em Android e iOS a partir de uma única base de código.
* **Linguagem de Programação:** **[Dart](https://dart.dev/)** - Com todos os recursos de segurança de tipos (Sound Null Safety).
* **Backend (BaaS - Backend as a Service):** **[Firebase](https://firebase.google.com/)**
    * **Autenticação:** **Firebase Authentication** para gerenciar o ciclo de vida dos usuários.
    * **Banco de Dados:** **Cloud Firestore** como nosso banco de dados NoSQL, em tempo real e escalável, para armazenar todos os dados da aplicação.
* **Gerenciamento de Estado:** **[Provider](https://pub.dev/packages/provider)** - Escolhido por sua simplicidade e poder para gerenciar o estado da aplicação de forma reativa e organizada.
* **UI Reativa:** O aplicativo foi construído em torno do widget **`StreamBuilder`**, permitindo que a interface reaja e se atualize instantaneamente a qualquer mudança nos dados do Firestore, sem a necessidade de recarregar a tela manualmente.
* **Bibliotecas Adicionais Notáveis:**
    * **`fl_chart`**: Para a criação dos gráficos dinâmicos e interativos na Dashboard.
    * **`intl`**: Para formatação de datas e valores monetários seguindo padrões locais.
    * **`package_info_plus`** e **`url_launcher`**: Para funcionalidades adicionais de UI.

---

## 🔥 Configuração para Execução

Este projeto depende totalmente dos serviços do Firebase. Para executá-lo localmente, siga os passos:

1.  Crie um novo projeto no [Firebase Console](https://console.firebase.google.com/).
2.  Ative os serviços **Authentication** (com o provedor "E-mail/senha") e **Firestore Database** (no modo de teste).
3.  Use a **FlutterFire CLI** com o comando `flutterfire configure` para conectar seu app ao projeto Firebase. Isso irá gerar o arquivo `lib/firebase_options.dart`.
4.  No Firestore, crie os índices compostos que serão solicitados no console de depuração ao executar as buscas e filtros pela primeira vez.

---

## 🚀 Como Executar o Projeto

```bash
# 1. Clone o repositório
git clone [https://github.com/seu-usuario/gelo-gestor.git](https://github.com/seu-usuario/gelo-gestor.git)

# 2. Navegue para a pasta do projeto
cd gelo-gestor

# 3. Instale as dependências
flutter pub get

# 4. Execute o aplicativo
flutter run
