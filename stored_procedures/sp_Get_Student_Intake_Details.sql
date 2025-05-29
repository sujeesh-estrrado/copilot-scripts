IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_Student_Intake_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE  procedure [dbo].[sp_Get_Student_Intake_Details]         
(@User_Id bigint)          
as          
Begin 
select 
cd.Duration_Period_Id as Batch_Id
from Tbl_Candidate_Personal_Det C
inner JOIN dbo.tbl_New_Admission AS A ON C.New_Admission_Id = A.New_Admission_Id 
inner join  dbo.Tbl_Course_Duration_PeriodDetails AS cd on cd.batch_id=a.batch_id  
where C.Candidate_Id=@User_Id

end
 ');
END;
