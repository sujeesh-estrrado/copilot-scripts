IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Editdisable]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Update_Editdisable]                              
(@Candidate_Id bigint,          
@EditDisable varchar(50)  
)                            
AS                              
BEGIN                              
UPDATE Tbl_Candidate_Personal_Det SET EditDisable=@EditDisable WHERE Candidate_Id=@Candidate_Id    
                    
END           
          
          
          
          
--select Bh1M_Doc_Name,Disability_Doc_name from Tbl_Candidate_Personal_Det  
    ')
END;
