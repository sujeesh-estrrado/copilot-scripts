IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Division]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[SP_Update_Division]          
(@Department_Id bigint,@Department_Name varchar(300),@Department_Descripition varchar(500),@CourseCode varchar(50),    
@Introdate datetime,@GraduationTypeId bigint)          
as         
--IF EXISTS(SELECT Department_Name FROM dbo.Tbl_Department Where Department_Name = @department_name                  
-- and Department_Status=0 and Department_Id<>@Department_Id )                      
--BEGIN                      
--RAISERROR (''Data Already Exists.'', -- Message text.                      
--               16, -- Severity.                      
--               1 -- State.                      
--               );                      
--END                      
--ELSE         
        
Begin          
          
Update dbo.Tbl_Department          
          
set           
          
Department_Name=@Department_Name,          
Department_Descripition=@Department_Descripition ,      
Course_Code  =@CourseCode,    
Intro_Date  = @Introdate,  
GraduationTypeId = @GraduationTypeId   
where Department_Id=@Department_Id          
          
end  
  
--  select * from Tbl_Department
    ')
END
