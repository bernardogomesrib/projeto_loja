

CREATE SCHEMA IF NOT EXISTS loja ;
USE loja ;

CREATE TABLE IF NOT EXISTS loja.cliente (
  cpf CHAR(15) NOT NULL,
  data_nascimento DATE NOT NULL,
  nome VARCHAR(45) NOT NULL,
  sobrenome VARCHAR(45) NOT NULL,
  email TINYTEXT NOT NULL,
  data_cadastro DATE NOT NULL DEFAULT CURRENT_DATE,
  PRIMARY KEY (cpf))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS loja.telefone (
  num CHAR(19) NOT NULL,
  cliente_cpf CHAR(15) NOT NULL,
  PRIMARY KEY (num, cliente_cpf),
  INDEX fk_telefone_cliente1_idx (cliente_cpf ASC),
  CONSTRAINT fk_telefone_cliente1
    FOREIGN KEY (cliente_cpf)
    REFERENCES loja.cliente (cpf)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS loja.endereco (
  id BIGINT NOT NULL AUTO_INCREMENT,
  cep CHAR(10) NOT NULL,
  numero VARCHAR(12) NOT NULL,
  complemento VARCHAR(50) NULL,
  cliente_cpf CHAR(15) NOT NULL,
  PRIMARY KEY (id, cliente_cpf),
  INDEX fk_endereco_cliente1_idx (cliente_cpf ASC),
  CONSTRAINT fk_endereco_cliente1
    FOREIGN KEY (cliente_cpf)
    REFERENCES loja.cliente (cpf)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS loja.status (
  id INT NOT NULL AUTO_INCREMENT,
  status VARCHAR(45) NOT NULL,
  PRIMARY KEY (id))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS loja.produto (
  id BIGINT NOT NULL AUTO_INCREMENT,
  perecivel TINYINT(1) NOT NULL,
  nome VARCHAR(45) NOT NULL,
  descricao TEXT NOT NULL,
  marca VARCHAR(45) NULL,
  status_id INT NOT NULL,
  PRIMARY KEY (id, status_id),
  UNIQUE INDEX idproduto_UNIQUE (id ASC),
  INDEX fk_produto_status1_idx (status_id ASC),
  CONSTRAINT fk_produto_status1
    FOREIGN KEY (status_id)
    REFERENCES loja.status (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS loja.tipo (
  id BIGINT NOT NULL AUTO_INCREMENT,
  quantidade INT NOT NULL,
  descricao VARCHAR(25) NOT NULL,
  tipo_idtipo BIGINT NULL,
  produto_idproduto BIGINT NOT NULL,
  PRIMARY KEY (id, produto_idproduto),
  INDEX fk_tipo_tipo1_idx (tipo_idtipo ASC),
  INDEX fk_tipo_produto1_idx (produto_idproduto ASC),
  CONSTRAINT fk_tipo_tipo1
    FOREIGN KEY (tipo_idtipo)
    REFERENCES loja.tipo (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_tipo_produto1
    FOREIGN KEY (produto_idproduto)
    REFERENCES loja.produto (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS loja.preco (
  id BIGINT NOT NULL AUTO_INCREMENT,
  preco DECIMAL(13,2) NOT NULL,
  tipo_id BIGINT NOT NULL,
  tipo_produto_idproduto BIGINT NULL DEFAULT NULL,
  data DATETIME NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id, tipo_id),
  INDEX fk_preco_tipo1_idx (tipo_id ASC, tipo_produto_idproduto ASC),
  CONSTRAINT fk_preco_tipo1
    FOREIGN KEY (tipo_id , tipo_produto_idproduto)
    REFERENCES loja.tipo (id , produto_idproduto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS loja.data_validade (
  id BIGINT NOT NULL AUTO_INCREMENT,
  data DATE NOT NULL,
  lote VARCHAR(15) NULL,
  produto_id BIGINT NOT NULL,
  data_entrada DATETIME NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id, produto_id),
  INDEX fk_data_validade_produto1_idx (produto_id ASC),
  CONSTRAINT fk_data_validade_produto1
    FOREIGN KEY (produto_id)
    REFERENCES loja.produto (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS loja.fornecedor (
  id BIGINT NOT NULL AUTO_INCREMENT,
  cnpj CHAR(18) NULL,
  cep CHAR(10) NOT NULL,
  numero VARCHAR(12) NOT NULL,
  complemento TINYTEXT NULL,
  telefone CHAR(13) NULL,
  email TINYTEXT NOT NULL,
  nome VARCHAR(45) NOT NULL,
  inscricao_estadual VARCHAR(45) NULL,
  avaliacao VARCHAR(45) NULL,
  politica_troca_devolucao VARCHAR(45) NULL,
  site TINYTEXT NULL,
  data_cadastro DATE NULL DEFAULT CURRENT_DATE,
  PRIMARY KEY (id))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS loja.forma_de_pagamento (
  id INT NOT NULL AUTO_INCREMENT,
  forma VARCHAR(45) NOT NULL,
  tipo VARCHAR(45) NULL,
  desconto DECIMAL(10,5) NOT NULL,
  PRIMARY KEY (id))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS loja.pedido (
  id BIGINT NOT NULL AUTO_INCREMENT,
  cliente_cpf CHAR(15) NOT NULL,
  PRIMARY KEY (id, cliente_cpf),
  INDEX fk_pedido_cliente1_idx (cliente_cpf ASC),
  CONSTRAINT fk_pedido_cliente1
    FOREIGN KEY (cliente_cpf)
    REFERENCES loja.cliente (cpf)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS loja.pedido_tem_produto (
  pedido_id BIGINT NOT NULL,
  quantidade DECIMAL(13,2) NOT NULL,
  preco_id BIGINT NOT NULL,
  preco_tipo_id BIGINT NOT NULL,
  PRIMARY KEY (pedido_id, preco_id, preco_tipo_id),
  INDEX fk_pedido_has_produto_pedido1_idx (pedido_id ASC),
  INDEX fk_pedido_tem_produto_preco1_idx (preco_id ASC, preco_tipo_id ASC),
  CONSTRAINT fk_pedido_has_produto_pedido1
    FOREIGN KEY (pedido_id)
    REFERENCES loja.pedido (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_pedido_tem_produto_preco1
    FOREIGN KEY (preco_id , preco_tipo_id)
    REFERENCES loja.preco (id , tipo_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS loja.venda (
  forma_de_pagamento_id INT NOT NULL,
  data_compra DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status_id INT NOT NULL,
  pedido_id BIGINT NOT NULL,
  pedido_cliente_cpf CHAR(15) NOT NULL,
  PRIMARY KEY (forma_de_pagamento_id, status_id, pedido_id, pedido_cliente_cpf),
  INDEX fk_venda_forma_de_pagamento1_idx (forma_de_pagamento_id ASC),
  INDEX fk_venda_status1_idx (status_id ASC),
  INDEX fk_venda_pedido1_idx (pedido_id ASC, pedido_cliente_cpf ASC),
  CONSTRAINT fk_venda_forma_de_pagamento1
    FOREIGN KEY (forma_de_pagamento_id)
    REFERENCES loja.forma_de_pagamento (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_venda_status1
    FOREIGN KEY (status_id)
    REFERENCES loja.status (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_venda_pedido1
    FOREIGN KEY (pedido_id , pedido_cliente_cpf)
    REFERENCES loja.pedido (id , cliente_cpf)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS loja.entrega (
  id BIGINT NOT NULL AUTO_INCREMENT,
  venda_pedido_id BIGINT NOT NULL,
  numero_rastreio VARCHAR(45) NULL,
  tipo_de_entrega VARCHAR(45) NULL,
  status_id INT NOT NULL,
  PRIMARY KEY (id, venda_pedido_id, status_id),
  INDEX fk_entrega_status1_idx (status_id ASC),
  CONSTRAINT fk_entrega_status1
    FOREIGN KEY (status_id)
    REFERENCES loja.status (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS loja.fornecedor_tem_forma_de_pagamento (
  forma_de_pagamento_id INT NOT NULL,
  fornecedor_id BIGINT NOT NULL,
  PRIMARY KEY (forma_de_pagamento_id, fornecedor_id),
  INDEX fk_fornecedor_has_forma_de_pagamento_forma_de_pagamento1_idx (forma_de_pagamento_id ASC),
  INDEX fk_fornecedor_tem_forma_de_pagamento_fornecedor1_idx (fornecedor_id ASC),
  CONSTRAINT fk_fornecedor_has_forma_de_pagamento_forma_de_pagamento1
    FOREIGN KEY (forma_de_pagamento_id)
    REFERENCES loja.forma_de_pagamento (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_fornecedor_tem_forma_de_pagamento_fornecedor1
    FOREIGN KEY (fornecedor_id)
    REFERENCES loja.fornecedor (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS loja.fornecedor_fornece_produto (
  produto_id BIGINT NOT NULL,
  data_fornecimento DATE NULL DEFAULT CURRENT_DATE,
  gasto DECIMAL(15,2) NOT NULL,
  quantidade DECIMAL(12,2) NOT NULL,
  fornecedor_id BIGINT NOT NULL,
  PRIMARY KEY (produto_id, fornecedor_id),
  INDEX fk_fornecedor_fornece_produto_produto1_idx (produto_id ASC),
  INDEX fk_fornecedor_fornece_produto_fornecedor1_idx (fornecedor_id ASC),
  CONSTRAINT fk_fornecedor_fornece_produto_produto1
    FOREIGN KEY (produto_id)
    REFERENCES loja.produto (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_fornecedor_fornece_produto_fornecedor1
    FOREIGN KEY (fornecedor_id)
    REFERENCES loja.fornecedor (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS loja.categoria (
  id INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(45) NOT NULL,
  descricao TINYTEXT NULL,
  PRIMARY KEY (id))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS loja.produto_has_categoria (
  produto_id BIGINT NOT NULL,
  categoria_id INT NOT NULL,
  PRIMARY KEY (produto_id, categoria_id),
  INDEX fk_produto_has_categoria_categoria1_idx (categoria_id ASC),
  INDEX fk_produto_has_categoria_produto1_idx (produto_id ASC),
  CONSTRAINT fk_produto_has_categoria_produto1
    FOREIGN KEY (produto_id)
    REFERENCES loja.produto (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_produto_has_categoria_categoria1
    FOREIGN KEY (categoria_id)
    REFERENCES loja.categoria (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS loja.fluxo_de_caixa (
  cod BIGINT NOT NULL AUTO_INCREMENT,
  data DATE NOT NULL DEFAULT DATE_ADD(CURDATE(), INTERVAL 1 DAY),
  lucro_dinheiro DECIMAL(10,2) NOT NULL DEFAULT 0,
  lucro_cartao DECIMAL(10,2) NOT NULL DEFAULT 0,
  gasto_com_fornecedor DECIMAL(10,2) NOT NULL DEFAULT 0,
  investimento_interno DECIMAL(10,2) NOT NULL DEFAULT 0,
  gasto_com_salario DECIMAL(10,2) NOT NULL DEFAULT 0,
  prolabore DECIMAL(10,2) NOT NULL DEFAULT 0,
  saldo_do_dia DECIMAL(10,2) NOT NULL DEFAULT 0,
  PRIMARY KEY (cod),
  UNIQUE INDEX data_UNIQUE (data ASC))
ENGINE = InnoDB;

USE loja;

DELIMITER $$
USE loja$$
CREATE DEFINER = CURRENT_USER TRIGGER loja.venda_BEFORE_INSERT BEFORE INSERT ON venda FOR EACH ROW
BEGIN
  set @lucro = sum((select preco.preco * pedido_tem_produto.quantidade from pedido_tem_produto join preco on pedido_tem_produto.preco_id = preco.id where pedido_tem_produto.pedido_id = new.venda.pedido_id));
END$$


DELIMITER ;



INSERT INTO status (id, status) VALUES
(1, 'indisponivel'),
(2, 'disponível'),
(3, 'indisponivel'),
(4, 'disponível');



INSERT INTO produto (id, perecivel, nome, descricao, marca, status_id) VALUES
(1, 0, 'produto', 'um produto', 'manufaturado', 2),
(2, 0, 'produto 2', 'produto 2', 'produ', 1),
(3, 0, 'produto', 'um produto', 'manufaturado', 2),
(4, 0, 'produto 2', 'produto 2', 'produ', 1);

INSERT INTO tipo (id, quantidade, descricao, tipo_idtipo, produto_idproduto) VALUES
(1, 10, 'masculino', NULL, 1),
(2, 10, 'feminino', NULL, 1);
