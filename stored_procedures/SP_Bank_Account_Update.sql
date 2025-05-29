IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Bank_Account_Update]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Bank_Account_Update]      
@Account_Id bigint,      
@Bank_Id bigint,    
@Account_number varchar(50) ,
@Account_Type varchar(50)
  
AS  
if exists 
(select Account_number from Tbl_Bank_Account_Mapping where Account_number= @Account_number  and Account_Id<>@Account_Id )
BEGIN              
RAISERROR (''Bank name already exists.'', -- Message text.              
               16, -- Severity.              
               1 -- State.              
               );              
END              
ELSE   
BEGIN       
      
UPDATE dbo.Tbl_Bank_Account_Mapping  
   
   SET  Bank_Id= @Bank_Id,   
        Account_number=@Account_number,
        Account_Type=@Account_Type

        
 WHERE Account_Id=@Account_Id    
END
    ')
END;
