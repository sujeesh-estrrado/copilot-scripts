IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_StudentBy_RegNo]')
    AND type = N'P'
)
BEGIN
    EXEC('
create procedure [dbo].[SP_Get_StudentBy_RegNo] 
(@RegNo varchar(200))
as
begin 

select  SR.*,CP.Candidate_Fname+'' ''+CP.Candidate_Mname+'' ''+Candidate_Lname as CandidateName,
        CC.Course_Category_Name+''-''+D.Department_Name as Department
from Tbl_Student_Registration SR
inner join Tbl_Candidate_Personal_Det CP on SR.Candidate_Id=CP.Candidate_Id
inner join Tbl_Course_Category CC on CC.Course_Category_Id=SR.Course_Category_Id
inner join Tbl_Department D on D.Department_Id=SR.Department_Id

where SR.Student_Reg_No=@RegNo and SR.Student_Reg_Status=0 and CP.Candidate_DelStatus=0
end
    ')
END;
