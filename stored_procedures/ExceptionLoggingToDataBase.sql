IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[ExceptionLoggingToDataBase]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[ExceptionLoggingToDataBase]  
(  
@ExceptionMsg varchar(100)=null,  
@ExceptionType varchar(100)=null,  
@ExceptionSource nvarchar(max)=null,  
@ExceptionURL varchar(100)=null,
@AdditionalInfo  varchar(max)=null
)  
as  
begin  
Insert into Tbl_ExceptionLoggingToDataBase  
(  
ExceptionMsg ,  
ExceptionType,   
ExceptionSource,  
ExceptionURL,  
Logdate,
AdditionalInfo  
)  
select  
@ExceptionMsg,  
@ExceptionType,  
@ExceptionSource,  
@ExceptionURL,
getdate() ,
@AdditionalInfo
End  

   ')
END;
