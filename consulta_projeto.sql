-- O PREÇO DOS PRODUTOS INFLUENCIAM NO VOLUME DE VENDAS? MAIS BARATO>VOLUME?
create view volume_venda_preço as(
select
    p."Produto",
	v."Codigo",
	p."Preco",
	sum(v."Qty") as quantidade_vendida
from vendas v
inner join produtos p
	on v."Codigo" = p."Codigo" 
group by p."Produto", v."Codigo", p."Preco"
order by quantidade_vendida desc)

-- QUAL A FAIXA DE PREÇO DOS PRODUTOS COM STATUS DE ENTREGA CANCELADO? HÁ RELAÇÃO COM OS VALORES (PREÇO) MAIS ALTOS?
create view cancelamento_por_preço as(
select
    p."Produto",
	v."Codigo",
	p."Preco",
	v."Courier Status",
	sum(v."Qty") as quantidade_cancelada
from vendas v
inner join produtos p
	on v."Codigo" = p."Codigo" 
where v."Courier Status" = 'Cancelled'	
group by p."Produto", v."Codigo", v."Courier Status", p."Preco"
order by quantidade_cancelada desc)

-- QUAL A FAIXA DE PREÇO DOS PRODUTOS COM STATUS DE ENTREGA ENVIADO? HÁ RELAÇÃO COM OS VALORES (PREÇO) MAIS ALTOS?
create view entrega_por_preço as(
select
    p."Produto",
	v."Codigo",
	p."Preco",
	v."Courier Status",
	sum(v."Qty") as quantidade_entregue
from vendas v
inner join produtos p
	on v."Codigo" = p."Codigo" 
where v."Courier Status" = 'Shipped'	
group by p."Produto", v."Codigo", v."Courier Status", p."Preco"
order by quantidade_entregue desc)

-- QUAL VALOR DE ESTOQUE PARADO DEVIDO A CANCELAMENTOS?
create view estoque_cancelamento as(
select
    p."Produto",
	v."Codigo",
	round(sum(cast(substring(p."Preco",2,10) as numeric)),0) as valor_cancelamento,
	v."Courier Status"
from vendas v
inner join produtos p
	on v."Codigo" = p."Codigo" 
where v."Courier Status" = 'Cancelled'
group by p."Produto", v."Codigo", v."Courier Status", p."Preco"
order by valor_cancelamento desc)

-- ARRECADADO POR VENDAS CONCLUÍDAS
create view arrecadado_vendas as(
select
    p."Produto",
	v."Codigo",
	round(sum(cast(substring(p."Preco",2,10) as numeric)),0) as valor_entrega,
	v."Courier Status"
from vendas v
inner join produtos p
	on v."Codigo" = p."Codigo" 
where v."Courier Status" = 'Shipped'
group by p."Produto", v."Codigo", v."Courier Status", p."Preco"
order by valor_entrega desc)
