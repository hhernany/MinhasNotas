# Minhas Pautas

Aplicativo desenvolvido para a vaga de Desenvolvedor iOS (Home Office).

O Aplicativo Minhas Pautas permite que o usuário gerencie suas pautas (abertas e fechadas). O mesmo possui um sistema de login/logout para que o usuário possa ter acesso ao aplicativo e suas funcionalidades.

## Arquitetura
- MVVM

## Ambiente de desenvolvimento
- Xcode 10.1
- Swift 4.2

## Pods utilizados (Dependências)
- pod 'Moya' - Biblioteca de network
- pod 'Firebase/Analytics' - Biblioteca para insights do Firebase (Obrigatório para o uso do Auth)
- pod 'Firebase/Auth' - Biblioteca de autenticação do Firebase

## Backend
- Google Cloud
- MySQL 5.7
- NodeJS (APIs)

## Informações Adicionais
O sistema de login foi desenvolvido utilizando Firebase para o aproveitamento de diversas funcionalidades úteis para o usuário, como: Criação segura de novos logins; Recuperação de senha; Conferência de e-mail já existente; etc.

As senhas utilizadas no cadastro não são salvas no banco de dados, sendo assim gerenciadas pelo Firebase.
