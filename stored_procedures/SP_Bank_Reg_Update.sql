IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Bank_Reg_Update]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Bank_Reg_Update]      
@Bank_Id bigint,      
@Bank_Name varchar(50) ,  
@Branch_Name varchar(50),
@Address varchar(500),
@IFSC_Code varchar(50),
@Account_Type varchar(50)
  
AS  
if exists 
(select Bank_Name , IFSC_Code from Tbl_Bank_Registration where Bank_Name= @Bank_Name and IFSC_Code=@IFSC_Code and Bank_Id<>@Bank_Id )
BEGIN              
RAISERROR (''Bank name already exists.'', -- Message text.              
               16, -- Severity.              
               1 -- State.              
               );              
END              
ELSE   
BEGIN       
      
UPDATE dbo.Tbl_Bank_Registration  
   
   SET  Bank_Name= @Bank_Name,   
        Branch_Name=@Branch_Name ,
        Address=@Address,
        IFSC_Code=@IFSC_Code,
        Account_Type=@Account_Type

        
 WHERE Bank_Id=@Bank_Id      
END

    ')
END;
