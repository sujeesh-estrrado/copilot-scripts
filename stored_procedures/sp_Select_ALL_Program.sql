IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Select_ALL_Program]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_Select_ALL_Program] --1,2
(
@flag bigint=0,
@IntakeID  bigint=0
)
as
begin
if(@flag=0)
begin
select Department_Id,Department_Name,Course_Code,CONCAT(Course_Code,''-'',Department_Name) as pgmcode,Intro_Date
from tbl_department D where D.Delete_Status=0 and D.Department_Status=0 order by Course_Code;
end
if(@flag=1)
begin
select distinct Department_Id,Department_Name,Course_Code,
CONCAT(Department_Name,''-'',Course_Code) as pgmcode from tbl_department D
inner join Tbl_Course_Batch_Duration BD on BD.Duration_Id=D.Department_Id
inner join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterID
where BD.Batch_Id=@IntakeID and BD.Batch_DelStatus=0 and D.Delete_Status=0 and D.Department_Status=0
end
end
');
END;