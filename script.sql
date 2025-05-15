/* Questão 01. Crie um procedimento chamado student_grade_points segundo os critérios abaixo:

a. Utilize como parâmetro de entrada o conceito. Exemplo: A+, A-, ...

b. Retorne os atributos das tuplas: Nome do estudante, Departamento do estudante, Título do curso, Departamento do curso, Semestre do curso, Ano do curso, Pontuação alfanumérica, Pontuação numérica.

c. Filtre as tuplas utilizando o parâmetro de entrada. */

CREATE PROCEDURE student_grade_points
    @grade CHAR(2) 
AS
BEGIN
    SELECT 
        s.name AS Nome_Estudante,
        s.dept_name AS Departamento_Estudante,
        c.title AS Titulo_Curso,
        c.dept_name AS Departamento_Curso,
        t.semester AS Semestre_Curso,
        t.year AS Ano_Curso,
        t.grade AS Pontuacao_Alfabetica,
        CASE 
            WHEN t.grade = 'A+' THEN 4.3
            WHEN t.grade = 'A'  THEN 4.0
            WHEN t.grade = 'A-' THEN 3.7
            WHEN t.grade = 'B+' THEN 3.3
            WHEN t.grade = 'B'  THEN 3.0
            WHEN t.grade = 'B-' THEN 2.7
            WHEN t.grade = 'C+' THEN 2.3
            WHEN t.grade = 'C'  THEN 2.0
            WHEN t.grade = 'C-' THEN 1.7
            WHEN t.grade = 'D'  THEN 1.0
            WHEN t.grade = 'F'  THEN 0.0
            ELSE NULL
        END AS Pontuacao_Numerica
    FROM 
        takes t
    JOIN 
        student s ON t.ID = s.ID
    JOIN 
        course c ON t.course_id = c.course_id
    WHERE 
        t.grade = @grade;
END;



/* Questão 02.

Crie uma função chamada return_instructor_location segundo os critérios abaixo:

a. Utilize como parâmetro de entrada o nome do instrutor.

b. Retorne os atributos das tuplas: Nome do instrutor, Curso ministrado, Semestre do curso, Ano do curso, prédio e número da sala na qual o curso foi ministrado

c. Exemplo: SELECT * FROM dbo.return_instructor_location('Gustafsson'); */

CREATE FUNCTION return_instructor_location (
    @instr_name VARCHAR(50)
)
RETURNS TABLE
AS
RETURN (
    SELECT 
        i.name AS Nome_Instrutor,
        c.title AS Curso_Ministrado,
        t.semester AS Semestre_Curso,
        t.year AS Ano_Curso,
        r.building AS Predio,
        r.room_number AS Numero_Sala
    FROM 
        instructor i
    JOIN 
        teaches t ON i.ID = t.ID
    JOIN 
        course c ON t.course_id = c.course_id
    JOIN 
        section s ON t.course_id = s.course_id AND t.sec_id = s.sec_id AND t.semester = s.semester AND t.year = s.year
    JOIN 
        classroom r ON s.building = r.building AND s.room_number = r.room_number
    WHERE 
        i.name = @instr_name
);
