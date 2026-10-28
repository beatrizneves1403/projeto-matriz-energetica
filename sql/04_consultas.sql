use matriz_energetica;

-- Consulta 1: capacidade instalada por fonte (mw)
select fonte,
	count(*) as usinas,
    round(sum(potencia_fiscalizada_mw),1) as potencia_mw
from usinas
where fase = 'Operação'
group by fonte
order by potencia_mw desc;

-- Consulta 2: capacidade instalada por submercado
select s.submercado,
	count(*) as usinas,
	round(sum(u.potencia_fiscalizada_mw),1) as potencia_mw
from usinas u
join submercados s on s.uf = u.uf
where u.fase = 'Operação'
group by submercado
order by potencia_mw desc;

-- Consulta 3: potência por submercado e fonte
select s.submercado, u.fonte, 
		round(sum(u.potencia_fiscalizada_mw),1) as potencia_mw
from usinas u
join submercados s on s.uf = u.uf
where u.fase = 'Operação'
group by s.submercado, fonte
order by s.submercado, potencia_mw desc;

-- Consulta 4a: potência que entrou em operação por ano
select ano_operacao, round(sum(potencia_fiscalizada_mw),1) as potencia_mw
from usinas 
where fase = 'Operação'
	and ano_operacao is not null
group by ano_operacao
order by ano_operacao; 

-- Consulta 4b: potência que entrou em operação por ano (Solar)
select ano_operacao, round(sum(potencia_fiscalizada_mw),1) as potencia_mw
from usinas 
where fase = 'Operação'
	and ano_operacao is not null 
    and  fonte = 'Solar'
group by ano_operacao
order by ano_operacao; 

-- Consulta 4c: potência que entrou em operação por ano e fonte 
select ano_operacao, fonte, round(sum(potencia_fiscalizada_mw),1) as potencia_mw
from usinas
where fase = 'Operação'
	and ano_operacao is not null,
	and fonte in ('Hídrica', 'Eólica', 'Solar')
group by ano_operacao, fonte
order by ano_operacao;


-- Consulta 5a: top 5 estados em potência hídrica
select uf, round(sum(potencia_fiscalizada_mw),1) as potencia_mw
from usinas
where fase = 'Operação' and fonte = 'Hídrica'
group by uf
order by potencia_mw desc
limit 5;

-- Consulta 5b: top 5 estados em potência solar
select uf, round(sum(potencia_fiscalizada_mw),1) as potencia_mw
from usinas
where fase = 'Operação' and fonte = 'Solar'
group by uf
order by potencia_mw desc
limit 5;

-- Conferência: usinas em operação sem ano informado
select count(*) as usinas, round(sum(potencia_fiscalizada_mw),1) as potencia_mw
from usinas
where fase = 'Operação' and ano_operacao is null;

-- Conferência: maiores usinas que entraram em operação em 2016
select nome, uf, round(potencia_fiscalizada_mw,1) as potencia_mw
from usinas
where ano_operacao = 2016
order by potencia_fiscalizada_mw desc
limit 3;

-- Consulta 6: projetos em construção por submercado e fonte
select s.submercado, u.fonte, count(*) as projetos, 
	round(sum(u.potencia_outorgada_mw), 1) AS potencia_mw
from usinas u
join submercados s on s.uf = u.uf
where u.fase != 'Operação'
group by s.submercado, u.fonte
order by potencia_mw desc;


