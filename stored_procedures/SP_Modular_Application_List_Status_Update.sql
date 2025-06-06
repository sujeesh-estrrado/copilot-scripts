IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Modular_Application_List_Status_Update]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_Modular_Application_List_Status_Update]         
   @Application_Status VARCHAR(50),
   @Modular_Candidate_Id BIGINT 
AS        
BEGIN        
    UPDATE Tbl_Modular_Candidate_Details 
    SET Application_Status = @Application_Status
    WHERE Modular_Candidate_Id = @Modular_Candidate_Id
END
   ')
END;
