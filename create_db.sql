-- >> CRIAÇÃO DAS TABELAS INICIAIS; ALGUMAS CONFIGS FORAM MODIFICADAS DENTRO DO DBBROWSER

CREATE TABLE "Entidade" (
	"id"	INTEGER NOT NULL UNIQUE,
	"tipo"	INTEGER NOT NULL,
	"cena"	VARCHAR(30),
	"posicao"	VARCHAR(30),
	"andar"	VARCHAR(20),
	"mundo"	VARCHAR(30),
	"vida_atual"	REAL,
	PRIMARY KEY("id" AUTOINCREMENT)
);

-- Tabela Criatura (chave primária corrigida)
CREATE TABLE Criatura (
    id INTEGER PRIMARY KEY, -- Sem AUTOINCREMENT aqui! Herda o ID de Entidade
    personalidade INTEGER, -- Chave estrangeira para Personalidade
    memoria INTEGER,      -- Chave estrangeira para Memoria
    FOREIGN KEY (id) REFERENCES Entidade(id) ON DELETE CASCADE,
    FOREIGN KEY (memoria) REFERENCES Memoria(id) ON DELETE CASCADE,
    FOREIGN KEY (personalidade) REFERENCES Personalidade(id) ON DELETE CASCADE
);

-- Tabela Personagem (chave primária corrigida)
CREATE TABLE Personagem (
    id INTEGER PRIMARY KEY, -- Sem AUTOINCREMENT aqui! Herda o ID de Entidade
    nome VARCHAR(20),
    ouro INTEGER,
    xp REAL,
    mana_atual INTEGER,
    inventario INTEGER UNIQUE, -- Chave estrangeira para Inventario
    FOREIGN KEY (id) REFERENCES Entidade(id) ON DELETE CASCADE,
    FOREIGN KEY (inventario) REFERENCES Inventario(id) ON DELETE CASCADE
);

-- As tabelas Criatura e Personagem não devem ter AUTOINCREMENT em seus IDs. 
-- Elas herdam o id da tabela Entidade. Isso cria uma relação 1-para-1, onde cada Criatura ou Personagem corresponde a uma única Entidade.

CREATE TABLE "Personalidade" (
	"id"	INTEGER NOT NULL UNIQUE,
	"slot"	REAL DEFAULT 0.0,
	"slot_2"	REAL DEFAULT 0.0,
	"slot_3"	REAL DEFAULT 0.0,
	"slot_4"	REAL DEFAULT 0.0,
	"slot_5"	REAL DEFAULT 0.0,
	"slot_6"	REAL DEFAULT 0.0,
	"slot_7"	REAL DEFAULT 0.0,
	"slot_8"	REAL DEFAULT 0.0,
	"slot_9"	REAL DEFAULT 0.0,
	"slot_10"	REAL DEFAULT 0.0,
	"slot_11"	REAL DEFAULT 0.0,
	"slot_12"	REAL DEFAULT 0.0,
	"slot_13"	REAL DEFAULT 0.0,
	"slot_14"	REAL DEFAULT 0.0,
	"slot_15"	REAL DEFAULT 0.0,
	"slot_16"	REAL DEFAULT 0.0,
	"slot_17"	REAL DEFAULT 0.0,
	"slot_18"	REAL DEFAULT 0.0,
	"slot_19"	REAL DEFAULT 0.0,
	"slot_20"	REAL DEFAULT 0.0,
	"slot_21"	REAL DEFAULT 0.0,
	"slot_22"	REAL DEFAULT 0.0,
	"slot_23"	REAL DEFAULT 0.0,
	"slot_24"	REAL DEFAULT 0.0,
	"slot_25"	REAL DEFAULT 0.0,
	"slot_26"	REAL DEFAULT 0.0,
	"slot_27"	REAL DEFAULT 0.0,
	"slot_28"	REAL DEFAULT 0.0,
	"slot_29"	REAL DEFAULT 0.0,
	"slot_30"	REAL DEFAULT 0.0,
	"slot_31"	REAL DEFAULT 0.0,
	"slot_32"	REAL DEFAULT 0.0,
	PRIMARY KEY("id" AUTOINCREMENT)
);

CREATE TABLE "Memoria" (
	"id"	INTEGER NOT NULL UNIQUE,
	"alvos"	INT,
	PRIMARY KEY("id" AUTOINCREMENT)
);


CREATE TABLE "Inventario" (
	"id"	INTEGER NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
);

-- não vai ser criada automaticamente
CREATE TABLE "Entrada_no_Inventario" (
	"id"	VARCHAR(20),
	"id_inventario"	VARCHAR(20),
	"id_item"	VARCHAR(20),
	"posicao"	VARCHAR(20),
	"quantidade"	INT,
	PRIMARY KEY("id"),
	FOREIGN KEY("id_inventario") REFERENCES "Inventario"("id") ON DELETE CASCADE
);

-- <<

-- >> CRIAÇÃO DO TRIGGER PARA GARANTIR QUE UM INVENTARIO SEJA CRIADO AUTOMATICAMENTE JUNTO COM A CRIAÇÃO DE UM PERSONAGEM

CREATE TRIGGER criar_inventario_automatico
AFTER INSERT ON Personagem
BEGIN
  -- Cria um novo inventário
  INSERT INTO Inventario (id) VALUES (NULL);

  -- Atualiza o campo 'inventario' do personagem com o ID do inventário recém-criado
  UPDATE Personagem
  SET inventario = (SELECT id FROM Inventario ORDER BY id DESC LIMIT 1)
  WHERE id = NEW.id;
