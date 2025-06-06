-- Check if the stored procedure [dbo].[Proc_Insert_New_Admission] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Insert_New_Admission]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[Proc_Insert_New_Admission]                             
 (                            
                            
@Department_Id bigint=0,                         
@Batch_Id bigint=0,                           
@FromDate datetime='''',                            
@ToDate datetime='''',                            
@EndDate datetime='''' ,
@Course_Level_Id bigint=0,                            
@Course_Category_Id bigint=0    
                           
                           
)                            
AS                            
                    
--IF  EXISTS (SELECT New_Admission_Id FROM dbo.tbl_New_Admission WHERE Course_Level_Id=@Course_Level_Id and Course_Category_Id=@Course_Category_Id and               
--Batch_Id=@Batch_Id and FromDate=@FromDate and EndDate=@EndDate and Admission_Status=0 )                    
--BEGIN                    
--  RAISERROR (''''Admission closed.'''', -- Message text.                    
--               16, -- Severity.                    
--               1 -- State.                    
--               );                    
--END           
--ELSE IF EXISTS (SELECT New_Admission_Id FROM dbo.tbl_New_Admission WHERE Course_Level_Id=@Course_Level_Id and Course_Category_Id=@Course_Category_Id and           
--Department_Id=@Department_Id and Batch_Id=@Batch_Id and Admission_Status=1 )                    
--BEGIN                    
--  RAISERROR (''''Data already Exists.'''', -- Message text.                    
--               16, -- Severity.                    
--               1 -- State.                    
--               );                    
--END                    
--ELSE                
                         
BEGIN                        
--DECLARE @New_Admission_Id AS BIGINT;                            
                             
  insert into dbo.tbl_New_Admission                            
(Department_Id,Batch_Id,FromDate,ToDate,EndDate,Admission_Status,Course_Category_Id,Course_Level_Id)                            
                            
  values                            
(@Department_Id,@Batch_Id,@FromDate,@ToDate,@EndDate,1,@Course_Category_Id,(select GraduationTypeId from Tbl_Department where Department_Id=@Department_Id))                      
                      
--select SCOPE_IDENTITY()    
select SCOPE_IDENTITY()                 
--                      
--SELECT  @New_Admission_Id                           
--                            
END
    ')
END
