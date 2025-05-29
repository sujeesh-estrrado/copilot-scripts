IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Department_Fine]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_Insert_Department_Fine]  
@Dept_Fine_Amount decimal(18,2),  
@Dept_Fine_Reason varchar(200),  
@Candidate_Id bigint,  
@Duration_Mapping_Id bigint,  
@Dept_Fine_Date datetime  
AS 

If Exists(select * from Tbl_Department_Fine where  Dept_Fine_Amount=@Dept_Fine_Amount and Candidate_Id=@Candidate_Id and Duration_Mapping_Id=@Duration_Mapping_Id and Dept_Fine_Date=@Dept_Fine_Date)           
BEGIN          
RAISERROR (''Data already exists.'', -- Message text.          
               16, -- Severity.          
               1 -- State.          
               );          
END          
ELSE 
BEGIN  
INSERT INTO   
Tbl_Department_Fine  
(  
Dept_Fine_Amount,  
Dept_Fine_Reason,  
Candidate_Id,  
Duration_Mapping_Id,  
Dept_Fine_Date)  
VALUES  
(  
@Dept_Fine_Amount,  
@Dept_Fine_Reason,  
@Candidate_Id,  
@Duration_Mapping_Id,  
@Dept_Fine_Date  
)  
Select Scope_Identity()
END');
END;
