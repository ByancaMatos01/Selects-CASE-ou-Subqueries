use projeto

create database projeto 
use projeto  
GO
create table Projects(
id                int          not null   identity (10001,1),
nome              varchar(45)  not null,
descricao         varchar(45),
Datas              date               check (Datas >='2014-09-01')
primary key (id)
)
GO
create table users(
id                 int             not null                           identity (1,1),
nome               varchar(45)     not null                                               ,
username           varchar(45)     not null                           unique,
passwords          varchar(45)     not null                           default('123mudar'),
email              varchar(45)     not null
primary key (id),

)
GO
create table user_has_projects(
id_users           int             not null,
id_projects        int             not null
FOREIGN KEY(id_users) references users(id),
FOREIGN KEY(id_projects) references projects(id)
)
GO

ALTER TABLE users
DROP CONSTRAINT UQ__users__F3DBC5722B531E67;

ALTER TABLE users
ALTER COLUMN username VARCHAR(10) NOT NULL;

ALTER TABLE users
ALTER COLUMN passwords VARCHAR(08) NOT NULL

INSERT INTO users(nome,username,email)
VALUES('Maria', 'RH_maria','maria@empresa.com')

INSERT INTO users(nome,username,passwords, email)
VALUES('Paulo', 'TI_PAULO','123@456','paulo@empresa.com')
go
INSERT INTO users(nome,username,email)
VALUES('Ana', 'RH_ana','ana@empresa.com')
go
INSERT INTO users(nome,username,email)
VALUES('Clara', 'TI_clara','clara@empresa.com')
go
INSERT INTO users(nome,username,passwords, email)
VALUES('Aparecido', 'RH_apareci','55@!cido','aparecido@empresa.com')

ALTER TABLE Projects
DROP CONSTRAINT CK__Projects__Datas__36B12243;
ALTER TABLE Projects
ADD CHECK (Datas >= '2014-09-05');

INSERT INTO Projects(nome,descricao,Datas)
VALUES('RE-folha', 'Refatoração das folhas','2014-09-05')

INSERT INTO Projects(nome,descricao,Datas)
VALUES('Manutençao PC´S', 'Manutenção de PC´S','2014-09-06')
go

INSERT INTO Projects(nome,Datas)
VALUES('Auditória','2014-09-07')
go

INSERT INTO user_has_projects(id_users,id_projects)
VALUES(1,10001)
go
INSERT INTO user_has_projects(id_users,id_projects)
VALUES(5,10001)
go
INSERT INTO user_has_projects(id_users,id_projects)
VALUES(3,10003)
go
INSERT INTO user_has_projects(id_users,id_projects)
VALUES(4,10002)
go
INSERT INTO user_has_projects(id_users,id_projects)
VALUES(2,10002)

go

select* from users
EXEC sp_help users

Update Projects
set Datas='2014-09-12'
where nome LIKE 'Manutençao%'

UPDATE users
set username= 'RH_cido'
where nome like 'Aparecido'

Update users
set passwords= '888@*'
where nome like 'Maria' and username='RH_maria' and passwords='123mudar'

DELETE user_has_projects WHERE id_users = 2 AND id_projects = 10002

select*from Projects
select*from users
select*from user_has_projects


---Fazer uma consulta que retorne id, nome, email, username e caso a senha seja diferente de
--123mudar, mostrar ******** (8 asteriscos), caso contrário, mostrar a própria senha.
SELECT 
    id,
    nome,
    email,
    username,
    CASE
        WHEN passwords != '123mudar' THEN '********'
        ELSE passwords
    END AS Senha
FROM users;

--Considerando que o projeto 10001 durou 15 dias, fazer uma consulta que mostre o nome do
--projeto, descrição, data, data_final do projeto realizado por usuário de e-mail
---aparecido@empresa.com

SELECT
    nome AS Nome_Projeto,
    descricao AS Descricao_Projeto,
	CONVERT(CHAR(10), Datas, 103) AS Data_Inicio,
    CONVERT(CHAR(10), DATEADD(DAY, 15, Datas), 103) AS nova_data_fim	
FROM projects 
WHERE id = 10001 
AND id IN
 (
    SELECT id_projects 
    FROM user_has_projects
    WHERE id_users  IN
    (
        SELECT id
        FROM users
        WHERE email = 'aparecido@empresa.com'
    )
);

--- Fazer uma consulta que retorne o nome e o email dos usuários que estão envolvidos no
---projeto de nome Auditoria
SELECT u.nome, u.email
FROM users u
JOIN user_has_projects up ON u.id = up.id_users
JOIN projects p ON up.id_projects = p.id
WHERE p.nome = 'Auditória';

---Considerando que o custo diário do projeto, cujo nome tem o termo Manutenção, é de 79.85
---e ele deve finalizar 16/09/2014, consultar, nome, descrição, data, data_final e custo_total do
--projeto

SELECT nome, descricao, Datas as data_inicio, '2014-09-16' as data_final,
       DATEDIFF(day, Datas, '2014-09-16') * 79.85 as custo_total
FROM projects
WHERE nome LIKE '%Manutenção%';
