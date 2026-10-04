# G02 - MovieNight

**Equipa:**
* 109222 - Gustavo Giao - gustavogiao@ua.pt
* 118313 - Solomiia Koba - solomiia.koba@ua.pt

## Contexto da Aplicacao

O MovieNight e uma aplicacao movel pensada para grupos de amigos que se reunem fisicamente (em casa, num cafe, numa sala) e precisam de decidir, em conjunto e de forma rapida, qual filme ver. Em vez do processo habitual de discussao informal ou votacao num grupo de chat, a app estrutura a decisao como uma sessao interativa e colaborativa entre multiplos dispositivos presentes no mesmo espaco fisico, sem depender de um backend online dedicado.

*Ler em [Ingles](README.md).*

---

## Proposito da Aplicacao

* Permitir que um organizador crie uma sessao de votacao definindo preferencias (generos, ano, duracao, plataformas de streaming disponiveis).
* Obter sugestoes de filmes atraves de uma API externa (TMDB), armazenando os dados localmente para permitir continuidade da sessao mesmo sem ligacao a Internet.
* Convidar participantes para a sessao atraves de um QR code que codifica a configuracao da sessao, sem necessidade de contas ou credenciais online.
* Detetar automaticamente outros dispositivos proximos via Bluetooth, permitindo a entrada na sessao e a troca de votos sem depender exclusivamente da leitura manual de QR codes.
* Permitir votacao independente e gestual (inclinacao do telemovel via acelerometro/giroscopio) em vez de interacao tatil convencional, tornando a experiencia mais fisica e adequada a um contexto social presencial.
* Em caso de empate entre filmes finalistas, resolver o desempate atraves de uma roleta interativa cujo movimento e controlado pela rotacao fisica do telemovel (giroscopio), tornando o desfecho visivel e participado por todo o grupo.
* Revelar o filme vencedor atraves de um momento de Realidade Aumentada: o poster do filme e ancorado a uma superficie real (ex. a mesa) atraves da camara do dispositivo, criando um momento de destaque visual no final da sessao.
* Garantir que toda a logica de votacao, agregacao de resultados e persistencia de dados funciona de forma totalmente decoupled - sem exigir ligacao constante a Internet nem qualquer backend proprio.

---

## Sensores e Funcionalidades Mobile

* **Camara / QR Code:** leitura da configuracao da sessao e, opcionalmente, ancoragem do poster em AR.
* **Acelerometro / Giroscopio:** votacao gestual (inclinar o telemovel) e controlo da roleta de desempate.
* **Bluetooth (BLE):** detecao de proximidade entre dispositivos do grupo e troca de dados de sessao/votos sem servidor central.
* **Realidade Aumentada (ARCore/ARKit):** revelacao do filme vencedor como objeto ancorado a uma superficie fisica real.
* **Connectivity-aware:** detecao do estado online/offline, adaptando o comportamento da app (uso de dados em cache quando offline).

---

## Sistemas Externos

* **API externa de filmes (TMDB):** pesquisa e metadados dos filmes sugeridos (poster, sinopse, rating, genero, ano). Nao requer autenticacao de utilizador nem credenciais pessoais, cumprindo o requisito de evitar dependencias de login (Google/Facebook).

---

## Arquitetura

O projeto foi desenvolvido em **Flutter** seguindo a **Clean Architecture** orientada por funcionalidades (**Feature-First**).

### Camadas da Arquitetura
* **Domain Layer:** Regras de negocio, Entidades, Use Cases e Interfaces de Repositorios.
* **Data Layer:** Fontes de dados (APIs, Base de Dados local), Modelos e Implementacoes de Repositorios.
* **Presentation Layer:** Interface grafica (Paginas, Widgets) e gestao de estado.

### Gestao de Estado & Injecao de Dependencias
* **Riverpod:** Utilizado para uma gestao de estado previsivel e injecao de dependencias sem acoplamento.

### Modulos Principais
* **features/session:** Gestao do ciclo de vida da sessao (Criacao, QR Code, Lobby).
* **features/movies:** Integracao com a API do TMDB e armazenamento em cache.
* **features/voting:** Logica de votacao gestual e desempate.
* **features/settings:** Definicoes da app (Idioma, Tema Claro/Escuro).
* **core/bluetooth:** Infraestrutura base para comunicacao P2P via Bluetooth Low Energy (BLE).

---

## Desafio Principal

Do nosso ponto de vista, o principal desafio do projeto e duplo. 

Por um lado, tecnicamente, implementar Realidade Aumentada de forma fiavel no tempo disponivel - a detecao de plano e a ancoragem de objetos em Flutter dependem fortemente do dispositivo e do estado do ecossistema de pacotes AR, pelo que planeamos validar esta funcionalidade o mais cedo possivel no semestre, com uma versao de contingencia mais simples (sobreposicao sobre o feed da camara, sem ancoragem espacial) caso a solucao completa nao seja estavel a tempo. 

Por outro lado, o desafio de fundo do projeto e de equilibrio: combinar varias features tecnicamente ambiciosas (AR, Bluetooth, sensores de movimento) sem comprometer a robustez e a simplicidade da experiencia central. Escolher um filme em grupo continua a ser o objetivo, e todas as funcionalidades avancadas devem reforcar essa experiencia em vez de a complicar.

---

## Avaliacao do Projeto (Requisitos)

A tabela seguinte detalha como o projeto MovieNight cumpre os criterios de avaliacao e os requisitos tecnicos da disciplina.

| Requisito                           | Valor | Estrategia de Cumprimento                                                                                                                                                                                                                    |
|:------------------------------------|:-----:|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **4 mandatory elements**            |   2   | Incorporamos multiplos elementos mobile obrigatorios: Comunicacao P2P via Bluetooth, Camara/QR Code, Sensores de Hardware (Acelerometro/Giroscopio) e Realidade Aumentada.                                                                   |
| **Milestone 1 - storyboard**        |   2   | A interface (UI) e o fluxo de navegacao da app ja estao estruturados em Flutter e podem ser executados como uma aplicacao standalone em dispositivos fisicos, sem depender de emuladores.                                                    |
| **Milestone 2 - 2 features**        |   2   | Conseguimos demonstrar a captura de dados do Acelerometro/Giroscopio (para a votacao/roleta) e a leitura e descodificacao de QR Codes nativamente num dispositivo fisico.                                                                    |
| **Milestone 3 - Demo & doc.**       |   8   | A solucao final integrara todas as funcionalidades para resolver o problema proposto (escolha de filmes em grupo), com documentacao completa detalhando a arquitetura Clean Architecture.                                                    |
| **Using advanced state management** |   2   | Utilizamos o **Riverpod** para uma gestao de estado reativa e robusta, bem como para injecao de dependencias em toda a aplicacao.                                                                                                            |
| **Support decoupled scenario**      |   1   | A app e estritamente **Offline-First**. Nao usamos Firebase. Os dispositivos comunicam peer-to-peer via Bluetooth, o que significa que a sessao funciona de forma totalmente desacoplada e offline.                                          |
| **Data management solution**        |   1   | Usamos uma Clean Architecture (Feature-First) com Repositorios e Data Sources dedicados. A persistencia e feita localmente (SharedPreferences e bases de dados locais como Isar/SQLite), dispensando sincronizacao na Cloud (ex: Firestore). |
| **External sources/sensors**        |   2   | Utilizamos a **API do TMDB** como fonte externa de metadados de filmes. Adicionalmente, usamos extensivamente os **sensores do dispositivo** (Acelerometro, Giroscopio, Camara) para as mecanicas centrais da app.                           |
