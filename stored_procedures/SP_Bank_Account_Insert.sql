IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Bank_Account_Insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[SP_Bank_Account_Insert]        
@Bank_Id bigint,    
@Account_number varchar(50) ,
@Account_Type varchar(50)

     
AS   

IF exists (select * from Tbl_Bank_Account_Mapping where Account_number=@Account_number and Status=0 )
begin
RAISERROR (''Bank Account has been already registered.'', -- Message text.        
               16, -- Severity.        
               1 -- State.        
               );  
end

else
     
BEGIN        
 INSERT INTO Tbl_Bank_Account_Mapping       
           (Bank_Id,Account_number,Account_Type)        
     VALUES        
           (@Bank_Id,@Account_number,@Account_Type)        
END
    ')
END;
