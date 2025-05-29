IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Exam_Type_Master]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE Procedure [dbo].[Sp_Exam_Type_Master]
@flag bigint=0,
@id bigint=0,
@active bigint =0,
@name varchar(30)=''''
as
begin
if(@flag=0)
begin
select * from Tbl_Exam_Type where Exam_Type_DelStatus=0
end
if(@flag=1)
begin
update Tbl_Exam_Type set Active=@active where Exam_Type_Id=@id
select * from Tbl_Exam_Type where Exam_Type_Id=@id

end
if(@flag=2)
begin
select Count(*) as count,Exam_Type_Id from Tbl_Exam_Type where Exam_Type_Name=@name and Exam_Type_DelStatus=0 group by Exam_Type_Id
end
if(@flag=3)
begin
insert into Tbl_Exam_Type values(@name,null,null,0,0)
select SCOPE_IDENTITY();
end
if(@flag=4)
begin
select * from  Tbl_Exam_Type where Exam_Type_Id=@id
end
if(@flag=5)
begin

update Tbl_Exam_Type set Exam_Type_Name=@name where Exam_Type_Id=@id
select * from  Tbl_Exam_Type where Exam_Type_Id=@id


end
if(@flag=6)
begin
SELECT 
    CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM Tbl_Exam_Master 
            WHERE Exam_Type = @id 
              AND (Result_PublishStatus = 0 OR Result_PublishStatus IS NULL)
        ) 
        THEN 1 
        ELSE 0 
    END AS isused;
end
if(@flag=7)
begin
update Tbl_Exam_Type set Exam_Type_DelStatus=1 where Exam_Type_Id=@id
select * from  Tbl_Exam_Type where Exam_Type_Id=@id

end
end
    ')
END;
