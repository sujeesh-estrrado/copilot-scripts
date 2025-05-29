IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Generate_Challan_Prefix]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_Generate_Challan_Prefix]  
(@Candidate_Id bigint)  
  
as begin  
declare @Course_cat varchar(50),  
@Batch_Code varchar(50)  
  
  
  
set @Course_cat=(select Course_Category_Name from dbo.Tbl_Course_Category CC inner join dbo.Tbl_Student_Registration SR on SR.Course_Category_Id=CC.Course_Category_Id  
where Candidate_Id=@Candidate_Id)  
  
set @Batch_Code=(select Batch_Code from  dbo.Tbl_Course_Batch_Duration CBD inner join  dbo.Tbl_Course_Duration_PeriodDetails CDP   
on CBD.Batch_Id=CDP.Batch_Id inner join dbo.Tbl_Course_Duration_Mapping CDM on CDM.Duration_Period_Id=CDP.Duration_Period_Id  
inner join dbo.Tbl_Student_Semester SS on SS.Duration_Mapping_Id=CDM.Duration_Mapping_Id where  
Candidate_Id=@Candidate_Id and Student_Semester_Current_Status=1)  
  
  
select @Course_cat+''/''+@Batch_Code+''/'' as Prefix  
  
end
    ')
END
