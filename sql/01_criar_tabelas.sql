use matriz_energetica;

drop table if exists usinas;

create table usinas (
    cod_ceg                  varchar(40) primary key,
    nome                     varchar(255),
    uf                       char(2),
    tipo_geracao             char(3),
    fase                     varchar(30),
    fonte                    varchar(20),
    porte                    varchar(10),
    data_operacao            date,
    ano_operacao             smallint,
    potencia_outorgada_mw    decimal(12,5),
    potencia_fiscalizada_mw  decimal(12,5)
);