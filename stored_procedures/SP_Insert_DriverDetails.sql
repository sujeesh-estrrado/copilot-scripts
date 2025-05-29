IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_DriverDetails]') 
    AND type = N'P'
)
BEGIN
    EXEC('
   CREATE procedure [dbo].[SP_Insert_DriverDetails]      
(@Employee_Id bigint      
           ,@License_Number varchar(100)      
           ,@CurrentAge varchar(5)      
           ,@ReportingAuthority varchar(100)      
           ,@DeleteStatus bit      
)      
as      
 IF EXISTS (select * from Tbl_DriverDetails where License_Number=@License_Number and DeleteStatus=0)    
BEGIN    
     RAISERROR (''Driver with the same license number exists.'', -- Message text.        
               16, -- Severity.        
               1 -- State.        
               );        
END 

ELSE IF EXISTS (select * from Tbl_DriverDetails where Employee_Id=@Employee_Id and DeleteStatus=0)    
BEGIN    
     RAISERROR (''Driver already exists.'', -- Message text.        
               16, -- Severity.        
               1 -- State.        
               ); 
END      
    
ELSE    
    
    
Begin      
      
INSERT INTO [Tbl_DriverDetails]      
           ([Employee_Id]      
           ,[License_Number]      
           ,[CurrentAge]      
           ,[ReportingAuthority]      
           ,[DeleteStatus])      
     VALUES      
           (@Employee_Id      
           ,@License_Number      
           ,@CurrentAge      
           ,@ReportingAuthority      
           ,@DeleteStatus)      
      
End');
END;
