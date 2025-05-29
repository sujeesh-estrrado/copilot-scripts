IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Insert_Sms_Group]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Insert_Sms_Group]    
(       
@Group_Name varchar(150))    
    
As   

Begin     
    
INSERT INTO Tbl_Sms_Group    
           ( Group_Name)    
     VALUES    
           (@Group_Name)    
End


   ')
END;
