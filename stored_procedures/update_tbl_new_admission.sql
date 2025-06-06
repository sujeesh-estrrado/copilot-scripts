IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[update_tbl_new_admission]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       
CREATE procedure [dbo].[update_tbl_new_admission]  
@Duration_Mapping_Id bigint,  
@Candidate_Id bigint  
as  
begin  
declare @admission_id bigint  
declare @batch_id bigint  
  
set @batch_id=(select b.Batch_Id from  dbo.Tbl_Course_Duration_Mapping a  
inner join  dbo.Tbl_Course_Duration_PeriodDetails  b on a.Duration_Period_Id=b.Duration_Period_Id  
inner join dbo.Tbl_Course_Batch_Duration c on c.Batch_Id=b.Batch_Id    
where Duration_Mapping_Id=@Duration_Mapping_Id)  
  
set @admission_id=(select New_Admission_Id from dbo.Tbl_Candidate_Personal_Det where Candidate_Id=@Candidate_Id)  
  
UPDATE tbl_New_Admission SET Batch_Id=@batch_id where New_Admission_Id=@admission_id   
  
end
    ')
END;
