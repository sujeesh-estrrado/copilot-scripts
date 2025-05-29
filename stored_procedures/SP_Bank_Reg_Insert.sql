IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Bank_Reg_Insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Bank_Reg_Insert]        
@Bank_Name varchar(50),    
@Branch_Name varchar(50) ,
@Address varchar(500) ,
@IFSC_Code varchar(50),
@Account_Type varchar(50)
     
AS   

IF exists (select * from Tbl_Bank_Registration where Bank_Name=@Bank_Name and IFSC_Code=@IFSC_Code and Status=0 )
begin
RAISERROR (''Bank has been already registered.'', -- Message text.        
               16, -- Severity.        
               1 -- State.        
               );  
end

else
     
BEGIN        
 INSERT INTO Tbl_Bank_Registration       
           (Bank_Name,Branch_Name,Address,IFSC_Code,Account_Type)        
     VALUES        
           (@Bank_Name,@Branch_Name,@Address,@IFSC_Code,@Account_Type)        
END

    ')
END;
