IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Captions]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Insert_Captions]        
        
 (@Title_Id bigint,        
     @Title_Name varchar(50))        
AS        
         
BEGIN         
    
  
  insert into Tbl_Title(Title_Id,Title_Name)        
  values(@Title_Id,@Title_Name)        
        
        
         
END');
END;
