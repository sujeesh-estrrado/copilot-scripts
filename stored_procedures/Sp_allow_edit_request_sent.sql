IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_allow_edit_request_sent]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Sp_allow_edit_request_sent](@Candidate_Id bigint)
 
    
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    update Tbl_Candidate_Personal_Det set Edit_request=1
    where Candidate_Id=@Candidate_Id;

    -- Insert statements for procedure here
    
END





    ')
END
