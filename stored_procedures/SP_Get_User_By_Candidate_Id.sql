IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_User_By_Candidate_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_User_By_Candidate_Id] --20034

(
@flag bigint=0,
@User_Id bigint
)
as 

begin
if(@flag=0)
begin
Select * from dbo.Tbl_Student_User where User_Id=@User_Id
end
if(@flag=1)
begin
Select * from dbo.Tbl_Student_User where Candidate_Id=@User_Id
end
end
    ')
END