END;

-- <<

-- >> CRIAÇÃO DA TABELA ALVOS

CREATE TABLE Alvos (
    id INTEGER PRIMARY KEY AUTOINCREMENT
);

CREATE TABLE Alvo (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_alvos INTEGER,
    nome_entidade VARCHAR(20),
    is_visivel INT,
    ultimo_local_visto VARCHAR(20),
    reputacao REAL,
    FOREIGN KEY (id_alvos) REFERENCES Alvos(id) ON DELETE CASCADE
);

-- <<

-- >> CRIAÇÃO DO TRIGGER PARA PERSONALIDADE QUE ALVO SEJA CRIADO AO CRIAR UMA CRIATURA

CREATE TRIGGER criar_personalidade_automatico
AFTER INSERT ON Criatura
BEGIN
  -- Cria um novo inventário
  INSERT INTO Personalidade (id) VALUES (NULL);

  -- Atualiza o campo 'inventario' do personagem com o ID do inventário recém-criado
  UPDATE Criatura
  SET personalidade = (SELECT id FROM Personalidade ORDER BY id DESC LIMIT 1)
  WHERE id = NEW.id;
END;

-- <<

-- Gatilho para criar Personagem ou Criatura
CREATE TRIGGER criar_entidade
AFTER INSERT ON Entidade
BEGIN
    -- Criar Personagem se tipo = 1
    INSERT INTO Personagem (id)
    SELECT NEW.id WHERE NEW.tipo = 1;

    -- Criar Criatura se tipo = 2
    INSERT INTO Criatura (id)
    SELECT NEW.id WHERE NEW.tipo = 2;
END;

-- Gatilho para criar Memória e Personalidade ao criar Criatura

CREATE TRIGGER criar_memoria_personalidade
AFTER INSERT ON Criatura
BEGIN
-- Criar entrada em Memória
	INSERT INTO Memoria (id) VALUES (NEW.id);	
-- Criar entrada em Personalidade
	INSERT INTO Personalidade (id) VALUES (NEW.id);	
END;

-- Gatilho para criar Alvo ao criar Memória
CREATE TRIGGER criar_alvos
AFTER INSERT ON Memoria
BEGIN
	-- Criar entrada em Alvo
	INSERT INTO Alvos (id) VALUES (NEW.id);
END;
-- <<

DROP TRIGGER IF EXISTS criar_alvos;
-----------------------------------------------------------

-- << VERIFICAR TRIGGERS

SELECT name 
FROM sqlite_master 
WHERE type = 'trigger';


-- Inserir uma Entidade do tipo Personagem
INSERT INTO Entidade (tipo, cena, posicao, andar, mundo, vida_atual)
VALUES (
    1,                                -- Tipo 1 = Personagem
    'res://caminhotal',             -- Cena
    'x:10,y:20',                      -- Posição em formato texto
    '0',                            -- Andar
    'Mundo Superior',                 -- Mundo
    100                               -- Vida atual
);

INSERT INTO Entidade (tipo, cena, posicao, andar, mundo, vida_atual)
VALUES (
    2,                                -- Tipo 2 = Criatura
    'res://caminho2',                 -- Cena
    'x:15,y:25',                      -- Posição em formato texto
    '1',                              -- Andar
    'Mundo Subterrâneo',              -- Mundo
    80                                -- Vida atual
);

INSERT INTO Entidade (tipo, cena, posicao, andar, mundo, vida_atual)
VALUES (
    2,                                -- Tipo 2 = Outra Criatura
    'res://caminho3',             -- Cena
    'x:17,y:55',                      -- Posição em formato texto
    '3',                            -- Andar
    'Mundo Superior',                 -- Mundo
    60                                -- Vida atual
);
-- <<

DELETE FROM Entidade;

SELECT * FROM Entidade;
SELECT * FROM Personagem;
SELECT * FROM Criatura;
SELECT * FROM Memoria;
SELECT * FROM Personalidade;
SELECT * FROM Alvos;
SELECT * FROM Alvo;

-- >> INSERINDO PERSONAGENS

INSERT INTO Personagem (nome, ouro, xp, mana_atual)
VALUES ('caio', 18, 200, 10);

INSERT INTO Personagem (nome, ouro, xp, mana_atual)
VALUES ('paola', 22, 300, 15);

-- <<

-- >> QUERY QUE VISUALIZA PERSONAGEM E INVENTARIO

SELECT 
    Personagem.id AS personagem_id,
    Personagem.nome AS personagem_nome,
    Personagem.ouro,
    Personagem.xp,
    Personagem.mana_atual,
    Inventario.id AS inventario_id
FROM 
    Personagem
INNER JOIN 
    Inventario
ON 
    Personagem.inventario = Inventario.id;

-- >> COMANDO UTIL PARA VERIFICAÇÃO DE TABELA

PRAGMA table_info(Personagem);

-- <<

PRAGMA foreign_keys = ON;

SELECT name FROM sqlite_master WHERE type='table';
DROP TABLE IF EXISTS table1;
DROP TABLE IF EXISTS table2;

DROP TABLE IF EXISTS Inventario;
DROP TABLE IF EXISTS Memoria;
DROP TABLE IF EXISTS Personalidade;
DROP TABLE IF EXISTS Entidade;
DROP TABLE IF EXISTS Criatura;
DROP TABLE IF EXISTS Personagem;
DROP TABLE IF EXISTS Entrada_no_Inventario;
DROP TABLE IF EXISTS Alvos;
DROP TABLE IF EXISTS Alvo;

-- <<

.schema Alvos

