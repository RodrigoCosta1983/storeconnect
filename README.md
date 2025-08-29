## StoreConnect - Plataforma de Gestão Multi-Loja v1.0

Flutter Firebase Dart Status Platform

Uma plataforma centralizada para gerenciar múltiplas distribuidoras de gelo (como o Master Gelo), construída com Flutter e Firebase, com foco em controle financeiro, integração de lojas e processamento de mensalidades.

## 📖 Sobre o Projeto

StoreConnect é uma solução multiplataforma que atua como um hub para conectar e gerenciar distribuidoras de gelo. O projeto foi concebido para centralizar a administração de lojas, processar mensalidades via Mercado Pago e fornecer uma interface unificada para monitoramento de desempenho, substituindo processos manuais por um sistema reativo e acessível em dispositivos móveis e na web.

O principal objetivo é oferecer aos proprietários de lojas uma plataforma que facilite a gestão de mensalidades e o controle agregado de vendas, estoque e finanças, com foco em escalabilidade e integração.

## ✨ Funcionalidades Principais

#### 🔑 Autenticação e Gestão de Lojas

- Sistema de Login Completo: Autenticação segura de usuários com E-mail e Senha via Firebase Authentication.
- Arquitetura Multi-Tenant: Dados de cada loja (ex.: Master Gelo) completamente isolados e protegidos no banco de dados.
- Gestão de Lojas: Tela dedicada para adicionar, editar ou remover lojas conectadas.

#### 💰 Gestão de Mensalidades

- Pagamento de Mensalidades: Processamento seguro de taxas mensais via Mercado Pago.
- Registro de Pagamentos: Histórico de pagamentos salvo no Firestore, com status (ativo, pendente).
- Alertas de Vencimento: Notificações visuais para mensalidades próximas do vencimento.

#### 📊 Dashboard Agregado

- Painel de Controle Interativo: Métricas globais em tempo real (vendas totais, contas a receber, lojas ativas).
- Filtros de Período: Análise de desempenho com filtros por Hoje, Semana e Mês.
- Navegação por Atalhos: Cards da dashboard que levam a listas filtradas.

#### 🎨 Experiência do Usuário (UI/UX)

- Interface Adaptativa: Layout que se adapta a diferentes tamanhos de tela (móvel e web).
- Suporte a Temas: Modo Claro e Escuro totalmente funcionais.
- Performance Otimizada: Uso de `StreamBuilder` para atualizações em tempo real.

## 🛠️ Tecnologias e Arquitetura

- Framework Principal: Flutter
- Linguagem: Dart (com Sound Null Safety)
- Backend (BaaS): Firebase
  - Autenticação: Firebase Authentication
  - Banco de Dados: Cloud Firestore
  - Pagamentos: Mercado Pago
- Gerenciamento de Estado: Provider
- Bibliotecas Adicionais: `mercado_pago`, `fl_chart`, `cloud_firestore`.

## 🔥 Configuração para Execução

Este projeto depende dos serviços do Firebase e do Mercado Pago. Para executá-lo localmente:

1. Crie um novo projeto no Firebase Console.
2. Ative os serviços Authentication (provedor "E-mail/senha") e Firestore Database (modo de teste).
3. Ajuste as Regras de Segurança do Firestore para permitir leitura e escrita para usuários autenticados.
4. Use a FlutterFire CLI (`flutterfire configure`) para gerar o arquivo `lib/firebase_options.dart`.
5. Obtenha credenciais de teste do Mercado Pago (Public Key e Access Token) no [Painel do Mercado Pago](https://www.mercadopago.com.br/developers/en/docs).

## 🚀 Como Executar o Projeto

```
# 1. Clone o repositório
git clone https://github.com/RodrigoCosta1983/storeconnect.git

# 2. Navegue para a pasta do projeto
cd store_connect

# 3. Instale as dependências
flutter pub get

# 4. Execute o aplicativo
flutter run
```

## 👨‍💻 Autor
RodrigoCostaDEV

GitHub: @RodrigoCosta1983

Website: rodrigocosta-dev.com