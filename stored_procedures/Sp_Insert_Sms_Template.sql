IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Insert_Sms_Template]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Insert_Sms_Template]    
(      
@Template_Content varchar(MAX),
@Template_Description varchar(MAX))    
    
As   
--IF EXISTS(SELECT Template_Content FROM dbo.Tbl_Sms_Template Where  Template_Content= @Template_Content)      
--BEGIN      
--RAISERROR (''Data Already Exists.'', -- Message text.      
--               16, -- Severity.      
--               1 -- State.      
--               );      
--END      
--ELSE      
     
Begin     
    
INSERT INTO Tbl_Sms_Template    
           ( Template_Content,Template_Description)    
     VALUES    
           (@Template_Content,@Template_Description)    
End
    ');
END;
