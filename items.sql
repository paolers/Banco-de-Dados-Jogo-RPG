-- - ID do Item.
--   - Para a Lookup Table.
-- - Nome.
-- - Descrição.
-- - Tamanho.
-- - Textura.
-- - Max stack.
-- - Slot-type.
--   - Peitoral.
--   - Bota.
--   - Runa.
--   - Etc.

-- id: string, minusculo, _
-- nome: string
-- descrição: string multilinhas, simbolos especiais
-- tamanho: array/ entrada largura ou altura
-- textura: string
-- max_stack: int
-- slot-type: int ou string

DROP TABLE Item

CREATE TABLE "Item" (
	"ID_item" TEXT UNIQUE,
	"Nome"	TEXT,
	"Descricao"	TEXT,
	"Largura"	INT,
	"Altura"	INT,
	"Textura"	TEXT,
	"Max_stack"	INT,
	"Slot_type"	TEXT,
	PRIMARY KEY("ID_item")
);

INSERT INTO Item (ID_item, Nome, Descricao, Largura, Altura, Textura, Max_stack, Slot_type)
VALUES ('002', 'Armadura de Ferro', 'Armadura de nível baixo', 2, 3, 'res://talpath', 1, 'Peitoral');

INSERT INTO Item (ID_item, Nome, Descricao, Largura, Altura, Textura, Max_stack, Slot_type)
VALUES ('210', 'Espada de Obsidian', 'Arma de nível máximo', 5, 1, 'res://talpath1', 1, 'Arma');

INSERT INTO Item (ID_item, Nome, Descricao, Largura, Altura, Textura, Max_stack, Slot_type)
VALUES ('908', 'Gema mágica', 'Um item muito legal', 2, 2, 'res://runas_e_gemas', 5, 'Runa');

select * from Item