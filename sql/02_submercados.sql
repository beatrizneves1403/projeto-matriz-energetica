use matriz_energetica;

drop table if exists submercados;

create table submercados(
	uf char(2) primary key,
    submercado varchar(20) not null
);


-- fonte: ons. roraima interligado ao sin em 2026, assumido no norte (confirmar no ons)
insert into submercados(uf, submercado) values
	('SP', 'Sudeste/CO'), ('RJ', 'Sudeste/CO'), ('MG', 'Sudeste/CO'), 
	('ES', 'Sudeste/CO'), ('GO', 'Sudeste/CO'), ('DF', 'Sudeste/CO'), 
    ('MT', 'Sudeste/CO'), ('MS', 'Sudeste/CO'),  
    ('AC', 'Sudeste/CO'), ('RO', 'Sudeste/CO'), ('PR', 'Sul'), 
    ('SC', 'Sul'), ('RS', 'Sul'),  ('BA', 'Nordeste'), ('AL', 'Nordeste'), 
    ('CE', 'Nordeste'), ('PB', 'Nordeste'),  ('RN', 'Nordeste'), ('PI', 'Nordeste'), 
    ('PE', 'Nordeste'), ('SE', 'Nordeste'), ('RR', 'Norte'),
    ('PA', 'Norte'),('TO', 'Norte'), ('MA', 'Norte'), ('AM', 'Norte'), ('AP', 'Norte');
    
    