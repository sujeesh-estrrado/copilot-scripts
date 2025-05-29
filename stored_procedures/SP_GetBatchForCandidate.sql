IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetBatchForCandidate]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE  procedure [dbo].[SP_GetBatchForCandidate] --30068
(
@CandidateId bigint,
@flag bigint=0
)    
    
as begin    
	if(@flag=0)
		begin
			select NA.Batch_Id,CBD.Batch_Code,CDP.Course_Department_Id,NA.Department_Id,CBD.Batch_From ,CBD.org_id,cdp.Course_Category_Id,cc.Program_Code --cc.Course_Code as Program_Code
			from dbo.tbl_New_Admission NA inner join dbo.Tbl_Candidate_Personal_Det CPD on       
			CPD.New_Admission_Id=NA.New_Admission_Id inner join Tbl_Course_Batch_Duration CBD      
			on CBD.Batch_Id=NA.Batch_Id    
			inner join dbo.Tbl_Course_Department CDP on CDP.Department_Id=NA.Department_Id   
			inner join Tbl_Course_Category cc on cc.Course_Category_Id = cdp.Course_Category_Id 
			--inner join Tbl_Department cc on cc.Department_Id = cdp.Course_Department_Id 
			where CPD.Candidate_Id= @CandidateId   
		end

	if(@flag=1)
		begin
			select NA.Batch_Id,CBD.Batch_Code,CDP.Course_Department_Id,NA.Department_Id,CBD.Batch_From ,CBD.org_id,cdp.Course_Category_Id,cc.Program_Code --cc.Course_Code as Program_Code
			from dbo.tbl_New_Admission NA inner join dbo.Tbl_Student_NewApplication NAP on       
			NAP.New_Admission_Id=NA.New_Admission_Id inner join Tbl_Course_Batch_Duration CBD      
			on CBD.Batch_Id=NA.Batch_Id    
			inner join dbo.Tbl_Course_Department CDP on CDP.Department_Id=NA.Department_Id   
			inner join Tbl_Course_Category cc on cc.Course_Category_Id = cdp.Course_Category_Id 
			--inner join Tbl_Department cc on cc.Department_Id = cdp.Course_Department_Id 
			where NAP.Candidate_Id= @CandidateId   
		end
end ')
END;
