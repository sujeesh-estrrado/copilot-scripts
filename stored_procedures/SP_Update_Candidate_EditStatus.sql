IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Candidate_EditStatus]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Update_Candidate_EditStatus]
(@Candidate_Id bigint,
@flag bigint=0)       
        
        
         
AS        
BEGIN   
    if(@flag=0)
        begin     
            Update Tbl_Candidate_Personal_Det set Editable=null,Edit_status=null,Edit_request=null  where Candidate_Id=@Candidate_Id
        end
    if(@flag=1)
        begin
            Update Tbl_Student_NewApplication set Editable=null,Edit_status=null,Edit_request=null  where Candidate_Id=@Candidate_Id      
        end
END 
    ')
END
