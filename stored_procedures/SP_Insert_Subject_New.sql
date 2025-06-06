IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Subject_New]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[SP_Insert_Subject_New]          
(          
@Subject_Code varchar(50),          
@Subject_Description varchar(50),          
@Subject_Date datetime,          
@Assessment_Code varchar(50),          
@ProviderId bigint,          
@Contact_Hours int,          
@Subject_Total_Hours bigint,          
@Credit bigint,          
@FieldofStudy varchar(50),          
@Abbreviation varchar(20),          
@Subject_Current_Status varchar(50),          
@drop_Date datetime,          
@subject_master_codeid bigint          
)          
AS          
IF EXISTS(SELECT Subject_Name FROM Tbl_Subject Where Subject_Name = @Subject_Description and Subject_Code=@Subject_Code and Subject_Status=0)          
          
BEGIN      
select 0      
    
--RAISERROR (''Data Already Exists.'', -- Message text.                    
--               16, -- Severity.                    
--               1 -- State.                    
--               );                    
END                    
ELSE                    
                     
BEGIN             
          
INSERT INTO dbo.Tbl_Subject(Parent_Subject_Id,Subject_Name,Subject_Code,Subject_Descripition,Subject_Date,          
Subject_Status,Assessment_Code,ProviderId,Contact_Hours,Subject_Total_Hours,Credit_Points,          
Field_of_Study,Abbreviation,Subject_Current_Status,Drop_Date,Subject_Master_Code_Id)          
          
VALUES (0,@Subject_Description,@Subject_Code,@Subject_Description,@Subject_Date,0,@Assessment_Code,          
@ProviderId,@Contact_Hours,@Subject_Total_Hours,@Credit,@FieldofStudy,@Abbreviation,@Subject_Current_Status,          
@drop_Date,@subject_master_codeid)          
          
 SELECT SCOPE_IDENTITY()          
           
 END   
    ')
END
